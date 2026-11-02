# .agent — PlantPilot mobile agent system

Tool-neutral instructions and memory for any AI coding agent working on **this project**.
Plain Markdown; humans can read and edit everything.

| Path | Purpose | Who updates it |
| --- | --- | --- |
| `instructions.md` | Entry point: session start, read order, scope | Team |
| `memory_bank/` | Persistent knowledge about this project | Agents + team |
| `rules/` | Hard constraints | Team (agents only on request) |
| `workflows/` | Step-by-step procedures | Team + agents |
| `prompts/` | Reusable prompt templates for humans | Team |
| `templates/` | File templates agents copy (feature folders) | Team |
| `hooks/` | Tool-agnostic scripts to wire into your agent's hooks | Team |

Related folders in this repo:
- `docs/features/` — single-project feature descriptions by the owner (source of truth).
- `features/<name>/` — agent-maintained working folder per feature.

## Relation to the workspace root
This project is the `frontend/mobile` submodule of `PlantPilot-ltd/root`. The root `.agent/`
holds workspace-wide rules and cross-project knowledge (features spanning several
projects, contracts between them). **Everything specific to this project lives here.**

`rules/git.md` and `hooks/git_read_only_check.sh` are mirrored from the root and must stay
identical in every project — change them in all repos together.

## Conventions
- File names: `snake_case.md`, one topic per file, relative links.
- Absolute dates (`YYYY-MM-DD`). No secrets — this folder is committed.
