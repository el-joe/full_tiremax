# QA Report - Phase 9

## Permission matrix (page x role, HTTP status; automated by `RoleMatrixTest`)
Roles seeded by RolePermissionSeeder. Each cell is asserted against the permission catalogue (200 when allowed, 403 when forbidden).

| Page (route) | super-admin | support | content-manager |
|---|---|---|---|
| admin.dashboard | 200 | 200 | 200 |
| admin.dashboard.index | 200 | 200 | 200 |
| admin.brands.index | 200 | 403 | 200 |
| admin.categories.index | 200 | 403 | 200 |
| admin.branches.index | 200 | 403 | 403 |
| admin.governorates.index | 200 | 403 | 403 |
| admin.services.index | 200 | 403 | 403 |
| admin.vehicle-makes.index | 200 | 403 | 200 |
| admin.vehicle-models.index | 200 | 403 | 200 |
| admin.vehicles.index | 200 | 403 | 200 |
| admin.products.index | 200 | 403 | 200 |
| admin.products.create | 200 | 403 | 200 |
| admin.fitments.index | 200 | 403 | 200 |
| admin.orders.index | 200 | 200 | 403 |
| admin.bookings.index | 200 | 200 | 403 |
| admin.customers.index | 200 | 200 | 403 |
| admin.offers.index | 200 | 403 | 200 |
| admin.flash-sales.index | 200 | 403 | 200 |
| admin.reviews.index | 200 | 200 | 200 |
| admin.daftra-logs.index | 200 | 403 | 403 |
| admin.payment-gateways.index | 200 | 403 | 403 |
| admin.settings.index | 200 | 403 | 403 |
| admin.whatsapp-templates.index | 200 | 403 | 403 |
| admin.whatsapp-logs.index | 200 | 403 | 403 |
| admin.admins.index | 200 | 403 | 403 |
| admin.roles.index | 200 | 403 | 403 |
| admin.audit-logs.index | 200 | 403 | 403 |

Also covered by RbacTest: forbidden Livewire mutations fail, every admin route has a `can` middleware, deactivated admin is logged out.

## Findings and fixes
1. SECURITY (fixed): guest->customer linking by phone alone was spoofable. `GuestLinkService` now links by `guest_token` always, by phone only if `phone_verified_at` is set, by email only if `email_verified_at` is set. Result: registering with someone else's number no longer grants their guest orders. Real customers keep history via (a) same browser/app token, (b) admin "Link guest orders" action, (c) automatic linking once their phone is verified (no OTP flow exists yet; adding one is the follow-up that restores phone-based auto-linking). UI toast copy is unchanged (count simply reflects what was linked).
2. Email links (fixed): booking email now links to `/{locale}/profile/reservation`; frontend middleware sends guests hitting `/profile/reservation` to `/track-order`.
3. Checkout (fixed): failed "create account" registration now shows an ar/en info toast (order remains successful); cart state is refetched after an order so the count resets.
4. Reviews: pending/approved/rejected admin filters covered by ListFiltersTest (nullable is_approved).
5. Performance (fixed): `Model::preventLazyLoading` enabled outside production; N+1 on `translations` fixed in Product, Brand, Category, Service, Vehicle(+Make/Model), Governorate, Branch, Offer admin lists.
6. Indexes: migration `2026_09_23_100000_add_filter_indexes` adds missing indexes on orders (status/type/payment_status/created_at), bookings (scheduled_at/status), customers (is_active/is_banned), products (is_active/is_featured/stock); skips those already present.
7. Blade indentation from scripted @can wrapping: not reformatted (no behaviour impact; risk of breaking views outweighed cosmetic gain) - listed under remaining risks.

## Remaining risks
- No phone/email OTP verification, so phone-based auto-linking never triggers for normal customers yet.
- Blade indentation cosmetics from Phase 1 remain.
- Admin XSS: Blade `{{ }}` escaping is used; no raw `{!! !!}` on user notes was reviewed exhaustively.
- Real SMTP/WhatsApp provider behaviour untested.
- Logged-in booking email link goes to the list, not the specific booking.

## Manual QA checklist (not automatable here)
- Guest COD order -> confirmation page -> email in log/inbox; guest booking; register with same browser -> profile shows both.
- RTL/Arabic layout of checkout, toasts, track-order page.
- Paymob redirect flow; WhatsApp FAB opens wa.me on web and Flutter.
- Admin menu hides forbidden items visually for support and content-manager; buttons absent.
- Email rendering in Gmail/Outlook (ar/en).

## Deployment
1. `composer install --no-dev`, set env: `APP_FRONTEND_URL`, `MAIL_*`, `WHATSAPP_API_URL`, `WHATSAPP_API_TOKEN`, `WHATSAPP_FROM_NUMBER`, queue connection.
2. `php artisan migrate --force`
3. `php artisan db:seed --class=RolePermissionSeeder` and `--class=WhatsappTemplateSeeder`
4. Run a queue worker (`php artisan queue:work`, under supervisor); notifications are queued.
5. `php artisan config:cache route:cache view:cache`; build frontend (`npm run build`) and Flutter release.
