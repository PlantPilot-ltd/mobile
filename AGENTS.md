# AGENTS.md — PlantPilot mobile

This repository uses a tool-neutral agent system stored in [`.agent/`](.agent/).

**Before doing anything else, read [`.agent/instructions.md`](.agent/instructions.md) and follow it.**

This repo is also a submodule of the PlantPilot workspace (`PlantPilot-ltd/root`, folder `frontend/mobile`).
If the workspace root is present (`../../AGENTS.md`), work that spans several
projects or changes the whole workspace follows the root `.agent/` instead.

Features of this project: the owner describes them in `docs/features/<name>.md`;
work on each is tracked in `features/<name>/` — see `.agent/workflows/feature.md`.

Non-negotiable even if you read nothing else:
- Git is read-only for agents: never stage, commit, checkout, push, pull or otherwise change git state. Read commands (status, log, diff, show, …) are fine. See `.agent/rules/git.md`.
- Keep agent files tool-neutral: everything lives in `.agent/`. Do not create `CLAUDE.md`, `.claude/`, `.cursor/`, `.github/copilot-instructions.md` or similar.
