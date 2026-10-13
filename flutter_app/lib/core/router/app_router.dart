import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';

import '../../features/addresses/presentation/addresses_screen.dart';
import '../../features/auth/presentation/auth_sheet.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/cart/presentation/cart_screen.dart';
import '../../features/contact/presentation/contact_screen.dart';
import '../../features/orders/presentation/track_order_screen.dart';
import '../../features/checkout/presentation/checkout_screen.dart';
import '../../features/favorites/presentation/favorites_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/store/data/store_repository.dart';
import '../../features/orders/presentation/order_detail_screen.dart';
import '../../features/orders/presentation/orders_screen.dart';
import '../../features/product/presentation/product_detail_screen.dart';
import '../../features/profile/presentation/legal_screens.dart';
import '../../features/profile/presentation/profile_home_screen.dart';
import '../../features/profile/presentation/profile_settings_screen.dart';
import '../../features/reservation/presentation/profile_reservation_detail_screen.dart';
import '../../features/reservation/presentation/profile_reservations_screen.dart';
import '../../features/orders/presentation/order_confirmation_screen.dart';
import '../../features/reservation/presentation/reservation_screen.dart';
import '../../features/services/presentation/services_screen.dart';
import '../../features/store/presentation/store_screen.dart';
import '../../features/settings/presentation/whatsapp_fab.dart';
import '../../shared/widgets/bottom_nav_bar.dart';

/// Base paths considered auth-gated, mirroring `middleware.ts`'s
/// `PROTECTED_ROUTES`.
const List<String> protectedRoutes = [
  '/profile',
  '/favorites',
  '/notifications',
  '/checkout',
];

bool isProtectedPath(String path) {
  return protectedRoutes.any(
    (route) => path == route || path.startsWith('$route/'),
  );
}

/// Mirrors the first block of `middleware.ts`: guests opening
/// `/profile/(orders|bookings|reservation|reservations)[/ref]` land on
/// `/track-order?type=&reference=&phone=`. Returns null when not applicable.
String? guestTrackingRedirect(Uri uri) {
  final m = RegExp(
    r'^/profile/(orders|bookings|reservations|reservation)(?:/([A-Za-z0-9-]+))?/?$',
  ).firstMatch(uri.path);
  if (m == null) return null;
  final section = m.group(1)!;
  final ref = m.group(2);
  if (ref == null && section == 'orders') return null;
  final query = <String, String>{
    'type': section == 'orders' ? 'order' : 'booking',
    'reference': ?ref,
  };
  final phone = uri.queryParameters['phone'];
  if (phone != null && phone.isNotEmpty) query['phone'] = phone;
  return Uri(path: '/track-order', queryParameters: query).toString();
}

final routerRefreshProvider = ChangeNotifierProvider<_RouterRefreshNotifier>((
  ref,
) {
  final notifier = _RouterRefreshNotifier();
  ref.listen(authProvider, (previous, next) => notifier.refresh());
  return notifier;
});

class _RouterRefreshNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ref.watch(routerRefreshProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) {
      final path = state.matchedLocation;
      final authState = ref.read(authProvider);
      final isLoggedIn = authState.value?.isLoggedIn ?? false;

      // Email links (`/profile/orders/{ref}?phone=`, `/profile/bookings[/ref]`)
      // send guests to the tracking page instead of the login sheet.
      if (!isLoggedIn) {
        final guestLink = guestTrackingRedirect(state.uri);
        if (guestLink != null) return guestLink;
      }

      if (!isLoggedIn && isProtectedPath(path)) {
        // Mirrors middleware.ts redirecting to `/?authDialog=on`.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final ctx = context;
          showAuthSheet(ctx);
        });
        return '/';
      }
      return null;
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/store',
            name: 'store',
            builder: (context, state) {
              // Accepts a ProductFilters via `extra` (home hero search) or the
              // web's `?filter_products_type=` / `?filter_products_badge=`.
              final q = state.uri.queryParameters;
              final filters = state.extra is ProductFilters
                  ? state.extra as ProductFilters
                  : ProductFilters(
                      type: q['filter_products_type'],
                      badge: q['filter_products_badge'],
                      search: q['filter_products_search'],
                    );
              return StoreScreen(initialFilters: filters);
            },
          ),
          GoRoute(
            path: '/offers',
            name: 'offers',
            builder: (context, state) => const StoreScreen(
              isOffers: true,
              initialFilters: ProductFilters(badge: 'special_offer'),
            ),
          ),
          GoRoute(
            path: '/product/:id',
            name: 'product-detail',
            builder: (context, state) => ProductDetailScreen(
              productId: int.parse(state.pathParameters['id']!),
            ),
          ),
          GoRoute(
            path: '/services',
            name: 'services',
            builder: (context, state) => const ServicesScreen(),
          ),
          GoRoute(
            path: '/reservation',
            name: 'reservation',
            builder: (context, state) {
              final serviceId = state.uri.queryParameters['service_id'];
              final branchId = state.uri.queryParameters['branch_id'];
              return ReservationScreen(
                serviceId: serviceId != null ? int.tryParse(serviceId) : null,
                branchId: branchId != null ? int.tryParse(branchId) : null,
              );
            },
          ),
          GoRoute(
            path: '/cart',
            name: 'cart',
            builder: (context, state) => const CartScreen(),
          ),
          GoRoute(
            path: '/checkout',
            name: 'checkout',
            builder: (context, state) => const CheckoutScreen(),
          ),
          GoRoute(
            path: '/order-confirmation/:id',
            name: 'order-confirmation',
            builder: (context, state) => OrderConfirmationScreen(
              orderId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
            ),
          ),
          GoRoute(
            path: '/favorites',
            name: 'favorites',
            builder: (context, state) => const FavoritesScreen(),
          ),
          GoRoute(
            path: '/notifications',
            name: 'notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileHomeScreen(),
          ),
          GoRoute(
            path: '/profile/settings',
            name: 'profile-settings',
            builder: (context, state) => const ProfileSettingsScreen(),
          ),
          GoRoute(
            path: '/profile/addresses',
            name: 'profile-addresses',
            builder: (context, state) => const AddressesScreen(),
          ),
          GoRoute(
            path: '/profile/orders',
            name: 'profile-orders',
            builder: (context, state) => const OrdersScreen(),
          ),
          GoRoute(
            path: '/profile/orders/:id',
            name: 'profile-order-detail',
            builder: (context, state) => OrderDetailScreen(
              orderId: int.parse(state.pathParameters['id']!),
            ),
          ),
          GoRoute(
            path: '/profile/reservations',
            name: 'profile-reservations',
            builder: (context, state) => const ProfileReservationsScreen(),
          ),
          GoRoute(
            path: '/profile/reservations/:id',
            name: 'profile-reservation-detail',
            builder: (context, state) => ProfileReservationDetailScreen(
              reservationId: int.parse(state.pathParameters['id']!),
            ),
          ),
          GoRoute(
            path: '/contact',
            name: 'contact',
            builder: (context, state) => const ContactScreen(),
          ),
          GoRoute(
            path: '/track-order',
            name: 'track-order',
            builder: (context, state) => TrackOrderScreen(
              reference: state.uri.queryParameters['reference'],
              phone: state.uri.queryParameters['phone'],
              type: state.uri.queryParameters['type'],
            ),
          ),
          GoRoute(
            path: '/privacy-policy',
            name: 'privacy-policy',
            builder: (context, state) => const PrivacyPolicyScreen(),
          ),
          GoRoute(
            path: '/terms',
            name: 'terms',
            builder: (context, state) => const TermsAndConditionsScreen(),
          ),
        ],
      ),
    ],
  );
});

/// Shared shell scaffold wrapping the 5 primary tabs (Home, Store, Services, Cart, Profile) with the bottom nav bar.
class AppShell extends StatelessWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          child,
          // Bottom-end, above the bottom bar.
          const PositionedDirectional(
            end: 16,
            bottom: 12,
            child: WhatsappFab(),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
