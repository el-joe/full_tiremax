# TireMax Flutter App

A Flutter client for the TireMax e-commerce/tire-services platform, built as a mobile
counterpart to the Next.js frontend in `../frontend`, talking to the same Laravel API.

## Running it

```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=https://api.tiremaxiq.com/api/v1
```

To target a specific device:

```bash
flutter devices
flutter run -d emulator-5554 --dart-define=API_BASE_URL=https://api.tiremaxiq.com/api/v1
```

Build a release/debug APK:

```bash
flutter build apk --debug
flutter build apk --release --dart-define=API_BASE_URL=https://api.tiremaxiq.com/api/v1
```

After changing any `.arb` file under `lib/l10n/`, regenerate the localization classes:

```bash
flutter gen-l10n
```

After changing any `@freezed` / `@JsonSerializable` / `@riverpod` annotated file:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Architecture

- **Feature-folder structure** under `lib/features/<feature>/`, each with its own
  `presentation/` (screens/widgets), `data/` (API clients/repositories), `models/`
  (freezed/json_serializable DTOs), and `providers/` (Riverpod state) subfolders. Shared
  UI lives in `lib/shared/widgets/`, cross-cutting concerns (networking, storage, theming,
  routing, locale) live in `lib/core/`.
- **State management**: Riverpod 3.x (`flutter_riverpod` + `riverpod_annotation`), using the
  current `Notifier` / `AsyncNotifier` + `NotifierProvider` / `AsyncNotifierProvider` APIs —
  not the deprecated `StateProvider` / `StateNotifierProvider`.
- **Routing**: `go_router`, configured in `lib/core/router/app_router.dart`, with a
  persistent bottom nav shell (`lib/shared/widgets/bottom_nav_bar.dart`) and auth-gated
  routes via `lib/core/utils/protected_action.dart`.
- **Models**: `freezed` + `json_serializable` DTOs mirroring the API's JSON shapes
  (snake_case field names intentionally kept to mirror the backend — see
  `analysis_options.yaml`, which disables `non_constant_identifier_names` for this reason).
- **Networking**: a single `dio`-based `ApiClient` (`lib/core/network/api_client.dart`) that
  attaches the auth token and an `x-locale` header (driven by `localeProvider`) to every
  request.
- **Auth/session persistence**: `flutter_secure_storage` for the auth token and
  `shared_preferences` for cached profile JSON and the persisted locale choice
  (`lib/core/storage/token_storage.dart`, `lib/core/providers/locale_provider.dart`).
- **Localization**: Flutter's official `gen-l10n` tooling. ARB source files are
  `lib/l10n/app_en.arb` / `lib/l10n/app_ar.arb`; the generated `AppLocalizations` class is
  imported from `package:flutter_app/l10n/app_localizations.dart`. `localeProvider`
  (a `NotifierProvider<LocaleNotifier, Locale>`) drives both `MaterialApp.router`'s
  `locale` and the API client's `x-locale` header, and now hydrates from
  `shared_preferences` on startup and persists on every change.

## What this pass did

- Added `flutter gen-l10n` infrastructure (`l10n.yaml`, `generate: true`, `app_en.arb` /
  `app_ar.arb`) and wired `AppLocalizations.delegate` + `supportedLocales` into
  `MaterialApp.router`.
- Localized the auth sheet (login/register forms, validation messages), the bottom nav
  labels, and the full Profile home screen (nav tiles, language dropdown, logout dialog).
  This covers ~60 ARB keys across auth, profile, nav, cart/checkout/favorites/notifications
  placeholders, and common action/error strings.
- Made `LocaleNotifier` persist the chosen locale via `shared_preferences` and hydrate it on
  startup, mirroring the `TokenStorage` hydration pattern; confirmed `ApiClient` reads
  `localeProvider` for the `x-locale` header, so a language switch takes effect on the very
  next request.
- Fixed one hardcoded-direction layout in the bottom nav (`Positioned(right: ...)` on the
  notification badge → `PositionedDirectional(end: ...)`) so it mirrors correctly in RTL.
- Found a real brand logo embedded (as a base64 JPEG) inside `frontend/public/images/logo.svg`,
  extracted it to `assets/icon/app_icon.png`, and generated Android/iOS launcher icons and a
  native splash screen via `flutter_launcher_icons` and `flutter_native_splash`, both
  configured with a dark background (`#0E0E0E`).
- `flutter analyze` → **No issues found!**
- `flutter build apk --debug` → **succeeds**.
- Ran the app on `emulator-5554` against the live API for ~50s: launches cleanly, no
  exceptions in `flutter run` logs, steady frame timing, no crash.

## Known gaps / TODOs for the next person

- **Localization coverage is partial, not exhaustive.** Only the auth sheet, bottom nav, and
  full Profile home screen were converted to `AppLocalizations` end-to-end in this pass.
  Home, Store, Offers, Product Detail, Services, Reservation flow, Cart, Checkout, Order
  Confirmation, Favorites, Notifications, Settings/Addresses/Orders/Reservations, and the
  legal screens (Privacy Policy/Terms body copy) still contain hardcoded English string
  literals. The ARB files (`lib/l10n/app_en.arb` / `app_ar.arb`) already have a reasonable
  set of common/cart/checkout/favorites/notifications keys stubbed out — extend those and
  wire them into each remaining screen the same way this pass did for auth/profile/nav.
- **RTL was spot-checked, not exhaustively audited.** Only the bottom nav's notification
  badge was found and fixed to use directional positioning. A full pass over every screen's
  `Padding`/`Align`/`Positioned` usages (icon mirroring on back arrows/chevrons, the
  reservation stepper's direction) has not been done — Flutter's built-in widgets (Row,
  ListTile, AppBar back button, Icon direction for some icons) largely auto-mirror under
  `Directionality`, but bespoke `Positioned`/`EdgeInsets.fromLTRB`/`Alignment.centerLeft`
  usages elsewhere in the codebase were not inventoried.
- **Language toggle**: verified via code review and `flutter analyze`/build that
  `LocaleNotifier.setLocale` persists to `shared_preferences` and that `ApiClient` reads
  `localeProvider` for `x-locale`. This was **not** interactively tapped on the emulator
  (no UI automation available), since exercising the profile screen requires being logged
  in.
- **Auth-gated flows** (login, register, cart, checkout, favorites, notifications, profile,
  orders, reservations) could only be verified by code review + a passive launch/log check —
  there's no way to log in or drive the UI interactively in this environment. The app
  launched without crashing and stayed stable for ~50s on the Home screen, which is as much
  runtime verification as was possible here.
- **Payment flow**: per prior steps, Checkout only launches the Paymob URL via
  `url_launcher` in an external browser — no real sandbox transaction has been completed
  end-to-end from this app.
- **No category filter on Store** (carried over from Step 4 — noted then, still true).
- App icon/splash: generated from a real embedded logo asset (a JPEG hidden inside
  `frontend/public/images/logo.svg`'s `<image>` pattern, not an obvious top-level PNG/SVG),
  so double-check it still looks right at small sizes (it's a rectangular photo/logo, not a
  square icon glyph, so `flutter_launcher_icons`' adaptive-icon crop may need art-director
  review before shipping).
- Package versions: `flutter pub get` reports ~25 packages have newer versions than the
  pinned constraints allow. Left as-is since this step was scoped to localization/icons/QA,
  not a dependency bump — worth a deliberate upgrade pass later given the riverpod/freezed
  major-version sensitivity called out in `app_instructions.md`.
