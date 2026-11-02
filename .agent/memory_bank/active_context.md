# Active context — mobile

_What is being worked on right now. Overwrite freely; keep it short._

**Last updated:** 2026-11-03

## Current focus
Toolchain and dependency upgrade (uncommitted in the working tree):
- Flutter 3.27.0 → 3.47.4 (`.fvmrc`), Dart SDK `^3.13.3` in all packages.
- Storage moved from hive/isar to **sembast**; `material_ui` / `cupertino_ui` packages added; most deps bumped.
- `analysis_options.yaml` rewritten (flutter_lints 6 + dart_code_metrics `recommended` config).
- New package `shared_utils` (pure Dart; `list_parser.dart`).

**Current feature:** _none_ <!-- set to `<name>` → features/<name>/ when a feature starts -->

## Next steps
- Finish the upgrade until `fvm flutter analyze` is clean; owner commits.
- Add tests (`shared_utils` has the `test` dependency but no `test/` yet; `app/test/widget_test.dart` is empty).
