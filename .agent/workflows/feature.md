# Workflow: single-project feature

For features that touch **only this project**. Features spanning several projects
are described in the root `docs/features/` and tracked in the root `features/`
(root `.agent/workflows/feature.md`).

| Where | Who writes | What |
| --- | --- | --- |
| `docs/features/<name>.md` | Owner | **Source of truth**: what and why, product language |
| `features/<name>/` | Agent (owner may edit) | requirements, plan, log |
| project code | Agent, on owner's request | the implementation |

## A. Start — owner says "start feature `<name>`"
1. Read `docs/features/<name>.md`. Not found here? Check the root `docs/features/` → cross-project, use the root workflow.
   Not found anywhere? Ask the owner to write it from `docs/features/_template.md`; don't invent it.
2. Create `features/<name>/` from `.agent/templates/feature/*`; fill in placeholders.
3. Derive numbered, sourced requirements and testable acceptance criteria in `requirements.md`; list open questions.
4. Draft `plan.md` with tasks linked to requirements.
5. Add a row to `features/README.md`; set the current feature in `memory_bank/active_context.md`.
6. Show the owner a summary + open questions and **wait for confirmation** before coding.

## B. Work — owner gives tasks
At the start of each session: read the description, then `features/<name>/` (README → requirements → plan → last log entries).
Check whether the description changed since the last sync (`git log -1 -- docs/features/<name>.md`,
`git diff -- docs/features/<name>.md`); if so, re-sync requirements and tell the owner.

For each task:
1. Map it to requirement(s); if not covered, ask whether to add it (`[owner: YYYY-MM-DD]`).
2. If it conflicts with the description, stop and ask — never silently diverge.
3. Implement following `implement_task.md`.
4. Update `plan.md`, tick met items in `requirements.md`, append to `log.md`.
5. If the task turns out to need another project, tell the owner: the feature should move to the root workflow.

## C. Finish — owner says "finish feature `<name>`"
1. Check every requirement and acceptance criterion; list anything unmet.
2. Set status `done` in `features/<name>/README.md` and `features/README.md`.
3. Final `log.md` entry: what shipped, limitations, follow-ups.
4. Move lasting knowledge into the memory bank; clear the feature from `active_context.md`.
5. Give the owner the git commands (branch `feature/<name>`): commit, push, PR; then the root pointer bump.
