# Workflow: update memory bank

Run after significant work, at session end, or when the user says "update memory bank".

1. Review what changed this session (code, decisions, open questions).
2. Update, in order:
   - `active_context.md` — current focus, recent changes, next steps (overwrite; keep short; update date).
   - `progress.md` — move items to Done, add/close open questions (update date).
   - `decisions.md` — append decisions the user made, with the reason.
   - `tech_context.md` / `system_patterns.md` — only if stack, commands or architecture changed.
   - `project_brief.md` — only if scope changed.
3. Cross-project facts (shared protocols, workspace setup) go to the **root** memory bank instead.
4. Remove information that is no longer true; don't duplicate code or git history. Absolute dates, no secrets.
5. Tell the user which memory bank files you changed.
