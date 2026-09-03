#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
shared_source="$script_dir/rules/AGENTS.md"
claude_source="$script_dir/rules/CLAUDE.md"
backend_skill_source="$script_dir/skills/backend-code-guide"

if [ ! -f "$shared_source" ] || [ ! -f "$claude_source" ] || \
  [ ! -f "$backend_skill_source/SKILL.md" ]; then
  echo 'Managed rule or skill files are missing from the repository.' >&2
  exit 1
fi

project_root=
if [ -n "${DEVELOP_SKILLS_PROJECT_ROOT:-}" ]; then
  if [ ! -d "$DEVELOP_SKILLS_PROJECT_ROOT" ]; then
    echo 'DEVELOP_SKILLS_PROJECT_ROOT must be an existing directory.' >&2
    exit 1
  fi

  project_root=$(CDPATH= cd -- "$DEVELOP_SKILLS_PROJECT_ROOT" && pwd -P)
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

if [ -n "$project_root" ]; then
  link_rule "$backend_skill_source" "$project_root/.codex/skills/backend-code-guide"
  link_rule "$backend_skill_source" "$project_root/.claude/skills/backend-code-guide"
fi

echo 'Installation complete. Start new Codex and Claude Code sessions to load the rules.'
