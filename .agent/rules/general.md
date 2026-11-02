# Rule: general behaviour

1. Read before you change: inspect existing code and match its style, naming and structure.
2. Keep changes scoped to the task; no drive-by refactors.
3. Don't invent facts (product decisions, APIs, protocols, hardware pins). Ask, or mark as `TBD`.
4. Never put secrets, keys, Wi-Fi credentials or personal data in the repo.
5. Report outcomes honestly: say what was verified, what failed and what was skipped.
6. Use the FVM-pinned toolchain: `fvm flutter …` / `fvm dart …` — never bare `flutter`/`dart`.
