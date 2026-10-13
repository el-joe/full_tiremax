import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/protected_action.dart';
import '../../features/cart/providers/cart_provider.dart';
import '../../l10n/l10n.dart';

typedef _Tab = ({
  IconData icon,
  IconData activeIcon,
  String label,
  String path,
  bool auth,
});

/// Dark persistent bottom bar: Home, Store, Services, Cart (item-count badge),
/// Profile (auth-gated). Favorites and notifications live in Profile.
/// Sub-routes keep their parent tab highlighted (e.g. /product/* -> Store,
/// /reservation -> Services, /checkout -> Cart, /profile/* -> Profile).
class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  List<_Tab> _tabs(BuildContext context) {
    final l10n = context.l10n;
    return [
      (
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        label: l10n.navHome,
        path: '/',
        auth: false,
      ),
      (
        icon: Icons.storefront_outlined,
        activeIcon: Icons.storefront,
        label: l10n.navStore,
        path: '/store',
        auth: false,
      ),
      (
        icon: Icons.build_outlined,
        activeIcon: Icons.build,
        label: l10n.navServices,
        path: '/services',
        auth: false,
      ),
      (
        icon: Icons.shopping_cart_outlined,
        activeIcon: Icons.shopping_cart,
        label: l10n.cartTitle,
        path: '/cart',
        auth: false,
      ),
      (
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: l10n.profileTitle,
        path: '/profile',
        auth: true,
      ),
    ];
  }

  /// Index of the tab owning [location], or -1 when none does.
  static int indexForLocation(String location) {
    if (location == '/') return 0;
    if (location.startsWith('/store') ||
        location.startsWith('/product') ||
        location.startsWith('/offers'))
      return 1;
    if (location.startsWith('/services') || location.startsWith('/reservation'))
      return 2;
    if (location.startsWith('/cart') ||
        location.startsWith('/checkout') ||
        location.startsWith('/order-confirmation'))
      return 3;
    if (location.startsWith('/profile') ||
        location.startsWith('/favorites') ||
        location.startsWith('/notifications'))
      return 4;
    return -1;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabs = _tabs(context);
    final current = indexForLocation(GoRouterState.of(context).matchedLocation);
    final cartCount = ref.watch(cartProvider).value?.items_count ?? 0;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.chrome,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 12,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              for (var i = 0; i < tabs.length; i++)
                Expanded(
                  child: _NavItem(
                    icon: i == current ? tabs[i].activeIcon : tabs[i].icon,
                    label: tabs[i].label,
                    active: i == current,
                    badgeCount: tabs[i].path == '/cart' ? cartCount : 0,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      final tab = tabs[i];
                      if (tab.auth) {
                        requireAuth(context, ref, () => context.go(tab.path));
                      } else {
                        context.go(tab.path);
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
    this.badgeCount = 0,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : const Color(0xFFA1A1AA);
    return Semantics(
      button: true,
      selected: active,
      label: label,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedScale(
                  scale: active ? 1.1 : 1,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(icon, color: color, size: 24),
                ),
                if (badgeCount > 0)
                  PositionedDirectional(
                    top: -6,
                    end: -10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        badgeCount > 99 ? '99+' : '$badgeCount',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textScaler: TextScaler.noScaling,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
