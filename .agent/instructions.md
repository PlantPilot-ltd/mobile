# Agent instructions — PlantPilot mobile

These instructions apply to every agent and model working on this project.
Your context resets between sessions — the **memory bank** is your only link to
previous work, so read it and keep it accurate.

## 0. Scope — which `.agent` to use
| Work | Use |
| --- | --- |
| Only this project | **this** `.agent/` (and this repo's `docs/features/`, `features/`) |
| Spans several projects (e.g. firmware + mobile), or changes the workspace | root `.agent/` (`../../.agent/`), root `docs/features/`, root `features/` — plus this `.agent/` for project details |

Record knowledge where it belongs: facts about this project → this memory bank;
cross-project facts (shared protocols, workspace setup) → root memory bank.

## 1. Session start (always)
Follow [`workflows/session_start.md`](workflows/session_start.md). In short, read:
1. All files in [`rules/`](rules/).
2. [`memory_bank/project_brief.md`](memory_bank/project_brief.md), [`active_context.md`](memory_bank/active_context.md), [`progress.md`](memory_bank/progress.md).
3. As the task requires: [`tech_context.md`](memory_bank/tech_context.md) (stack, commands),
   [`system_patterns.md`](memory_bank/system_patterns.md) (architecture, code patterns),
   [`decisions.md`](memory_bank/decisions.md).
4. Product context is shared by all projects: root `.agent/memory_bank/product_context.md` (if the workspace is present).

## 2. While working
- Rules beat everything except an explicit instruction from the user in the current session.
- If a workflow exists for the task (see [`workflows/`](workflows/)), follow it.
- If the memory bank contradicts the code, trust the code and fix the memory bank.
- Ask the user when a decision is genuinely theirs.

## 3. Features
Single-project features follow [`workflows/feature.md`](workflows/feature.md):
description in `docs/features/<name>.md`, tracking in `features/<name>/`.
Triggers: "start feature `<name>`", "continue feature `<name>`", "finish feature `<name>`".
If the description is in the **root** `docs/features/`, it's a cross-project feature — use the root workflow.

## 4. Session end / after significant work
Follow [`workflows/update_memory_bank.md`](workflows/update_memory_bank.md); also when the user says **"update memory bank"**.

## 5. Changing the agent system itself
Follow [`rules/agent_files.md`](rules/agent_files.md).
