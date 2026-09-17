# TireMax Flutter App — Build Instructions

This document is the execution plan for building the Flutter app in `flutter_app/` as a
full replica (design + flow + API integration) of the Next.js frontend in `frontend/`.

It is written as a series of **sub-agent prompts**. Run them **in order**, one at a time
(each depends on files created by the previous one). Each prompt is self-contained: paste
it to a fresh agent/session as-is. After each step, run `flutter analyze` and fix errors
before moving to the next step.

Backend API base URL (dev): `https://api.tiremaxiq.com/api/v1` (Laravel, JWT auth via
`Authorization: Bearer <token>`, header `x-locale: en|ar` for localization, `auth:api`
guard on protected routes, `jwt.optional` on public ones).

---

## Source-of-truth reference (read this before every step)

- Next.js app: `frontend/app/[locale]/**` (App Router, next-intl)
- API client: `frontend/utils/axiosInstance.ts`
- Types (mirror 1:1 into Dart models): `frontend/types/*.ts`
- Zod schemas (mirror as form validation): `frontend/Schemas/*.ts`
- Colors/tokens: `frontend/app/[locale]/globals.css`, `frontend/theme/tokens/*.ts`
- Postman collection with exact request/response bodies: `TireMax_API.postman_collection.json`
- Locale strings: `frontend/locale/en.json`, `frontend/locale/ar.json`

### Design tokens to use verbatim

```
Primary (brand yellow):  #FDB604
Background (app is dark-first): #0E0E0E
Foreground text:          #FFFFFF (on dark) / #18181B (on light surfaces)
Secondary/error red:      #EE0F0F   (also --color-red: #AE1819 used for destructive text)
Gray (border/divider):    #E8E8E8
Gray 2 (muted text):      #71717A
Gray 3:                   #333333
Gray 4 (light surface):   #F3F3F3
Blue (info):               #1976D2
Green (success):           #2E7D32
Dark yellow (on-primary text): #6B4C00

Font: Almarai (Google Font; use flutter `google_fonts` package), weights 300/400/700/800.
Must support Arabic (RTL) and English (LTR) — use Flutter's built-in RTL support
(Directionality / intl) plus flutter_localizations.

Border radius scale (map Chakra scale -> Flutter radii):
none 0, xs 2, sm 4, md 6, lg 8, xl 12, 2xl 16, 3xl 24, 4xl 32, full 9999
Cards/buttons commonly use lg-2xl (8-16px). Bottom bar / pills use "full".
```

### Navigation model to replicate

- Bottom navigation bar (mobile pattern already used in the Next.js header's mobile fixed
  bottom bar): Home, Store, Services, Reservation, + icon actions (Cart, Favorites,
  Notifications w/ unread badge, Profile). Use Flutter `BottomNavigationBar` or a custom
  pill-shaped floating bar (rounded="full", shadow) to match the web's mobile bottom bar.
- No dedicated login/register screen in the web app (it's a modal). In Flutter, use a
  modal bottom sheet or full-screen dialog route for Login/Register, triggered the same
  way: opened when an unauthenticated user taps a protected action (cart, favorites,
  notifications, profile, checkout) — mirror the `protectedWithAuth` wrapper pattern as a
  Dart helper function.
- Auth-gated sections: Cart, Checkout, Favorites, Notifications, Profile (+ all its
  sub-pages). On 401 from any API call, clear stored token and pop back to Home showing
  the auth sheet.

### Screens to build (route -> purpose)

1. Home — hero, featured products, offers, "why us", contact section, reservation CTA. `GET /home`
2. Store (product catalog, filterable by category/brand/tire size/vehicle). `GET /products`
3. Offers / Flash sales list. `GET /flash-sales`, `GET /flash-sales/{id}/products`
4. Product Detail — gallery, spec (tire/battery), reviews list + write review, related products. `GET /products/{id}`, `GET /products/{id}/related`, `GET /reviews/{id}`, `POST /reviews/{id}`
5. Services list. `GET /services`
6. Book Reservation — vehicle/branch/date/time picker. `GET /vehicles/*`, `GET /branches`, `GET /bookings/branch/{id}/slots`, `POST /bookings`
7. Cart — items, quantity update, remove, apply offer code. `GET /cart`, `POST /cart/items`, `PUT /cart/items/{id}`, `DELETE /cart/items/{id}`, `POST /cart/apply-offer`, `DELETE /cart`
8. Checkout — address + payment method + order review. `POST /orders`, `GET /orders/{id}/payment`
9. Order Confirmation. reads order + payment result
10. Favorites. `GET /favorites`, `POST /favorites/{id}/toggle`
11. Notifications — list + unread badge. `GET /notifications`, `GET /notifications/unread-count`, `POST /notifications/{id}/read`, `POST /notifications/read-all`
12. Profile home (account dashboard, links out)
13. Profile > Settings (update name/email/password). `PUT /auth/me`
14. Profile > Addresses (list/create/update/delete/set-default). `GET/POST/PUT/DELETE /addresses`, `POST /addresses/{id}/set-default`
15. Profile > Orders (history + detail + cancel). `GET /orders`, `GET /orders/{id}`, `POST /orders/{id}/cancel`
16. Profile > Reservations (history + detail + cancel/reschedule). `GET /bookings`, `GET /bookings/{id}`, `POST /bookings/{id}/cancel`
17. Privacy Policy / Terms — static text screens (pull copy from `frontend/locale/*.json`)
18. Auth sheet — Login form (`POST auth/login`), Register form (`POST auth/register`)

### State/architecture decisions

- HTTP client: `dio` (mirrors axios interceptor pattern — request interceptor attaches
  `Authorization` + `x-locale`, response interceptor catches 401 and triggers logout).
- State management: `Riverpod` (recommended over Provider/Bloc for this scope — closest
  mental model to the web app's Context + React Query combo: Riverpod providers for
  global state (auth, cart, favorites, locale) + `AsyncValue`/FutureProvider for
  query-like data fetching with caching/refresh, analogous to React Query).
- Token storage: `flutter_secure_storage` (mirrors the `tiremax_token` cookie) + cache
  the profile JSON in `shared_preferences` (mirrors `localStorage.customerInfo`).
- Localization: `flutter_localizations` + `intl`, ARB files generated from
  `frontend/locale/en.json` / `ar.json`. Locale toggle persisted like the web's
  `useToggleLang`.
- Routing: `go_router` with named routes matching the table above; auth guard via
  `redirect` callback checking the auth provider state for protected routes.

---

## Sub-agent execution plan

Run each block below as a separate agent/session, strictly in order.

### Step 1 — Project scaffolding, theme, and design system --DONE

```
You are a senior Flutter developer. Work only inside /var/www/tiremax/flutter_app
(currently an empty `flutter create`-able folder). Read /var/www/tiremax/app_instructions.md
in full first for design tokens and architecture decisions.

Tasks:
1. If not already a Flutter project, run `flutter create .` inside flutter_app (org:
   com.tiremax, project name tiremax_app, platforms: android, ios).
2. Add dependencies to pubspec.yaml: dio, flutter_riverpod, riverpod_annotation, go_router,
   google_fonts, flutter_secure_storage, shared_preferences, flutter_localizations (sdk),
   intl, cached_network_image, flutter_svg, shimmer, flutter_rating_bar, image_picker,
   fl_chart (skip if unused), freezed + freezed_annotation + json_serializable + build_runner
   (dev) for model codegen, flutter_lints.
3. Create `lib/core/theme/app_colors.dart` with the exact hex constants from
   app_instructions.md (primary #FDB604, background #0E0E0E, etc.) as a `class AppColors`.
4. Create `lib/core/theme/app_radii.dart` with the radius scale as constants.
5. Create `lib/core/theme/app_theme.dart` building a dark-first `ThemeData` (this app is
   dark-mode-first, background #0E0E0E, primary #FDB604) using `google_fonts.almarai()` as
   the text theme base, with a light-mode ThemeData variant too (semantic tokens exist for
   both in the web app). Configure ElevatedButton/OutlinedButton/Card/Input themes to use
   the radius scale (buttons/cards ~ lg-2xl radius, pill-shaped chips/bottom bar = full radius).
6. Set up `lib/main.dart` with MaterialApp.router (placeholder go_router with just a Scaffold
   "Home" page for now), flutter_localizations delegates, and support for both `en` and `ar`
   locales (Directionality flips automatically via Localizations).
7. Create the folder skeleton: lib/{core/{theme,network,storage,utils},features/{auth,home,
   store,product,offers,services,reservation,cart,checkout,favorites,notifications,profile,
   addresses,orders},shared/{widgets}}.
8. Run `flutter analyze` and fix all errors/warnings before finishing.

Do not build any feature screens yet — this step is scaffolding + theme only. Report back
a summary of files created.
```

### Step 2 — Networking layer, models, and storage --DONE

```
You are a senior Flutter developer continuing work on /var/www/tiremax/flutter_app
(scaffolding + theme already done — read what exists first, plus
/var/www/tiremax/app_instructions.md, and the TypeScript types in
/var/www/tiremax/frontend/types/*.ts which you must mirror 1:1 into Dart, and
/var/www/tiremax/TireMax_API.postman_collection.json for exact request/response JSON
shapes of every endpoint — read it fully, it is the ground truth for field names).

Tasks:
1. lib/core/storage/token_storage.dart — wraps flutter_secure_storage for the auth token
   (mirrors the web's `tiremax_token` cookie) and shared_preferences for caching the
   customer profile JSON (mirrors `localStorage.customerInfo`).
2. lib/core/network/api_client.dart — a Dio instance provided via Riverpod
   (`apiClientProvider`), base URL http://localhost:8000/api/v1 (make configurable via
   `--dart-define=API_BASE_URL=`), with:
   - request interceptor: attach `Authorization: Bearer <token>` if present, `x-locale`
     header from the current locale provider.
   - response interceptor: on 401, clear stored token/profile and expose a stream/callback
     the app-level router redirect can listen to (to route back to home + open auth sheet).
3. lib/core/network/api_exception.dart — typed exception wrapping Dio errors with a
   human-readable message (parse Laravel's standard `{message, errors}` validation error
   shape).
4. For every type file in frontend/types/, create the Dart equivalent under
   lib/features/<feature>/models/ using freezed + json_serializable (fromJson/toJson).
   Cover at minimum: Product, Brand, Category, TireSpec, BatterySpec, Order, OrderItem,
   CustomerCart, CartItem, CartProduct, Reservation (Booking), ReservationBranch,
   ReservationService, CustomerProfile, Address, Branch, City, Governorate, Make, Vehicle,
   VehicleModel, YearVehicleModel, TyreSize, Notification, PaymentMethod, Payment, Review,
   Service, HomeRes, ApiMetaRes/pagination wrapper. Field names/types must match the API
   responses in the Postman collection exactly (snake_case JSON -> snake_case Dart field
   with @JsonKey only if you rename).
5. lib/core/network/paginated_response.dart — a generic wrapper `PaginatedResponse<T>`
   matching the Laravel pagination meta shape (`{data, pagination: {total, per_page,
   current_page, last_page}}` per apiMetaRes.type.ts).
6. Run `flutter pub run build_runner build --delete-conflicting-outputs` to generate
   freezed/json files, then `flutter analyze`, and fix everything until clean.

Do not build UI screens yet. Report a list of all model files and the api_client setup.
```

### Step 3 — Auth (login/register, token flow, protected-action guard) + routing shell --DONE

```
You are a senior Flutter developer continuing /var/www/tiremax/flutter_app. Read the
existing scaffolding, theme, models, and api_client from steps 1-2, plus
/var/www/tiremax/app_instructions.md. Reference frontend/hooks/useAuth.ts,
frontend/components/dialogs/AuthDialog.tsx, frontend/components/auth/{LoginForm,
RegisterForm}.tsx, frontend/Schemas/auth*.ts and frontend/middleware.ts (PROTECTED_ROUTES)
for exact behavior to replicate.

Tasks:
1. lib/features/auth/data/auth_repository.dart — methods: login({login, password}),
   register({name, phone, email?, password, password_confirmation, address?, locale?}),
   updateMe({name?, email?, password?, password_confirmation?, locale?}) hitting
   POST auth/login, POST auth/register, PUT auth/me. Persist token + profile via
   TokenStorage on success.
2. lib/features/auth/providers/auth_provider.dart — Riverpod StateNotifier/AsyncNotifier
   exposing `isLoggedIn`, `customer`, login(), register(), logout() (clear storage),
   hydrated on app start from stored token+profile.
3. lib/features/auth/presentation/auth_sheet.dart — a modal bottom sheet (or full-screen
   dialog) with tabbed/toggle Login/Register forms matching the web forms' fields exactly,
   client-side validation mirroring the Zod schemas (required fields, email format, phone
   format, password confirmation match), loading state on submit, error messages surfaced
   from ApiException.
4. lib/core/utils/protected_action.dart — a helper `Future<void> requireAuth(BuildContext,
   WidgetRef, VoidCallback action)` that checks auth state and either runs `action` or opens
   the auth_sheet — this is the Dart equivalent of the web's `protectedWithAuth`.
5. lib/core/router/app_router.dart — go_router setup with named routes for ALL screens
   listed in app_instructions.md's screen table (stub each non-auth screen with a simple
   placeholder Scaffold containing the route name as text — real UI comes in later steps).
   Add a `redirect` that sends unauthenticated users away from protected routes
   (/cart, /checkout, /favorites, /notifications, /profile/**) back to home and triggers
   the auth sheet, mirroring middleware.ts's PROTECTED_ROUTES list.
6. lib/shared/widgets/bottom_nav_bar.dart — the persistent bottom navigation matching the
   web's mobile fixed bottom bar: Home/Store/Services/Reservation nav items + a pill-shaped
   floating action cluster for Cart/Favorites/Notifications(with unread badge)/Profile
   icons, using AppColors.primary for active state and `full` radius/shadow for the pill.
7. Wire main.dart's MaterialApp.router to app_router, wrap the app in a Scaffold shell
   using bottom_nav_bar for the 4 primary tabs.
8. Run build_runner if needed, `flutter analyze`, fix all issues.

Report back confirming login/register call the real backend correctly (you can smoke-test
against http://localhost:8000/api/v1 if it's running) and that route guarding works.
```

### Step 4 — Home, Store, Product Detail, Offers, Services (browse/catalog features) --DONE

```
You are a senior Flutter developer continuing /var/www/tiremax/flutter_app. Steps 1-3
(theme, models, networking, auth, routing shell, bottom nav) are done — read them first.
Also read /var/www/tiremax/app_instructions.md and study these Next.js sources closely for
exact layout/flow to replicate (adapt desktop layouts to mobile-first, keep the same
sections/order and visual language — dark background, yellow primary accent, rounded
cards):
- frontend/app/[locale]/page.tsx + components/pages/home/**
- frontend/app/[locale]/(productsView)/store/** + components/pages/productsView/**
- frontend/app/[locale]/(productsView)/offers/** 
- frontend/app/[locale]/store/[slug]/** + components/pages/productView/**
- frontend/app/[locale]/services/page.tsx + components/pages/services/**

Tasks:
1. Home screen: hero banner, "Recommended" product carousel, banners grid, reservation
   CTA card, "Recommended Offers" section, "Why Us" section, contact-us section. Fetch via
   GET /home (use the HomeRes model from step 2). Product cards: image, brand, name,
   price/sale price with strikethrough + discount badge if has_discount, rating, add-to-
   favorite icon (guarded via requireAuth), tap -> product detail.
2. Store screen: product grid/list with GET /products, filter drawer/sheet (category,
   brand, tire size, vehicle make/model/year via GET /vehicles/*, /fitments/*), pagination
   (infinite scroll using PaginatedResponse), search bar.
3. Offers screen: GET /flash-sales list (title, discount_percent, countdown_seconds shown
   as a live countdown), tap into a flash sale -> GET /flash-sales/{id}/products grid.
4. Product Detail screen: image gallery/carousel with active-thumbnail highlight
   (mirroring the web's swiper outline-glow style using AppColors.primary), full spec
   section (tire_spec or battery_spec depending on product.type), price/stock/badges,
   Add to Cart button (requireAuth-guarded, POST cart/items), Add to Favorites toggle,
   reviews list (GET reviews/{id}) with average rating, "Write a review" form
   (requireAuth-guarded, POST reviews/{id}, body {rating, comment} per createReviewSchema),
   related products row (GET products/{id}/related).
5. Services screen: GET /services list as cards, each with a "Book now" CTA navigating to
   the reservation route.
6. Use `cached_network_image` for all remote images with a shimmer placeholder
   (lib/shared/widgets/shimmer_box.dart) and a graceful fallback icon on error.
7. Run `flutter analyze`; fix all issues. If a local/dev backend is reachable at
   http://localhost:8000/api/v1, smoke test Home and Store screens actually render data.

Report which screens are fully wired to live data vs stubbed, and any API shape mismatches
you had to reconcile against the Postman collection.
```

### Step 5 — Reservation booking flow --DONE

```
You are a senior Flutter developer continuing /var/www/tiremax/flutter_app (steps 1-4
done). Read app_instructions.md, and closely study:
frontend/app/[locale]/services/reservation/** , frontend/providers/ReservationProvider.tsx,
frontend/helpers/generateTimesSlots.ts, frontend/helpers/generateYearsSlots.ts,
frontend/components/pages/reservation/**.

Tasks:
1. Build the multi-step reservation flow (vehicle make -> model -> year via GET
   /vehicles/makes, /vehicles/makes/{make}/models, /vehicles/models/{model}/years, or
   direct vehicle selection via GET /vehicles; then branch selection via GET /branches or
   governorate/city drill-down via GET /governorates, /governorates/{id}/cities; then date
   + time slot picker using GET /bookings/branch/{branch}/slots to show only available
   slots) as a stepper UI (use a simple PageView/Stepper widget with a progress indicator
   matching the app's rounded, yellow-accent style).
2. Guard the final "Confirm booking" action with requireAuth, then POST /bookings with the
   selected service/vehicle/branch/datetime/notes.
3. On success, navigate to a booking confirmation view (reference reference number,
   scheduled_at, branch, service).
4. Run `flutter analyze`; fix all issues. Smoke test against the live backend if reachable.

Report the final request body shape you used for POST /bookings (cross-check against the
Postman collection) and confirm the flow works end to end.
```

### Step 6 — Cart, Checkout, Order Confirmation --DONE

```
You are a senior Flutter developer continuing /var/www/tiremax/flutter_app (steps 1-5
done). Read app_instructions.md, and study:
frontend/app/[locale]/cart/**, frontend/app/[locale]/checkout/**,
frontend/app/[locale]/checkout/confirm/[orderId]/**, frontend/hooks/useCart.ts,
frontend/components/pages/checkout/CheckoutForm.tsx, frontend/Schemas/createOrderSchemas.ts,
frontend/components/pages/orderConfirm/**.

Tasks:
1. Cart screen (auth-gated route, already guarded by router redirect from step 3): list
   items (GET /cart) with product image/name/price, quantity stepper (PUT /cart/items/{id}),
   remove button (DELETE /cart/items/{id}), "clear cart" (DELETE /cart), offer/promo code
   input (POST /cart/apply-offer) showing discount breakdown, subtotal/total summary,
   "Checkout" CTA.
2. Checkout screen: address selection (fetch from GET /addresses, allow adding a new one
   inline or navigating to the address form), payment method selection (radio cards styled
   with AppColors.primary border when selected, mirroring Chakra's RadioCard recipe), order
   summary, "Place order" button -> POST /orders with the selected address/payment method
   (body shape per createOrderSchemas.ts / Postman collection). On success, if payment
   requires a gateway redirect, fetch GET /orders/{order}/payment and open the payment URL
   in an in-app WebView (add `webview_flutter` dependency) or browser (`url_launcher`)
   depending on what the payment response shape indicates (check Postman collection /
   backend config/services.php for Paymob).
3. Order Confirmation screen: show order reference, items, totals, and payment status,
   reachable after checkout completes.
4. Run `flutter analyze`; fix all issues. Smoke test against the live backend if reachable.

Report the exact request/response shapes used for POST /orders and GET /orders/{id}/payment,
and flag anything in the Postman collection that didn't match what you implemented.
```

### Step 7 — Favorites, Notifications, Profile (settings/addresses/orders/reservations) --DONE

```
You are a senior Flutter developer continuing /var/www/tiremax/flutter_app (steps 1-6
done). Read app_instructions.md, and study:
frontend/app/[locale]/favorites/**, frontend/app/[locale]/notifications/**,
frontend/hooks/useNotifications.ts, frontend/hooks/useFav.ts,
frontend/app/[locale]/profile/** (settings, address, orders, reservation subpages + their
[id] detail pages), frontend/components/dialogs/{CreateAddressDialog,RemoveAddressDialog,
SetDefaultAddressDialog,CancelOrderDialog,CancelReservationDialog,
RescheduleReservationDialog,LogoutDialog}.tsx.

Tasks:
1. Favorites screen: GET /favorites grid/list, tap a heart icon to POST
   /favorites/{product}/toggle (optimistic update + rollback on error), tap card ->
   product detail.
2. Notifications screen: GET /notifications list (unread visually distinguished, e.g. left
   accent bar in AppColors.primary), tap item -> POST /notifications/{id}/read, "mark all
   read" action -> POST /notifications/read-all. Poll or refresh GET
   /notifications/unread-count to drive the bottom-nav badge (reuse from step 3's
   bottom_nav_bar).
3. Profile home: account summary card + navigation list to Settings/Addresses/Orders/
   Reservations + Logout (confirm dialog) + language toggle + Privacy Policy/Terms links.
4. Profile > Settings: form to update name/email/password -> PUT /auth/me, validation
   mirroring updateProfile schema.
5. Profile > Addresses: list (GET /addresses) with set-default and delete swipe actions or
   menu, "add address" form (POST /addresses, governorate/city dropdowns from GET
   /governorates + /governorates/{id}/cities), edit (PUT /addresses/{id}), set default
   (POST /addresses/{id}/set-default), delete (DELETE /addresses/{id}) — all with confirm
   dialogs matching the web's dialog-per-action pattern.
6. Profile > Orders: list (GET /orders) with status chips (color-coded: pending=gray,
   processing=blue #1976D2, completed=green #2E7D32, cancelled=red #AE1819), tap -> detail
   (GET /orders/{id}) showing items/totals/shipping/tracking, "Cancel order" button (POST
   /orders/{id}/cancel) with confirm dialog, only shown for cancellable statuses.
7. Profile > Reservations: list (GET /bookings) similarly status-chipped, tap -> detail
   (GET /bookings/{id}). "Cancel" calls POST /bookings/{id}/cancel with a confirm dialog.
   "Reschedule" is intentionally implemented as: show a warning dialog ("Rescheduling will
   cancel your current booking. Are you sure?"), then on confirm call POST
   /bookings/{id}/cancel and navigate to the reservation booking flow (Step 5) pre-filled
   with the same service_id/branch_id so the user rebooks a new slot. This is confirmed
   intentional (backend only exposes index/store/show/cancel for bookings — there is no
   separate reschedule endpoint), not a bug — replicate this exact flow.
8. Privacy Policy / Terms screens: render static copy pulled from
   frontend/locale/en.json / ar.json (find the relevant keys).
9. Run `flutter analyze`; fix all issues. Smoke test against the live backend if reachable.

Report any endpoint whose real backend behavior (per the Postman collection or
backend/routes/api.php + controllers) diverges from what the web frontend implies, since
those are candidates for follow-up questions to the user.
```

### Step 8 — Localization (Arabic/English + RTL), polish, and QA pass --DONE (partial: l10n infra/persistence/icons/README complete; not every screen's strings converted yet — see flutter_app/README.md "Known gaps")

```
You are a senior Flutter developer finishing /var/www/tiremax/flutter_app (steps 1-7 done,
all screens implemented and wired to the live API). Read app_instructions.md.

Tasks:
1. Generate ARB files (lib/l10n/app_en.arb, app_ar.arb) from
   frontend/locale/en.json and frontend/locale/ar.json — map every string used across the
   app's screens to a localization key, wire flutter_gen l10n, and replace hardcoded
   strings in all screens built in steps 3-7 with `AppLocalizations.of(context)!.<key>`.
2. Verify RTL layout correctness for Arabic: text alignment, icon mirroring (back arrows,
   chevrons), and the bottom nav bar / stepper direction all flip correctly. Fix any widget
   that doesn't respect `Directionality`.
3. Add a language toggle (mirrors frontend/hooks/useToggleLang.ts) accessible from the
   Profile screen and persist the choice (shared_preferences), applying it as `x-locale`
   header on all API calls (already wired in api_client from step 2 — verify it reads the
   persisted locale).
4. Add app icon + splash screen using flutter_launcher_icons / flutter_native_splash with
   the brand yellow (#FDB604) on dark (#0E0E0E) background, using the TireMax logo if one
   exists under frontend/public/ (search for it) — otherwise use a simple wordmark
   placeholder and flag that a logo asset is needed.
5. Full QA pass: run `flutter analyze` (zero issues), then manually walk every flow listed
   in app_instructions.md's screen table against a running backend
   (http://localhost:8000/api/v1) if available: browse -> product detail -> add to cart ->
   checkout -> order confirmation; browse services -> book reservation; favorites toggle;
   notifications read; profile settings/address/orders/reservations CRUD; login/register/
   logout; locale toggle + RTL.
6. Write a short README.md in flutter_app/ documenting how to run it (`flutter pub get`,
   `flutter run --dart-define=API_BASE_URL=http://<host>:8000/api/v1`), architecture
   overview, and known gaps/TODOs discovered during the build (e.g. the reservation
   reschedule endpoint question from step 7, missing logo asset, payment gateway webview
   details still needing real Paymob credentials to fully test).

Report a final summary: what's fully working, what's stubbed/incomplete, and what needs a
real backend/credentials to verify (payment flow, SMS/email-dependent features if any).
```

---

## Notes for whoever runs these agents

- Steps must run sequentially — each reads files the previous step created.
- Before Step 2, make sure `TireMax_API.postman_collection.json` and `backend/routes/api.php`
  are available for cross-referencing exact request/response shapes — they are the ground
  truth over the frontend's TS types when the two disagree.
- No `.env.example` exists in `frontend/`; the only required runtime config for Flutter is
  the API base URL, passed via `--dart-define=API_BASE_URL=...`.
