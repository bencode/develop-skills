#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
shared_source="$script_dir/rules/AGENTS.md"
claude_source="$script_dir/rules/CLAUDE.md"

if [ ! -f "$shared_source" ] || [ ! -f "$claude_source" ]; then
  echo 'Rule files are missing from the repository.' >&2
  exit 1
fi

if [ -n "${DEVELOP_SKILLS_TARGET_HOME:-}" ]; then
  target_home=$DEVELOP_SKILLS_TARGET_HOME
  codex_dir="$target_home/.codex"
  claude_dir="$target_home/.claude"
else
  target_home=$HOME
  codex_dir=${CODEX_HOME:-"$target_home/.codex"}
  claude_dir="$target_home/.claude"
fi

backup_stamp=$(date '+%Y%m%d-%H%M%S')

next_backup_path() {
  target=$1
  candidate="${target}.backup-${backup_stamp}"
  suffix=1

  while [ -e "$candidate" ] || [ -L "$candidate" ]; do
    candidate="${target}.backup-${backup_stamp}-${suffix}"
    suffix=$((suffix + 1))
  done

  printf '%s\n' "$candidate"
}

link_rule() {
  source=$1
  target=$2
  target_dir=$(dirname -- "$target")

  mkdir -p "$target_dir"

  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
    printf 'unchanged %s -> %s\n' "$target" "$source"
    return
  fi

  if [ -e "$target" ] || [ -L "$target" ]; then
    backup=$(next_backup_path "$target")
    mv "$target" "$backup"
    printf 'backed up %s -> %s\n' "$target" "$backup"
  fi

  ln -s "$source" "$target"
  printf 'linked %s -> %s\n' "$target" "$source"
}

link_rule "$shared_source" "$codex_dir/AGENTS.md"
link_rule "$shared_source" "$claude_dir/rules/shared-engineering.md"
link_rule "$claude_source" "$claude_dir/CLAUDE.md"

echo 'Installation complete. Start new Codex and Claude Code sessions to load the rules.'
