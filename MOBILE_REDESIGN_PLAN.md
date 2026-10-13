# TireMax Mobile Redesign — Plan & Design Spec

Keep from the web: screens, user flow, API calls/payloads, brand colors (#FDB604 primary, #0E0E0E dark, #18181B text, grays), copy/localization (en+ar, RTL), IQD pricing.
Change: layout & interaction style — make it feel like a native, polished mobile app, not a responsive website.
Remove from mobile: web-only marketing filler (long "why us"/testimonial blocks, duplicated CTAs, big banners repeated, footer-like sections, hero text walls, "Show all" duplicates, Need-Help cards repeated on every screen). Keep only what helps a task. Keep contact/help in one place (Profile + Contact screen).

## Mobile design spec (all agents follow this)
**Surfaces/theme**: light content surfaces (#F6F6F7 page, white cards, 16px radius, subtle shadow) with dark (#0E0E0E) only for the app bar/hero accents and bottom bar. Yellow used for primary actions, active states, accents — never large yellow fills behind body text. Consistent 16px page gutter, 8pt spacing grid (4/8/12/16/24).
**Typography** (Almarai): title 20/700, section 16/700, body 14/400, caption 12 (never below 11). Min tap target 44x44.
**Navigation**: bottom nav (Home, Store, Services, Cart w/ badge, Profile); no duplicated nav in app bars. Large-title collapsing `SliverAppBar` on Home/Store; compact app bars elsewhere. Back arrow auto-mirrors for RTL.
**Components** (build once in `lib/shared/widgets/`, reuse everywhere): `AppScaffold`, `SectionHeader` (title + optional "See all"), `AppCard`, `PrimaryButton`/`SecondaryButton` (52px, 14px radius, loading state), `AppTextField` (filled, floating label, inline error), `AppChip`/`FilterChip` row, `PriceText`, `StatusPill`, `EmptyState` (icon+text+CTA), `ErrorState` (retry), skeleton loaders (shimmer) for every list, `BottomSheetScaffold` (drag handle, sticky action bar), `StickyBottomBar` (total + CTA) for product/cart/checkout/reservation.
**Lists/grid**: product grid 2 columns with fixed aspect ratio (no IntrinsicHeight), lazy `SliverGrid`, pull-to-refresh, infinite scroll or "load more" (keep API pagination), sticky filter/sort chips row on Store.
**Product card**: 1:1 image well on white, circular 36px favorite button (top-start), discount % pill + badge (top-end), brand in small caps gray, name 2 lines 13/600, spec line, rating, price (bold) with strikethrough old price, 40px circular yellow add-to-cart button; whole card tappable; add-to-cart gives haptic + snackbar with "View cart" action.
**Product detail**: full-bleed swipeable gallery with page dots, collapsing app bar with back/favorite/share, price block, spec grid, collapsible sections (Description, Specs, Warranty, Reviews), sticky bottom bar (price + Add to cart).
**Home**: compact greeting/search bar (opens Store search), vehicle/size finder as one card, horizontal category/brand chips, horizontal product carousels (Offers, Recommended), 1 promo banner, quick actions (Book service, Track order, Contact). Nothing else.
**Store**: search field + filter button with active-count badge, type chips (All/Tires/Batteries), sort/filter bottom sheet, result count, grid.
**Cart/Checkout/Reservation**: stepper header, one task per step, sticky bottom bar with total and CTA, swipe-to-remove on cart items, address/payment as selectable cards (radio), order summary collapsible.
**Orders/Bookings/Notifications**: segmented status chips, card list with StatusPill, tap to details, pull-to-refresh, empty states with CTA.
**Profile**: header card (name/phone), grouped list tiles (Orders, Reservations, Addresses, Favorites, Notifications, Settings, Language, Contact, Privacy, Terms, Logout) — remove the web dashboard duplicates.
**Motion/feedback**: Hero image transition card→detail, 200ms animated state changes, haptics on key actions, no layout jank (skeletons same size as content), system dark/light respects brand (app is dark-first only for chrome).
**Quality**: SafeArea + keyboard-aware forms, text scales to 1.3x without overflow, RTL verified, all strings via ARB (add keys to en+ar), analyze clean, tests green.

## Token-saving rules
Read only the named Flutter feature files + the shared widgets; do NOT re-read frontend pages except to confirm a field/flow. Never read freezed/g.dart. Report ≤12 lines. Do not commit.

## Phases (sequential, one agent each)
- [x] **R1 Design system + shell**: theme (light surfaces, dark chrome), all shared components above, bottom nav, app bar patterns, ProductCard + ProductGrid rewrite (SliverGrid, fixed aspect), loaders/empty/error states.
- [x] **R2 Home, Store, Offers, Product detail, Services**
- [x] **R3 Cart, Checkout, Order confirmation, Reservation flow, Track order**
- [x] **R4 Auth sheet, Profile (+settings, addresses, orders, reservations), Favorites, Notifications, Contact, Legal**
- [x] **R5 QA**: text-scale 1.3x + RTL + small-screen (360x640) overflow tests via widget tests, analyze, tests, release build; screenshots not possible → list manual-check items for emulator.
