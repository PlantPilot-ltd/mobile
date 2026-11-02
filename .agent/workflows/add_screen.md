# Workflow: add a screen

Screens live in `app/lib/presentation/screens/<screen_name>/` and follow VPD
(View – Presenter – DataStore, base classes in `core_ui/lib/screen_architecture/vpd_architecture.dart`).
Use an existing screen (e.g. `greenhouse_add/`) as the reference.

1. Create the folder with these files:
   - `<name>_dependencies.dart` — immutable class with everything the screen needs (router, logger, repositories, services, arguments).
   - `<name>_store.dart` — MobX store (`part '<name>_store.g.dart';`): observable state + actions, data loading.
   - `<name>_presenter.dart` — extends `VPDPresenter<Store>`; owns controllers, handles UI events, `initState`/`dispose`.
   - `<name>_screen.dart` — the widget (view); reads state from the store via the presenter.
   - `<name>_router.dart` — go_router route definition.
   - `index.dart` — exports the public files.
2. Export the screen from `app/lib/presentation/screens/index.dart` and register the route in `app/lib/presentation/router/`.
3. Add strings to localization (en, ru).
4. Generate the store: `fvm dart run build_runner build --delete-conflicting-outputs` (in `app`).
5. `fvm flutter analyze`; run the app with the **Mock** launch config if no backend is available.
