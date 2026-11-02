# Rule: Flutter code

1. Respect package layering: `shared_utils` (pure Dart) ← `core` ← `core_ui` ← `app`.
   Lower packages never import higher ones; `shared_utils` never imports Flutter.
2. Use package imports (`package:app/...`), not relative imports into `lib/`.
   Expose public API through the folder's `index.dart` barrel (or `core.dart` / `core_ui.dart` / `shared_utils.dart`).
3. New screens follow the VPD architecture (see `memory_bank/system_patterns.md` and `workflows/add_screen.md`).
4. Never edit generated files (`*.g.dart`); regenerate them with build_runner.
5. User-facing strings go through localization (en + ru), not hard-coded text.
6. Keep the lints clean (`analysis_options.yaml`: flutter_lints + dart_code_metrics config). Don't disable a rule to make code pass without asking.
7. Don't add or upgrade dependencies without the owner's OK; pin exact versions like the existing `pubspec.yaml` files.
