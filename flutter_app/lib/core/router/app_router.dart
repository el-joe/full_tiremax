import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';

import '../../features/addresses/presentation/addresses_screen.dart';
import '../../features/auth/presentation/auth_sheet.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/cart/presentation/cart_screen.dart';
import '../../features/checkout/presentation/checkout_screen.dart';
import '../../features/favorites/presentation/favorites_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/offers/presentation/offers_screen.dart';
import '../../features/orders/presentation/order_detail_screen.dart';
import '../../features/orders/presentation/orders_screen.dart';
import '../../features/product/presentation/product_detail_screen.dart';
import '../../features/profile/presentation/legal_screens.dart';
import '../../features/profile/presentation/profile_home_screen.dart';
import '../../features/profile/presentation/profile_settings_screen.dart';
import '../../features/reservation/presentation/profile_reservation_detail_screen.dart';
import '../../features/reservation/presentation/profile_reservations_screen.dart';
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
];

bool isProtectedPath(String path) {
  return protectedRoutes.any(
    (route) => path == route || path.startsWith('$route/'),
  );
}

final routerRefreshProvider = ChangeNotifierProvider<_RouterRefreshNotifier>(
  (ref) {
    final notifier = _RouterRefreshNotifier();
    ref.listen(authProvider, (previous, next) => notifier.refresh());
    return notifier;
  },
);

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
            builder: (context, state) => const StoreScreen(),
          ),
          GoRoute(
            path: '/offers',
            name: 'offers',
            builder: (context, state) => const OffersScreen(),
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
            builder: (context, state) => _PlaceholderScreen(
              title: 'Order Confirmation (${state.pathParameters['id']})',
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

/// Shared shell scaffold wrapping the 4 primary tabs with the bottom nav bar.
class AppShell extends StatelessWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          child,
          // Above the floating bottom nav (pill + tabs bar), bottom-end.
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

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}
