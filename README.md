# Develop Skills

Version-controlled global engineering rules shared by Codex and Claude Code.

## Managed files

- `rules/AGENTS.md`: shared cross-project engineering rules
- `rules/CLAUDE.md`: Claude Code-specific skill and memory rules
- `skills/backend-code-guide/`: opt-in project skill for backend API, service, and Prisma access
- `skills/frontend-api-docs/`: user skill for repository-aware frontend API integration docs
- `skills/iteration-delivery/`: user skill for human-in-the-loop feature delivery
- `install.sh`: idempotent macOS/Linux symlink installer

The installer creates these links:

```text
~/.codex/AGENTS.md                         -> rules/AGENTS.md
~/.claude/rules/shared-engineering.md      -> rules/AGENTS.md
~/.claude/CLAUDE.md                        -> rules/CLAUDE.md
~/.codex/skills/frontend-api-docs          -> skills/frontend-api-docs
~/.claude/skills/frontend-api-docs         -> skills/frontend-api-docs
~/.codex/skills/iteration-delivery         -> skills/iteration-delivery
~/.claude/skills/iteration-delivery        -> skills/iteration-delivery
```

Codex loads `~/.codex/AGENTS.md` as global guidance. Claude Code loads its global
`CLAUDE.md` and user-level files under `~/.claude/rules/`.

## Install

Clone the repository to any stable location and run the installer:

```sh
git clone git@github.com:bencode/develop-skills.git
cd develop-skills
./install.sh
```

If an installation target already exists and is not the expected link, the installer moves it
to a unique timestamped `*.backup-YYYYMMDD-HHMMSS` path before creating the link. Re-running
the installer with correct links is a no-op.

When `CODEX_HOME` is set, the Codex link is installed there instead of `~/.codex`. For isolated
installer verification, set `DEVELOP_SKILLS_TARGET_HOME` to a temporary home directory.

The backend skill is project-specific and is not installed globally. Explicitly enable it for one
project by passing the project's absolute path:

```sh
DEVELOP_SKILLS_PROJECT_ROOT=/absolute/path/to/project ./install.sh
```

This creates both project-local links:

```text
<project>/.codex/skills/backend-code-guide  -> skills/backend-code-guide
<project>/.claude/skills/backend-code-guide -> skills/backend-code-guide
```

Existing targets use the same timestamped backup behavior as the global rule links. Re-running the
installer with the correct links is a no-op.

## Update

Pulling this repository updates both tools immediately because the installed files are links:

```sh
git pull --ff-only
```

Start new Codex and Claude Code sessions after changing rules. If the repository is moved, run
`./install.sh` again to replace the old absolute links.

## Verify

Inspect the installed targets:

```sh
readlink ~/.codex/AGENTS.md
readlink ~/.claude/rules/shared-engineering.md
readlink ~/.claude/CLAUDE.md
readlink ~/.codex/skills/iteration-delivery
readlink ~/.claude/skills/iteration-delivery
```

For a project where the backend skill was explicitly enabled, also inspect:

```sh
readlink /absolute/path/to/project/.codex/skills/backend-code-guide
readlink /absolute/path/to/project/.claude/skills/backend-code-guide
```

In a new Codex session, ask it to summarize its current instructions. In Claude Code, use
`/memory` to confirm that `CLAUDE.md` and `shared-engineering.md` are loaded.

Project-level instructions are loaded after global instructions and can override them. The shared
rules therefore require an explicit user confirmation when a project asks to enable Superpowers.

## Iteration delivery

Invoke `$iteration-delivery` in Codex or `/iteration-delivery` in Claude Code when organizing an
end-to-end feature iteration. It provides a recommended, risk-adjusted path from scope alignment to
a validated PR while preserving human decisions and authorization boundaries. Codex invocation is
explicit-only; Claude Code uses the same narrowly scoped skill source.

## Restore a backup

Remove the corresponding installed link and move the desired timestamped backup back to its
original path. Backups are never deleted automatically.

## Windows

The installer targets macOS and Linux. On Windows, either enable Developer Mode and create the
equivalent links manually, or copy the rule files and repeat the copy after updates.

## References

- [Codex AGENTS.md](https://learn.chatgpt.com/docs/agent-configuration/agents-md)
- [Claude Code memory and rules](https://code.claude.com/docs/en/memory)
