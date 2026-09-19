import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/utils/protected_action.dart';
import '../../features/notifications/providers/notifications_provider.dart';
import '../../l10n/app_localizations.dart';

/// Persistent bottom navigation matching the web's mobile fixed bottom bar:
/// Home/Store/Services/Reservation nav items + a pill-shaped floating action
/// cluster for Cart/Favorites/Notifications(with unread badge)/Profile.
class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  List<({IconData icon, IconData activeIcon, String label, String path})> _primaryTabs(
    AppLocalizations l10n,
  ) => [
    (icon: Icons.home_outlined, activeIcon: Icons.home, label: l10n.navHome, path: '/'),
    (icon: Icons.storefront_outlined, activeIcon: Icons.storefront, label: l10n.navStore, path: '/store'),
    (icon: Icons.build_outlined, activeIcon: Icons.build, label: l10n.navServices, path: '/services'),
    (icon: Icons.event_available_outlined, activeIcon: Icons.event_available, label: l10n.navReservation, path: '/reservation'),
  ];

  int _currentIndex(
    BuildContext context,
    List<({IconData icon, IconData activeIcon, String label, String path})> tabs,
  ) {
    final location = GoRouterState.of(context).matchedLocation;
    final index = tabs.indexWhere((tab) => tab.path == location);
    return index == -1 ? 0 : index;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tabs = _primaryTabs(l10n);
    final currentIndex = _currentIndex(context, tabs);
    final unreadNotifications = ref.watch(unreadCountProvider).value ?? 0;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ActionPill(unreadNotifications: unreadNotifications),
            const SizedBox(height: 8),
            _PrimaryTabsBar(currentIndex: currentIndex, tabs: tabs),
          ],
        ),
      ),
    );
  }
}

class _PrimaryTabsBar extends StatelessWidget {
  const _PrimaryTabsBar({required this.currentIndex, required this.tabs});

  final int currentIndex;
  final List<({IconData icon, IconData activeIcon, String label, String path})> tabs;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.gray3,
        borderRadius: AppRadii.radiusFull,
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var i = 0; i < tabs.length; i++)
            _NavItem(
              icon: i == currentIndex ? tabs[i].activeIcon : tabs[i].icon,
              label: tabs[i].label,
              active: i == currentIndex,
              onTap: () => context.go(tabs[i].path),
            ),
        ],
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
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : AppColors.foregroundDark;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.radiusFull,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

/// Pill-shaped floating action cluster: Cart, Favorites, Notifications
/// (unread badge), Profile — each gated by [requireAuth].
class _ActionPill extends ConsumerWidget {
  const _ActionPill({required this.unreadNotifications});

  final int unreadNotifications;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: AppRadii.radiusFull,
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PillIcon(
            icon: Icons.shopping_cart_outlined,
            onTap: () => context.push('/cart'),
          ),
          _PillIcon(
            icon: Icons.favorite_border,
            onTap: () => requireAuth(context, ref, () => context.push('/favorites')),
          ),
          _PillIcon(
            icon: Icons.notifications_none,
            badgeCount: unreadNotifications,
            onTap: () => requireAuth(context, ref, () => context.push('/notifications')),
          ),
          _PillIcon(
            icon: Icons.person_outline,
            onTap: () => requireAuth(context, ref, () => context.push('/profile')),
          ),
        ],
      ),
    );
  }
}

class _PillIcon extends StatelessWidget {
  const _PillIcon({required this.icon, required this.onTap, this.badgeCount = 0});

  final IconData icon;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.radiusFull,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icon, color: AppColors.onPrimary, size: 22),
            if (badgeCount > 0)
              PositionedDirectional(
                top: -4,
                end: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: AppRadii.radiusFull,
                  ),
                  child: Text(
                    badgeCount > 99 ? '99+' : '$badgeCount',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
