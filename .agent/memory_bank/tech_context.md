# Tech context — mobile

## Toolchain
- Flutter pinned by FVM in `.fvmrc`: **3.47.4** (working tree; last commit had 3.27.0 — see active_context). Dart SDK `^3.13.3`.
- Always `fvm flutter …` / `fvm dart …`. Setup: `brew tap leoafarias/fvm && brew install fvm`, then `fvm install`.

## Packages (local path dependencies)
| Package | Role | Notes |
| --- | --- | --- |
| `app` | The application | `entities/`, `presentation/`, `providers/`, `repositories/`, `services/` |
| `core` | Shared logic: app runner, models, `LogService` | MobX |
| `core_ui` | UI kit: widgets (`CoreUI*`), theme, assets, fonts, localization, VPD screen architecture | |
| `shared_utils` | Pure Dart utilities (no Flutter), usable from any package | Test with `fvm dart test` |

## Key dependencies (app)
material_ui, cupertino_ui · provider · get_it (DI) · go_router · mobx/flutter_mobx (+ mobx_codegen, build_runner) ·
flutter_blue_plus (BLE) · http + http_interceptor · sembast + shared_preferences + path_provider (cache) ·
intl (l10n en/ru) · equatable, collection · lottie · app_settings.

## Commands
| Task | Command (inside the package) |
| --- | --- |
| Get deps | `fvm flutter pub get` |
| Analyze | `fvm flutter analyze` |
| Tests | `fvm flutter test` (`app`), `fvm dart test` (`shared_utils`) |
| Codegen (MobX) | `fvm dart run build_runner build --delete-conflicting-outputs` (`app`) |
| Run | `fvm flutter run --dart-define-from-file assets/.env/dev.env` (in `app`) |

## Environments
`.vscode/launch.json` has **Dev** and **Mock** configs (`--dart-define-from-file assets/.env/{dev,mock}.env`)
and a profile-mode config. `app/assets/.env/` is empty in the repo — env files are distributed separately (TBD by the team); never commit secrets there.
Mock HTTP services live in `app/lib/services/http/mock/`.
