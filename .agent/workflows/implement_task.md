# Workflow: implement a task

For any coding task in this project. If it belongs to a feature, also follow `feature.md` (section B).

1. Clarify the goal and acceptance criteria; ask the owner about open product decisions.
2. Read `memory_bank/system_patterns.md` and the code around the change; follow existing patterns.
3. For non-trivial work, propose a short plan (files to touch, approach) before coding.
4. Implement in small steps and verify as you go:
   - `fvm flutter analyze` in the package you changed (`app`, `core`, `core_ui`)
   - `fvm flutter test` where tests exist; `fvm dart test` in `shared_utils`
   - MobX stores changed → `fvm dart run build_runner build --delete-conflicting-outputs` in `app`
5. Summarise what changed and how it was verified. Git is read-only: give the owner the commands to commit.
6. Run `update_memory_bank.md`.
