Review <the current diff | branch <name> | files <paths>>.
Follow .agent/rules/. Look for: correctness bugs, edge cases, state/lifecycle issues (dispose, subscriptions, MobX reactions, `BuildContext` after async gaps), BLE connection handling, and
deviations from .agent/memory_bank/system_patterns.md. Report findings ranked by
severity with file:line and a concrete failure scenario. Don't change code.
