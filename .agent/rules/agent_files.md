# Rule: agent files

1. Everything agent-related for this project lives in `.agent/`. `AGENTS.md` is only a pointer.
2. Do **not** create tool-specific files or folders: `CLAUDE.md`, `.claude/`, `.cursor/`,
   `.cursorrules`, `.windsurfrules`, `.github/copilot-instructions.md`, `GEMINI.md`,
   `.clinerules`, etc. If a tool needs one locally, keep it out of git.
3. Plain Markdown, generic `snake_case` names.
4. Put content in the right place:
   - hard constraint → `rules/` · repeatable procedure → `workflows/`
   - reusable prompt → `prompts/` · file templates → `templates/`
   - knowledge / state of **this project** → `memory_bank/`
   - single-project feature: description (owner) → `docs/features/<name>.md`; tracking → `features/<name>/`
   - anything cross-project or workspace-wide → root `.agent/` (not here)
5. `rules/git.md` and `hooks/git_read_only_check.sh` are mirrored from the root `.agent/`; keep them identical.
6. Do not change `rules/` without the user's request. Memory bank and workflows may be updated by agents.
