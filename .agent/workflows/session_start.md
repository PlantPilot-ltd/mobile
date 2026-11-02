# Workflow: session start

1. Read every file in `.agent/rules/`.
2. Read `memory_bank/project_brief.md`, `active_context.md`, `progress.md`.
3. Read further memory bank files as the task requires (see `instructions.md`).
4. Decide the scope (`instructions.md` §0). If the task spans other projects, also load
   the root `.agent/` and follow it for the cross-project parts.
5. If `active_context.md` names a current feature, read `docs/features/<name>.md` and `features/<name>/`.
6. Check repo state read-only: `git status`, `git branch --show-current`.
7. If memory bank and reality disagree, note it and fix the memory bank at the end.
