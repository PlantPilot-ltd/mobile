# Progress — mobile

**Last updated:** 2026-11-03

## Done
- [x] VPD screen architecture, DI with get_it, go_router navigation.
- [x] Bluetooth device list screen.
- [x] Greenhouse add screen.
- [x] Greenhouses list screen design.
- [x] HTTP service with interceptors and mock services.
- [x] Agent system (`.agent/`, `docs/features/`, `features/`).

## In progress
- [~] Flutter 3.47.4 / dependency upgrade, sembast migration, `shared_utils` package.

## Open questions / known issues
- **Font licence:** `core_ui` bundles Apple's SF UI Text; Apple licence allows Apple platforms only. Consider Inter or similar for Android.
- **Env files:** launch configs expect `app/assets/.env/{dev,mock}.env`, which aren't in the repo — how are they distributed?
- **Tests:** practically none yet.
