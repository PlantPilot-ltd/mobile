# System patterns — mobile

## Layering
`shared_utils` ← `core` ← `core_ui` ← `app`. Each package exposes a barrel
(`core.dart`, `core_ui.dart`, `shared_utils.dart`); inside `app` every folder has an `index.dart`.

## App startup
`app/lib/main.dart` → `AppRunnerService().run()`. Dependencies are registered in
`app/lib/providers/` (`app_injection_provider.dart`, `app_http_provider.dart`, `app_cache_provider.dart`,
`app_constants_provider.dart`) using get_it.

## Data flow
entities (`app/lib/entities`) ← services (`bluetooth/`, `http/`, `cache/`, `report/`) ← repositories
(`bluetooth/`, `greenhouse/`, `greenhouse_list/`) ← screen stores.
- Services have a `*_base.dart` interface and real + `*_mock.dart` implementations.
- HTTP: `http_service.dart` with interceptors (e.g. `report/dev_log_interceptor.dart`); feature services under `http/<area>/` with `models/`.
- Cache: sembast-based `cache_service.dart`, models implement `cacheable_object.dart`.

## Screens — VPD (View–Presenter–DataStore)
Per screen folder: `*_dependencies.dart`, `*_store.dart` (MobX, generated `*.g.dart`),
`*_presenter.dart` (`VPDPresenter<Store>`), `*_screen.dart`, `*_router.dart`, `index.dart`.
Base classes: `core_ui/lib/screen_architecture/vpd_architecture.dart`. See `workflows/add_screen.md`.

## Navigation & localization
go_router in `app/lib/presentation/router/`; strings in `presentation/localization/` (en, ru) and `core_ui/lib/localization/`.
