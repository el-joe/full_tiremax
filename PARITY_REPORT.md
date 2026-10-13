# Parity Report (2026-10-13)

Verified by command: backend `php artisan test` 137/137; `flutter analyze` clean; `flutter test` 60/60; live smoke 29/30 (payment-gateways lacks `is_active` until backend fix is deployed); release APK + AAB build (debug-signed).
Not verified: no screen was run on a device/emulator; iOS/desktop/web builds not attempted. Parity is from code comparison.

| Web page | Flutter screen | Status |
|---|---|---|
| / | home_screen | ported (contact form is a button to /contact) |
| store, offers | store_screen (offers = badge preset) | ported |
| store/[slug] | product_detail_screen | ported |
| services, services/reservation | services_screen, reservation_screen | ported (step cards dark, not white) |
| cart, checkout, checkout/confirm | cart, checkout, order_confirmation | ported (Paymob return has no deep link) |
| profile (+orders, reservation, address, settings) | profile_* screens | ported (no sidebar/avatar) |
| favorites, notifications | favorites, notifications | ported |
| contact, track-order | contact, track_order | added |
| privacy-policy, termsAndConditions | legal_screens | ported |

Open: Paymob deep link, account deletion for stores, final signing key, app id decision, icon padding, backend deploy of API fixes (see PUBLISH_CHECKLIST.md, API_TEST_REPORT.md).
