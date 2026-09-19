# TireMax — Updates Execution Plan

Run the phases **in order**, one sub-agent per phase (each depends on the previous one). Every prompt is self-contained.
After each phase: run `php artisan test`, `php artisan route:list`, `npm run build` (frontend, where touched), fix errors, then commit.

Stack facts (verified in code):
- Backend `backend/`: Laravel 13, Livewire 4 admin (`app/Livewire/Admin/**`, views in `resources/views/livewire/admin/**`), guard `admin` (session), API guard `api` (JWT, customers), `spatie/laravel-permission` v7 installed (guard_name `admin`), Astrotomic translatable, queue = database, mail = log.
- Frontend `frontend/`: Next.js 16 App Router + next-intl + Chakra v3 + react-query. API client `utils/axiosInstance.ts` (always sends `Authorization: Bearer <cookie>`), `middleware.ts` redirects unauthenticated users away from `/cart /checkout /profile /favorites /notifications`.
- Flutter app `flutter_app/` mirrors the web; keep API changes backward compatible.

## Audit findings (why each phase exists)

### Admin filters
| List | Problem |
|---|---|
| ALL lists using `WithCrudList` | Only `updatingSearch` resets pagination. Every other filter (status, brand, make, model, type…) does not `resetPage()` → empty page after filtering from page 2+. Filters are not `#[Url]` so not shareable/refresh-safe. No "clear filters" button. |
| Customers | Search uses `where(name) ->orWhere(phone) ->orWhere(email)` **without grouping** — will break as soon as any other constraint is added. No filters: active/banned, has-orders, registered date, locale. |
| Orders | Filter only by status + search. Missing: type (basra/delivery), payment_method, payment_status, branch, governorate, date range, customer-kind (registered/guest), search by email. Sorting UI param ignored for nothing but OK. |
| Bookings | Search only `reference`. Ignores `sortBy`. Missing: service, date range, customer search (name/phone), guest/registered. |
| Products | Filters: type, brand only. Missing: category, active/inactive, featured, stock (in/low/out), price range, sale. `$categories` loaded but unused. |
| Fitments | Only make/model/vehicle. Missing: product filter, search by product name/SKU. Model dropdown isn't reset when make changes. |
| Reviews | `status` filter has no "all" option; missing rating, type (customer/expert), product. |
| Vehicles / Models / Makes | Vehicle list has no search; makes have search but no active filter. Model dropdown doesn't reset with make. |
| Brands, Categories, Services, Governorates, Branches, Offers, FlashSales | Search only. Missing `is_active` filter; Offers missing status (live/expired/upcoming) + type; FlashSales missing status; Categories missing parent/type; Governorates missing is_basra; Branches search only by `code` (should include translated name/city/phone). |
| Daftra logs | Filters exist but no date range/search; page not reset. |
| Whatsapp templates / Payment gateways | Not paginated lists (small) — no filters needed; add WhatsApp **logs** list with filters (status, phone, template, date). |

### Permissions / RBAC
- `spatie/laravel-permission` is installed and seeded (`manage_*` permissions, 4 roles) but **nothing enforces it**: zero `can()`, `authorize()`, `@can` or permission middleware in routes, Livewire components, sidebar, or actions. Any admin can do everything.
- No Admins module, no Roles module. `Admin` model has `HasRoles` (good). `AdminSeeder` exists.
- Login (`Login.php`) does not reject `is_active = false` admins. Admin middleware doesn't re-check active state.
- Permissions are too coarse (`manage_*` only) and missing for: reviews, flash-sales, daftra-logs, payment-gateways, whatsapp, roles, audit logs.

### Guest checkout / booking
- `POST /orders`, `/bookings`, all `/cart*` are behind `auth:api`. Cart is keyed only by `customer_id`; `carts.session_id` column exists but is unused. `orders.customer_id` and `bookings.customer_id` are NOT NULL. Web `middleware.ts` blocks `/cart` and `/checkout`. Booking flow calls `protectedWithAuth`.
- Notifications: only `database` channel → **no email is ever sent**. WhatsApp: `WhatsappService::sendForOrder` exists (job + artisan command) but is never triggered on order creation (only via manual/batch command), no booking WhatsApp at all, uses hard-coded locale `ar`.
- Customers have unique `phone` (required) and unique nullable `email`; register does not link previous guest orders.

### WhatsApp floating button
- Setting `general.whatsapp_number` exists in admin settings but there is **no public settings endpoint**; frontend only has a static `WhatsappLogoIcon` in Footer. No floating anchor.

---

## PHASE 0 — Baseline & safety net

**Prompt:**
> Work in `/var/www/tiremax/backend`. Read `updates.md` (repo root) for context. 1) Configure a testing DB (sqlite in-memory or `.env.testing`) so `php artisan test` runs; make sure migrations run on it (note: `BookingService::ensureCapacity` uses MySQL-only `DATE_ADD` — leave it, but skip/guard those tests on sqlite or use MySQL for tests). 2) Add model factories needed by later phases: `Customer`, `Admin`, `Product`, `Order`, `Booking`, `Branch`, `Service` (use existing seeders as reference). 3) Add a `tests/Feature/Admin/` folder with a helper trait `ActingAsAdmin` (creates admin with given permissions on guard `admin`). 4) Commit. Do not change app behaviour.

---

## PHASE 1 — RBAC foundation (permissions, roles, admins enforcement) — backend

**Prompt:**
> Work in `/var/www/tiremax/backend`. Goal: real, enforced roles & permissions for the Livewire admin.
>
> 1. **Permission catalogue** — create `app/Support/AdminPermissions.php` returning a grouped map (module → actions) using the naming `<module>.<action>`: modules `dashboard(view)`, `products`, `brands`, `categories`, `fitments`, `vehicles` (covers makes/models/vehicles), `orders`, `bookings`, `customers`, `branches`, `governorates`, `services`, `offers`, `flash_sales`, `reviews`, `daftra_logs(view)`, `whatsapp` (templates + logs), `payment_gateways`, `settings`, `admins`, `roles`, `audit_logs(view)`. Actions: `view, create, update, delete` plus specials: `orders.change_status`, `orders.export`, `bookings.change_status`, `customers.ban`, `reviews.moderate`, `products.import`, `settings.update`. Keep old `manage_*` names working by migrating: new migration that renames/creates the new permissions and grants every existing role holder of `manage_X` all `X.*` permissions, then deletes `manage_*`.
> 2. **Seeder** — rewrite `RolePermissionSeeder` (idempotent, `firstOrCreate`, guard `admin`): `super-admin` gets all + is also granted via `Gate::before` in `AppServiceProvider` (`$user->hasRole('super-admin') ? true : null` for guard admin). `branch-manager`, `content-manager`, `support` get sensible subsets (view+update orders/bookings/customers for support; catalog CRUD for content-manager, etc.). Update `AdminSeeder` so the default admin is super-admin. Clear permission cache at the end.
> 3. **Route protection** — in `routes/web.php` wrap every admin route with `->middleware('can:<perm>')` (view permission for index routes; `products.create` for create, `products.update` for edit). Register `permission`/`role` middleware aliases if you prefer them (`bootstrap/app.php`). Unauthorized → 403 page (`resources/views/errors/403.blade.php`, styled like admin, bilingual).
> 4. **Action-level protection** — create trait `app/Livewire/Concerns/AuthorizesAdmin.php` with `authorizePermission(string $p)` that calls `abort_unless(auth('admin')->user()?->can($p), 403)`. Call it at the top of EVERY mutating Livewire method (`save`, `store`, `update`, `delete`, `toggle*`, `changeStatus`, `approve`, `reject`, `ban`, `import`, `sync`, etc.) across all components in `app/Livewire/Admin/**` — and in `mount()`/`render()` for view. Livewire actions can be invoked directly, so route middleware alone is NOT enough.
> 5. **UI gating** — sidebar (`resources/views/admin/partials/sidebar.blade.php`): add `'can' => '<module>.view'` to every `$nav` entry and skip entries the admin can't see; group headings hidden when empty. In every blade view wrap create/edit/delete/status buttons in `@can('<module>.<action>')`. Dashboard widgets that link to modules must respect permissions.
> 6. **Active admin enforcement** — `Login.php`: reject `is_active=false` with an error message (add ar/en strings). `AdminAuthenticate` middleware: logout + redirect if the admin became inactive/soft-deleted mid-session.
> 7. **Tests** — `tests/Feature/Admin/RbacTest.php`: for each protected route assert 403 without permission, 200 with; assert a Livewire mutating method is forbidden without permission; assert super-admin passes everything; assert inactive admin can't log in. Add a test that iterates `Route::getRoutes()` and fails if an `admin.*` route (except login/logout/locale) lacks a `can:` middleware — this guards future modules.
>
> Add all new labels to `lang/en/messages.php` and `lang/ar/messages.php`. Commit.

## PHASE 2 — Admins & Roles modules — backend admin UI

**Prompt:**
> Work in `/var/www/tiremax/backend`. Build two new Livewire modules following the exact conventions of existing managers (`WithCrudList`, Alpine/Tailwind blade like `brand-manager.blade.php`, toasts, `LogsAdminActions`, ar/en strings, sidebar entries, routes `admin.admins.index` and `admin.roles.index` protected with `can:admins.view` / `can:roles.view`). Depends on Phase 1.
>
> **Admins** (`app/Livewire/Admin/Admins/AdminManager.php` + view): list with search (name/email/phone), filters (role, active/inactive), sort, pagination; create/edit modal (name, email, phone, password [required on create, optional on edit, min 8], avatar optional, `is_active`, roles multi-select); soft delete + restore ("trashed" filter); toggle active. Rules: an admin cannot deactivate/delete **themselves**; the **last active super-admin** cannot be deleted/deactivated/have super-admin role removed; only users with `admins.update` may assign roles, and only super-admins may assign `super-admin`. Log every action via `logAction`. Show last_login_at.
>
> **Roles** (`app/Livewire/Admin/Roles/RoleManager.php` + view): list roles with permission count + admin count, search; create/edit modal with permissions rendered as grouped checkbox matrix from `AdminPermissions` (module rows × action columns, "select all" per row/column); `super-admin` role is read-only (cannot be edited/deleted/renamed); role name unique per guard `admin`, slug-style; cannot delete a role that still has admins assigned (show count, offer reassign message). After any role/permission change call `app(PermissionRegistrar::class)->forgetCachedPermissions()`.
>
> Also add a read-only **Audit Log** list (`admin.audit-logs.index`, `audit_logs.view`) with filters: admin, action, subject type, date range, search — the `AuditLog` model already exists.
>
> Tests: feature tests for CRUD, the self-delete / last-super-admin guards, role matrix sync, and permission enforcement on each new component. Commit.

## PHASE 3 — Filters overhaul — all admin lists

**Prompt:**
> Work in `/var/www/tiremax/backend`. First upgrade `app/Livewire/Concerns/WithCrudList.php`:
> - Add `resetFilters()` action and a `protected array $filterKeys = []` convention; automatically `resetPage()` whenever ANY listed filter property changes (implement `updated($name)` hook: if `$name` in `$filterKeys` or is `search`/`perPage` → `resetPage()`).
> - Make `search`, `sortBy`, `sortDir` and all filters `#[Url(as: ..., keep: false)]` so lists survive refresh and are shareable.
> - Validate `sortBy` against a per-component `sortable` whitelist and `sortDir` against asc/desc (currently `orderBy($this->sortBy)` accepts arbitrary column names from the URL → SQL error / info leak).
> - Add `perPage` (10/20/50/100) option.
> - Create a reusable blade component `resources/views/components/admin/filter-bar.blade.php` (search input with wire:model.live.debounce.400ms, slot for filter selects, "Reset" button shown when any filter is active, result counter) and use it in every list so UI is consistent (ar/en, RTL safe). Also `x-admin.date-range` component (from/to).
>
> Then fix/add filters per list (all must be applied with grouped `where(function…)` so OR never leaks):
> - **Customers**: fix ungrouped OR bug; filters: status (active/inactive/banned), has orders (yes/no), registered from/to, locale; sort by orders_count.
> - **Orders**: search (reference, name, phone, email); filters: status, type, payment_method, payment_status, branch, governorate, customer kind (registered/guest — `customer_id` null or `is_guest`, see Phase 4), created from/to, total min/max.
> - **Bookings**: search (reference, customer name/phone, guest name/phone); filters: status, branch, service, scheduled from/to (add quick "today / tomorrow / this week"), customer kind; make `sortBy` actually apply (default `scheduled_at desc`).
> - **Products**: search (sku, translated name); filters: type, brand, category, active, featured, stock (in/low ≤5/out), on sale, price min/max.
> - **Fitments**: add product filter + search by product name/SKU; reset `modelId`/`vehicleId` when make changes and `vehicleId` when model changes.
> - **Reviews**: add "all" status option, rating, type, product search; keep default `pending`.
> - **Vehicles**: add search (make/model name, year) + year filter; reset model when make changes. **Models**: search + make (exists) + active. **Makes**: search + active.
> - **Brands / Categories / Services / Governorates / Branches / Offers / Flash sales**: `is_active` filter each; Offers: status (live/upcoming/expired) + discount type; Flash sales: status (live/upcoming/ended); Governorates: is_basra; Branches: search also by translated name, phone, city, plus governorate filter; Categories: type/parent if the column exists.
> - **Daftra logs**: add search, date range, direction/action if present; page reset.
> - **New** WhatsApp logs list (`admin.whatsapp-logs.index`, permission `whatsapp.view`, model `WhatsappLog` exists) with filters status, template, phone/customer search, date range.
>
> Extract the repeated translated-name search into a query scope/trait (`Concerns/SearchesTranslations`) instead of copy-pasting. Eager-load to avoid N+1. Add feature tests (Livewire::test) for each list: every filter narrows results correctly, pagination resets, reset button clears, invalid sort ignored. Commit.

## PHASE 4 — Guest orders & bookings: data model + API

**Prompt:**
> Work in `/var/www/tiremax/backend`. Goal: a visitor with NO account can add to cart, order and book. All identifying details are stored on the order/booking, and later linked to the customer on register/login. Keep every existing authenticated endpoint and response shape backward compatible (Flutter app uses them).
>
> **Migrations**
> - `orders`: make `customer_id` nullable (`nullOnDelete`), add `is_guest boolean default false`, `guest_token string(64) nullable index`, `customer_locale string(5) default 'ar'`. (`customer_name/phone/email` already stored.)
> - `bookings`: make `customer_id` nullable (`nullOnDelete`), add `customer_name`, `customer_phone`, `customer_email nullable`, `customer_locale`, `is_guest`, `guest_token`. Backfill name/phone/email from customers for existing rows.
> - `carts`: add `guest_token string(64) nullable unique`; use existing nullable `customer_id`. Add a scheduled prune of guest carts untouched > 30 days.
> - `whatsapp_logs`: add nullable `booking_id`.
> - Add index on `customers.phone` normalisation: create `App\Support\Phone::normalize()` (Iraq: strip non-digits, `07…`→`9647…`, `00964`→`964`, `+964`) and store a normalised `phone_normalized` column on customers/orders/bookings (indexed) — this is the key for linking guest data on registration. Backfill.
>
> **Guest identity** — API reads header `X-Guest-Token` (UUID generated by client). Add middleware `jwt.optional` usage on cart/order/booking/payment routes (replace `auth:api` where guests are allowed) and a helper `App\Support\Actor` resolving `{customer|null, guestToken|null}`; reject requests that have neither (401 only for endpoints that truly need auth: profile, addresses, favorites, notifications, reviews, order/booking **list**).
>
> **Cart** — refactor `CartService` to accept an `Actor` (customer OR guest token): `getOrCreate` keyed by `customer_id` or `guest_token`. Endpoints `cart*`, `cart/apply-offer` move to optional auth.
>
> **Checkout** — `POST /orders`: for guests `customer_name`, `customer_phone` (required, valid Iraqi phone), `customer_email` optional-but-validated are REQUIRED in `StoreOrderRequest` (`required_without` auth). Create order with `customer_id=null,is_guest=true,guest_token`. If a customer with the same `phone_normalized`/email exists **do not** attach silently (security) — just store as guest and let the link step handle it. Empty cart guard, stock locking and totals remain. Also stop trusting client `discount` — recompute from applied offer server-side (currently `discount` and `installation_fee` are accepted raw from the client: fix).
> **Order access for guests** — `GET /orders/{reference}?phone=…` or with the same `X-Guest-Token` returns the order (used by confirmation/thank-you page and payment redirect); `GET /orders/{order}/payment` works for owner-or-guest-token. Cancel: allowed for owner or guest-token holder. Never expose guest orders by numeric id alone.
> **Booking** — `POST /bookings` public with the same guest fields; `BookingService::create(?Customer, array)`; `bookings/{ref}` for guest via token. Keep `bookings/branch/{branch}/slots` public. Add per-IP throttling (`throttle:10,1`) to guest `POST /orders` & `POST /bookings`.
>
> **Linking on register/login** — new `App\Services\GuestLinkService::attach(Customer $c, ?string $guestToken)`: in one transaction, update `orders`/`bookings` where `customer_id IS NULL` AND (`guest_token = $token` OR `phone_normalized = $c->phone_normalized` OR (`customer_email` = `$c->email` AND email verified/non-null)) → set `customer_id`, `is_guest=false`; merge guest cart into the customer's cart (sum quantities, cap by stock); relink `whatsapp_logs`. Call it from `AuthService::register` AND `login` (accept optional `guest_token` in the payload/`X-Guest-Token` header). Log count of linked records. Return `linked_orders`, `linked_bookings` in the auth response `meta`.
> Registration must not fail if the phone exists as a *guest order* only (phones are unique on `customers` only).
>
> **Resources** — `OrderResource`/`BookingResource` must be null-safe on `customer` and expose `is_guest`.
> **Admin** — where views/relations use `$order->customer->…` make them null-safe and show name/phone from the order's own snapshot columns with a "Guest" badge (orders, bookings, customers detail, dashboard). Add Customers list action "link guest orders by phone" (manual re-run of `GuestLinkService` for one customer; permission `customers.update`). Update `TireMax_API.postman_collection.json`.
>
> **Tests** — feature tests: guest cart add/update/clear; guest checkout (COD) creates order with nullable customer & decrements stock; validation errors; guest booking; guest cannot read another guest's order; register with the same phone links previous orders+bookings+cart; login links too; two customers can't steal each other's guest orders; throttling. Commit.

## PHASE 5 — Email + WhatsApp notifications for guests & customers

**Prompt:**
> Work in `/var/www/tiremax/backend`. Depends on Phase 4. Problem: today only the DB notification channel is used (no email at all), WhatsApp is never triggered automatically, nothing exists for bookings, and notifications require a `Customer` notifiable (guests have none).
>
> 1. **Email** — configure real mail via `.env` (`MAIL_MAILER`, from address/name from Setting `general.site_email`/`site_name`); update `.env.example`. Create bilingual Markdown mailables (`resources/views/emails/…`, RTL for ar, locale = `customer_locale`): `OrderPlacedMail`, `OrderStatusChangedMail`, `BookingCreatedMail`, `BookingStatusChangedMail`, `BookingReminderMail`. Include reference, items table/totals, branch/address, a "track order" link, and (for guests) a call-to-action "Create an account to track all your orders" linking to `${FRONTEND_URL}/?authDialog=on&phone=…`. All `ShouldQueue`. Add `FRONTEND_URL` to config.
> 2. **Notify without a Customer** — create `App\Services\OrderNotifier` / `BookingNotifier` that send to the snapshot contact (`Notification::route('mail', $email)->route('whatsapp', $phone)`) so guests AND customers use the same path; for registered customers also keep the `database` notification. Replace direct `$customer->notify(...)` calls in `OrderService`, `BookingService` (also `changeStatus` — currently guarded by `if ($order->customer)` which silently skips guests). Fix `BookingReminderNotification` / `SendBookingReminders` command to include guests.
> 3. **WhatsApp** — build a custom notification channel `WhatsappChannel` on top of `WhatsappService` (generalise it: `send(string $phone, string $templateKey, array $vars, string $locale, ?Model $subject)`; keep `sendForOrder` as a wrapper). Use the recipient's `customer_locale` instead of hard-coded `ar`. Add bookings support (`booking_id` on logs, booking variables: `booking_ref, service, branch, date, time`). Seed new templates (ar+en): `order_placed`, `booking_created`, `booking_confirmed`, `booking_reminder`, `booking_cancelled` plus existing order ones; all editable in admin. Trigger automatically from `OrderPlaced`, `BookingCreated`, order/booking status changes via queued listeners (do NOT block the HTTP request; the API must succeed even if mail/WhatsApp fails — catch, log to `whatsapp_logs`, retry with backoff). Respect an admin setting group `notifications` (`email_enabled`, `whatsapp_enabled`) — add to `SettingSeeder` + settings UI. Normalise phones with `App\Support\Phone`. Prevent duplicate sends (unique on subject+template+phone within a minute).
> 4. Ensure a queue worker is documented (`php artisan queue:work`) and add supervisor/systemd example to `backend/README`.
> 5. **Admin visibility** — on order and booking detail modals show a "Notifications" tab (email/WhatsApp log status, resend button gated by `orders.update`/`bookings.update`).
> 6. **Tests** — `Mail::fake()`, `Queue::fake()`, `Http::fake()`: guest order → 1 mail + 1 WhatsApp job with correct locale/phone; registered customer gets DB + mail + WhatsApp; failures don't break checkout; status change notifies guests; booking flows; disabled setting skips channel. Commit.

## PHASE 6 — Public settings API + floating WhatsApp button

**Prompt:**
> Work in `/var/www/tiremax`. 1) **Backend**: add public, cached (60s, bust on settings save in `SettingManager`) `GET /api/v1/settings/public` returning only a whitelist: `site_name, site_tagline, site_email, site_phone, whatsapp_number, address, social links, whatsapp_default_message (translatable, new setting)`. Never expose secrets/gateway keys. Add `whatsapp_default_message` + `whatsapp_button_enabled` (bool) to `SettingSeeder` and the settings admin UI (ar/en). Add a normalised `whatsapp_url` field server-side built with `https://wa.me/<digits>?text=<urlencoded message>` where digits come from `Phone::normalize()` (Iraq numbers `+964…`; wa.me requires digits only, country code, no `+`/leading zeros). Note: wa.me/api.whatsapp.com are reachable in Iraq; add `https://api.whatsapp.com/send?phone=<digits>&text=` as `whatsapp_url_fallback` and use `wa.me` primarily.
> 2. **Frontend** (`frontend/`): create `components/shared/WhatsappFloatingButton.tsx` — fixed anchor `<a href={whatsapp_url} target="_blank" rel="noopener noreferrer" aria-label="WhatsApp">` with the WhatsApp glyph (`FaWhatsapp` from react-icons or existing `WhatsappLogoIcon`) in brand green `#25D366`, white icon, circular 56px, shadow, hover scale, `z-index` above content but BELOW dialogs, positioned bottom-right (`insetInlineEnd`, so it flips in RTL) and lifted above the mobile fixed bottom bar (see `components/layout/Header.tsx` for its height). Prefill message localised (`x-locale`). Render it once in `app/[locale]/layout.tsx`; fetch settings server-side (RSC, `revalidate: 60`) so there is no layout shift; hide if `whatsapp_button_enabled` is false or number empty. Also drive Footer/contact phone & socials from the same endpoint if they are hard-coded. Add en/ar aria strings.
> 3. Verify manually: click opens `wa.me/964…` conversation on mobile & desktop. Build passes. Commit.

## PHASE 7 — Guest checkout & booking — Next.js frontend

**Prompt:**
> Work in `/var/www/tiremax/frontend`. Depends on Phases 4–5 API. Goal: no login required to browse, cart, checkout, book; login is optional and offered.
>
> 1. **Guest token** — `helpers/guestToken.ts`: get-or-create UUID persisted in a cookie (`tiremax_guest`, 1 year, SameSite=Lax) readable client+server; `utils/axiosInstance.ts` always sends `X-Guest-Token` and only sends `Authorization` when a token exists (currently sends `Bearer undefined`). Fix the 401 handler so it does NOT redirect guests on public endpoints (only redirect for protected endpoints).
> 2. **middleware.ts** — remove `/cart` and `/checkout` from `PROTECTED_ROUTES` (keep profile, favorites, notifications). Guests can open `/cart` and `/checkout`.
> 3. **Cart** — `useCart` must fetch/mutate the cart for guests too (currently `useEffect` only when `isLogged`); after login/register the server merges the cart — refetch it.
> 4. **Checkout** — `CheckoutForm.tsx`: remove `protectedWithAuth` wrapper on submit. Name/phone/email fields: prefilled for logged-in customers, required for guests (update `Schemas/createOrderSchemas.ts`: name + Iraqi phone regex required; email optional but validated). Add a soft "Have an account? Log in" link and an optional "Create account with this order" checkbox+password (calls register with `guest_token` after order success). After success go to `/checkout/confirm/[orderId]`; that page and its data fetch must work for guests using token/reference (adapt to the Phase 4 endpoint) and show "Create an account to track your orders" CTA for guests (`?authDialog=on&phone=`).
> 5. **Reservation** — `ReservationProvider`/`ConfirmBooking`: remove `protectedWithAuth`; add guest contact step/fields (name, phone, email optional) with validation; success screen with reference and account CTA. Add validation for past dates.
> 6. **Auth** — `useAuth` register/login send `X-Guest-Token`; on success show a toast "N previous orders were linked to your account" using `meta.linked_orders/linked_bookings`, invalidate react-query caches (`orders`, `bookings`, `cart`). Prefill register form phone/email from query params. Clear the guest cookie after successful linking.
> 7. **Guest order lookup** — optional page `/track-order` (reference + phone) hitting the guest endpoint, linked from footer and email.
> 8. i18n: add every new string to `locale/en.json` and `locale/ar.json`; RTL check. `npm run build` + `npm run lint` must pass. Manual QA script: (a) guest orders COD → confirm page → email in mail log; (b) guest books; (c) register with same phone → profile shows both. Commit.

## PHASE 8 — Flutter app parity (small)

**Prompt:**
> Work in `/var/www/tiremax/flutter_app` following `app_instructions.md` conventions. Mirror Phase 7: generate/persist a guest UUID (`shared_preferences`), send `X-Guest-Token` on every request, allow cart/checkout/booking without login (remove the login gate for those flows, keep for profile/favorites/notifications), guest contact fields on checkout/booking, send guest token on login/register and show the "linked orders" result, add the floating green WhatsApp FAB (url from `/settings/public`, `url_launcher`, external application mode). `flutter analyze` must be clean. Commit.

## PHASE 9 — Final QA & hardening (QC sweep)

**Prompt:**
> Act as QA lead on the whole repo. 1) Run all backend tests; add missing ones until each admin route, each list filter, guest order/booking, register-linking, notification dispatch and each permission are covered. 2) Walk every admin page with three roles (super-admin, support, content-manager) and confirm: menu hides forbidden items, forbidden URLs give 403, forbidden buttons are absent and forbidden Livewire calls fail. Produce a table `QA_REPORT.md` (page × role × result). 3) Security review: guest endpoints (IDOR by numeric id, rate limits, mass assignment, price/discount tampering, phone enumeration on register/login responses, CSRF on admin POSTs, XSS in notes shown in admin). 4) Performance: N+1 check on the list pages (`preventLazyLoading` in non-prod), indexes for every filter column added (orders.status/type/payment_status/created_at, bookings.scheduled_at/status, customers.is_active/is_banned, products.is_active/is_featured/stock). 5) Fix everything found, run `php artisan test`, `npm run build`, `flutter analyze`, and commit with a summary of findings/fixes.

---

## Decisions taken (change before running if you disagree)
- Guest cart is **server-side keyed by `X-Guest-Token`** (works for web + Flutter, merges cleanly on login) rather than localStorage-only.
- Guest data is never auto-attached to an *existing* customer at checkout; linking happens only on that customer's register/login (prevents someone ordering with your phone number and appearing in your account).
- Linking key priority: guest token → normalised phone → email (same-phone linking is the requirement; email is an extra).
- WhatsApp button uses `wa.me` (works in Iraq) with `api.whatsapp.com` fallback; number comes from the existing `whatsapp_number` setting.
- Permission naming changes from `manage_*` to `<module>.<action>`, with a data migration for existing roles.
- Outbound WhatsApp sending requires a provider (`WHATSAPP_API_URL/TOKEN/FROM_NUMBER` in `.env`) — the plan wires the triggers, you must supply credentials; email needs real SMTP credentials.
