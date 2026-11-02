# Decision log — mobile

Append-only, newest at the bottom: `## YYYY-MM-DD — Title` · **Decision** · **Why** · **Alternatives**.
Cross-project decisions are in the root `.agent/memory_bank/decisions.md`.

## (before 2026-10-29) — VPD screen architecture with MobX
**Decision:** each screen = Dependencies + MobX Store + Presenter + View + Router.
**Why:** _TBD — record the reason if known._

## 2026-11-03 — Project-level agent system
**Decision:** mobile-specific agent knowledge lives in this repo's `.agent/`; the root `.agent/` only covers workspace-wide and cross-project work.
**Why:** the owner wants each project self-contained; the root is for global changes.
