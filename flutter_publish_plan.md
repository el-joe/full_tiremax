# TireMax Flutter — Parity + Publish Plan

Goal: `flutter_app/` matches `frontend/` (Next.js) screen-by-screen in design and API usage, API is covered by automated tests, and the app builds as a signed release for Android/iOS.

Baseline (verified 2026-10-13): `flutter analyze` clean; 24 routes built; live API `https://api.tiremaxiq.com/api/v1` responds 200.

## Known gaps found in audit
| # | Gap | Evidence |
|---|-----|----------|
| 1 | No Contact screen (`contact-messages` POST never called) | frontend `contact/page.tsx`; no flutter route |
| 2 | No Track Order screen (guest lookup by order ref) | frontend `track-order/page.tsx`; no flutter route |
| 3 | `PUT cart/items/{id}` (qty update), `auth/*`, `settings/public`, `vehicles/{id}`, `fitments/*` calls need verifying vs frontend | grep of repositories |
| 4 | Store has no category filter | README known gaps |
| 5 | Localization only on auth/nav/profile; rest hardcoded English | README |
| 6 | RTL not audited (Positioned/EdgeInsets/Alignment) | README |
| 7 | Release not ready: label `flutter_app`/`Flutter App`, debug signing, appId `com.tiremax.tiremax_app`, placeholder test, icon crop unreviewed | build.gradle, manifest, Info.plist |
| 8 | Backend API has only 2 storefront test files; no per-endpoint contract tests | backend/tests |

## Token-saving rules for every agent
- Read only the files named in the prompt (one frontend page + its components/hooks + the matching Flutter feature). Never read `*.freezed.dart`/`*.g.dart`, `node_modules`, `build/`.
- Use `grep`/offset reads, not whole-file dumps. Do not re-explore the repo; this file + `app_instructions.md` are the context.
- Report back in ≤15 lines: what changed, what still differs. Do not paste code in the report.
- After edits: `cd flutter_app && dart run build_runner build --delete-conflicting-outputs` (only if models changed) and `flutter analyze` must be clean.
- Do not commit; the lead commits after each phase.

## Phases (run in order, one agent each)

### Phase 1 — API contract tests (backend + Flutter)
Add PHPUnit feature tests in `backend/tests/Feature/Api/` covering every route in the `v1` group of `backend/routes/api.php`: auth (register/login/refresh/me/update/logout), catalog (home, brands, branches, governorates, cities, services, flash-sales, vehicles, products, related, fitments, reviews), cart (guest via `X-Guest-Token` AND customer), orders (create/show/cancel/list), bookings (slots/create/show/cancel/list), addresses CRUD+default, favorites toggle, notifications, contact-messages, settings/public, payment-gateways. Assert status codes, JSON structure (match fields the frontend `types/*.ts` and Flutter models consume), plus 401/validation/404 cases. Reuse existing factories/seeders. Run `php artisan test`. Then add `flutter_app/test/repositories/` tests using a Dio mock adapter (`http_mock_adapter` dev dependency) feeding Postman-collection-shaped JSON to every repository, asserting model parsing and request path/method/headers (`x-locale`, `Authorization`, `X-Guest-Token`). Finally write `flutter_app/tool/api_smoke.dart` hitting the live API with read-only GETs. Save results to `API_TEST_REPORT.md`.
Done when: `php artisan test` green, `flutter test` green.

### Phase 2 — Missing screens + missing API calls
Implement Contact (`/contact`, POST `contact-messages`, mirror `frontend/Schemas` validation and `contact/page.tsx`) and Track Order (`/track-order`, GET `orders/{ref}`) in Flutter; add routes and entry points where the web links them. Verify guest cart, guest checkout and guest reservation work with `X-Guest-Token` as on the web. Add the category filter to Store as in `frontend/app/[locale]/(productsView)/store`. Confirm `PUT cart/items/{id}`, `auth/*`, `settings/public`, `fitments/*`, `vehicles/{id}` usage matches frontend hooks (`useCart`, `useAuth`, store/product pages); add what is missing.

### Phase 3 — Design parity: Home, Store, Offers, Product, Services
Compare each Next.js page (+ components under `frontend/components`) to the Flutter screen: section order, spacing, radii, colors, typography, images, empty/loading/error states, filters, sorting, pagination, flash-sale badges, review UI, related products, API params (`resolveApiFilters`/pagination). Fix every difference in Flutter.

### Phase 4 — Design parity: Reservation, Cart, Checkout, Orders, Confirmation
Same comparison for services/reservation (stepper, make/model/year, branch, slots, summary), cart (offer code, totals, qty), checkout (address, payment methods, Paymob redirect + return), checkout/confirm, profile/orders list+detail (cancel), profile/reservation list+detail (cancel). Validate payloads field-for-field against frontend requests.

### Phase 5 — Design parity: Auth, Profile, Favorites, Notifications, Addresses, Settings, Legal
Same comparison for the auth sheet (login/register, errors, 401 handling), profile home, settings, addresses (governorate/city), favorites, notifications (read/read-all/unread badge), privacy-policy, terms.

### Phase 6 — Localization + RTL
Move every hardcoded string to `lib/l10n/app_en.arb` / `app_ar.arb`, reusing copy from `frontend/locale/en.json` / `ar.json`; wire all screens. Audit RTL: replace `Alignment.centerLeft`, `EdgeInsets.fromLTRB`, `Positioned(left/right)` with directional equivalents; mirror arrows/chevrons/stepper. Verify no raw English remains (`grep` for `Text('`).

### Phase 7 — Release readiness
App name "TireMax" (Android label, iOS display name, web title), final app id, version; Android release signing via `key.properties` (template + gitignore, no secrets committed), R8/proguard, `INTERNET` permission, no cleartext; iOS permission strings (photo library for image_picker); review launcher icon/splash; remove debug prints; replace placeholder `widget_test.dart` with a real smoke test; safe dependency bumps only. Run `flutter build apk --release` and `appbundle`; write `PUBLISH_CHECKLIST.md`.

### Phase 8 — Final QA
Run `php artisan test`, `flutter analyze`, `flutter test`, smoke script, release build. Walk the parity matrix (frontend page → Flutter screen → API calls) and write `PARITY_REPORT.md` with ✔/✘ and remaining gaps.

## Execution log
- [x] Phase 1  - [x] Phase 2  - [x] Phase 3  - [x] Phase 4  - [x] Phase 5  - [x] Phase 6  - [x] Phase 7  - [x] Phase 8
