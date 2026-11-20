# Develop Skills

Version-controlled global engineering rules shared by Codex and Claude Code.

## Managed files

- `rules/AGENTS.md`: shared cross-project engineering rules
- `rules/CLAUDE.md`: Claude Code-specific skill and memory rules
- `skills/backend-code-guide/`: opt-in project skill for backend API, service, and Prisma access
- `skills/frontend-code-guide/`: opt-in project skill for frontend modules, Schema integration, and server state
- `skills/frontend-api-docs/`: user skill for repository-aware frontend API integration docs
- `skills/feature-development/`: explicit user skill for human-in-the-loop feature delivery
- `skills/implementation-design/`: user skill for implementation-ready technical design
- `skills/defect-fix/`: user skill for root-cause defect fixes with red-green proof
- `install.sh`: idempotent macOS/Linux symlink installer

The installer creates these links:

```text
~/.codex/AGENTS.md                         -> rules/AGENTS.md
~/.claude/rules/shared-engineering.md      -> rules/AGENTS.md
~/.claude/CLAUDE.md                        -> rules/CLAUDE.md
~/.codex/skills/frontend-api-docs          -> skills/frontend-api-docs
~/.claude/skills/frontend-api-docs         -> skills/frontend-api-docs
~/.codex/skills/feature-development        -> skills/feature-development
~/.claude/skills/feature-development       -> skills/feature-development
~/.codex/skills/implementation-design      -> skills/implementation-design
~/.claude/skills/implementation-design     -> skills/implementation-design
~/.codex/skills/defect-fix                 -> skills/defect-fix
~/.claude/skills/defect-fix                -> skills/defect-fix
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

The backend and frontend code guides are project-specific and are not installed globally. Explicitly
enable them for one project by passing the project's absolute path:

```sh
DEVELOP_SKILLS_PROJECT_ROOT=/absolute/path/to/project ./install.sh
```

This creates the project-local links for both tools:

```text
<project>/.codex/skills/backend-code-guide  -> skills/backend-code-guide
<project>/.claude/skills/backend-code-guide -> skills/backend-code-guide
<project>/.codex/skills/frontend-code-guide -> skills/frontend-code-guide
<project>/.claude/skills/frontend-code-guide -> skills/frontend-code-guide
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
readlink ~/.codex/skills/feature-development
readlink ~/.claude/skills/feature-development
readlink ~/.codex/skills/implementation-design
readlink ~/.claude/skills/implementation-design
```

For a project where the code guides were explicitly enabled, also inspect:

```sh
readlink /absolute/path/to/project/.codex/skills/backend-code-guide
readlink /absolute/path/to/project/.claude/skills/backend-code-guide
readlink /absolute/path/to/project/.codex/skills/frontend-code-guide
readlink /absolute/path/to/project/.claude/skills/frontend-code-guide
```

In a new Codex session, ask it to summarize its current instructions. In Claude Code, use
`/memory` to confirm that `CLAUDE.md` and `shared-engineering.md` are loaded.

Project-level instructions are loaded after global instructions and can override them. The shared
rules therefore require an explicit user confirmation when a project asks to enable Superpowers.

## Frontend development

`frontend-code-guide` supports implementation and review: module ownership, shared UI, package
boundaries, and API/server-state behavior. It follows the project's actual framework and contracts.
The optional module-boundaries reference distinguishes business ownership from Schema integration;
its Widget convention applies only where Widget means a Schema entry, not an FSD layer. It contains
no application-specific profile and does not authorize directory migrations.

`frontend-api-docs` instead writes API integration documents for frontend agents. Use the code guide
for implementation and the documentation guide for documenting the call path.

Replacing an existing project-local guide preserves it in a timestamped backup and links the
project to the shared source. Project-specific rules belong in that project's own instructions.

## Feature development and implementation design

Invoke `$feature-development` in Codex or `/feature-development` in Claude Code when organizing an
end-to-end feature. It provides a recommended, risk-adjusted path from scope alignment to a
validated delivery while preserving human decisions and authorization boundaries. Its Codex
invocation remains explicit-only.

`implementation-design` turns confirmed requirements into an implementation-ready technical
design. It is available for automatic Codex selection on implementation-plan and detailed-design
requests, and `feature-development` uses it at the Design checkpoint. It defines package and module
dependencies, software constructs, models, contracts, runtime semantics, validation, and one final
file-construct tree as the implementation boundary without forcing a repository design document.

The installer removes an obsolete `iteration-delivery` link only when it points to this repository's
former managed skill path. Files, directories, and links owned elsewhere are preserved.

## Restore a backup

Remove the corresponding installed link and move the desired timestamped backup back to its
original path. Backups are never deleted automatically.

## Windows

The installer targets macOS and Linux. On Windows, either enable Developer Mode and create the
equivalent links manually, or copy the rule files and repeat the copy after updates.

## References

- [Codex AGENTS.md](https://learn.chatgpt.com/docs/agent-configuration/agents-md)
- [Claude Code memory and rules](https://code.claude.com/docs/en/memory)
