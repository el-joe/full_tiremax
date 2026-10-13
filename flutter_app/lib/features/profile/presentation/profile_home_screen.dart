import '../../../l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/format.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/web_sheet.dart';
import '../../favorites/presentation/favorites_screen.dart' show customerFavToProduct;
import '../../favorites/providers/favorites_list_provider.dart';
import '../../orders/providers/orders_provider.dart';
import '../../reservation/data/reservation_repository.dart';
import '../../../core/theme/app_radii.dart';
import '../../auth/providers/auth_provider.dart';

/// Account summary card + navigation to Settings/Addresses/Orders/
/// Reservations + Logout (confirm dialog) + language toggle + Privacy
/// Policy/Terms links. Mirrors `frontend/app/[locale]/profile/page.tsx`.
class ProfileHomeScreen extends ConsumerWidget {
  const ProfileHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customer = ref.watch(customerProvider);
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, title: Text(l10n.profileTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('${context.l10n.webProfileWelcome} ${customer?.name ?? ''}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24)),
            const SizedBox(height: 16),
            _InfoCard(
              title: context.l10n.profilePersonalInformation,
              actionLabel: context.l10n.edit,
              onAction: () => context.push('/profile/settings'),
              child: Wrap(
                runSpacing: 14,
                children: [
                  _field(context.l10n.profileFullName, customer?.name, half: true),
                  _field(context.l10n.profilePhoneNumber, customer?.phone, half: true),
                  _field(context.l10n.primaryAddress, customer?.address, icon: Icons.location_on_outlined),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const _UpcomingBookingCard(),
            const SizedBox(height: 16),
            const _FavoritesSection(),
            const SizedBox(height: 16),
            const _RecentOrdersCard(),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => context.push('/reservation'),
                icon: const Icon(Icons.add_circle_outline),
                label: Text(context.l10n.bookNewService, style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 20),
            _NavTile(icon: Icons.settings_outlined, label: l10n.profileSettings, onTap: () => context.push('/profile/settings')),
            _NavTile(icon: Icons.location_on_outlined, label: l10n.profileAddresses, onTap: () => context.push('/profile/addresses')),
            _NavTile(icon: Icons.receipt_long_outlined, label: l10n.profileMyOrders, onTap: () => context.push('/profile/orders')),
            _NavTile(icon: Icons.event_available_outlined, label: l10n.profileMyBookings, onTap: () => context.push('/profile/reservations')),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(color: AppColors.gray3, borderRadius: AppRadii.radiusXl),
              child: ListTile(
                leading: const Icon(Icons.language, color: Colors.white),
                title: Text(l10n.profileLanguage, style: const TextStyle(color: Colors.white)),
                trailing: DropdownButton<Locale>(
                  value: locale,
                  dropdownColor: AppColors.gray3,
                  underline: const SizedBox.shrink(),
                  items: [
                    DropdownMenuItem(value: const Locale('en'), child: Text(l10n.profileLanguageEnglish, style: const TextStyle(color: Colors.white))),
                    DropdownMenuItem(value: const Locale('ar'), child: Text(l10n.profileLanguageArabic, style: const TextStyle(color: Colors.white))),
                  ],
                  onChanged: (value) {
                    if (value != null) ref.read(localeProvider.notifier).setLocale(value);
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            _NavTile(icon: Icons.local_shipping_outlined, label: context.l10n.trackOrder, onTap: () => context.push('/track-order')),
            _NavTile(icon: Icons.support_agent_outlined, label: context.l10n.contactUs, onTap: () => context.push('/contact')),
            _NavTile(icon: Icons.privacy_tip_outlined, label: l10n.profilePrivacyPolicy, onTap: () => context.push('/privacy-policy')),
            _NavTile(icon: Icons.description_outlined, label: l10n.profileTerms, onTap: () => context.push('/terms')),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.red,
                  side: const BorderSide(color: AppColors.red),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: AppRadii.radiusLg),
                ),
                onPressed: () => _confirmLogout(context, ref),
                icon: const Icon(Icons.logout),
                label: Text(l10n.profileLogOut, style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, String? value, {bool half = false, IconData? icon}) {
    return LayoutBuilder(builder: (context, c) {
      return SizedBox(
        width: half ? (c.maxWidth - 12) / 2 : double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: AppColors.gray2, fontSize: 10, fontWeight: FontWeight.w700)),
            const SizedBox(height: 3),
            Row(
              children: [
                if (icon != null) ...[Icon(icon, color: AppColors.primary, size: 18), const SizedBox(width: 4)],
                Expanded(
                  child: Text(value ?? '',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.gray3,
        title: Text(context.l10n.logoutTitle, style: TextStyle(color: Colors.white)),
        content: Text(context.l10n.logoutWarning, style: const TextStyle(color: AppColors.gray2)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(context.l10n.logoutCancel)),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go('/');
            },
            child: Text(context.l10n.logoutConfirm, style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.gray3,
        borderRadius: AppRadii.radiusXl,
        child: InkWell(
          borderRadius: AppRadii.radiusXl,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary),
                const SizedBox(width: 14),
                Expanded(child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
                const Icon(Icons.chevron_right, color: AppColors.gray2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Web dashboard card: gray-4 panel, 4px primary start border, title and a
/// context.l10n.viewAll/context.l10n.commonEdit link.
class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.actionLabel, required this.onAction, required this.child});

  final String title;
  final String actionLabel;
  final VoidCallback onAction;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.gray3,
        borderRadius: BorderRadius.circular(16),
        border: const BorderDirectional(start: BorderSide(color: AppColors.primary, width: 4)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
              ),
              InkWell(
                onTap: onAction,
                child: Text(actionLabel,
                    style: const TextStyle(color: AppColors.gray2, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

/// Web `ReservationComingCard`: the last confirmed booking.
class _UpcomingBookingCard extends ConsumerWidget {
  const _UpcomingBookingCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(bookingsListProvider(1));
    return _InfoCard(
      title: context.l10n.upcomingBookings,
      actionLabel: context.l10n.viewAll,
      onAction: () => context.push('/profile/reservations'),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (_, _) => Text(context.l10n.noReservationYet, style: TextStyle(color: AppColors.gray2)),
        data: (page) {
          final confirmed = page.items.where((r) => r.status == 'confirmed').toList();
          if (confirmed.isEmpty) {
            return Text(context.l10n.noReservationYet, style: TextStyle(color: AppColors.gray2));
          }
          final r = confirmed.last;
          final at = r.scheduled_at.toLocal();
          return InkWell(
            onTap: () => context.push('/profile/reservations/${r.id}'),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 62,
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${at.day}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)),
                      Text(formatDateLocalized('MMM', at),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 10)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r.service.name,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                      const SizedBox(height: 2),
                      Text('${formatDateLocalized('HH:mm', at)} • ${r.branch.name}',
                          style: const TextStyle(color: AppColors.gray2, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Web `FavProductSection`: first three favourites.
class _FavoritesSection extends ConsumerWidget {
  const _FavoritesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(favoritesListProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(context.l10n.favorites,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)),
            ),
            InkWell(
              onTap: () => context.push('/favorites'),
              child: Text(context.l10n.viewAll, style: TextStyle(color: AppColors.gray2, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
        const SizedBox(height: 14),
        async.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (_, _) => Text(context.l10n.noFavoriteProducts, style: TextStyle(color: AppColors.gray2)),
          data: (favs) {
            if (favs.isEmpty) {
              return Center(
                child: Text(context.l10n.noFavoriteProducts, style: TextStyle(color: AppColors.gray2)),
              );
            }
            return ProductGrid(products: favs.take(3).map(customerFavToProduct).toList());
          },
        ),
      ],
    );
  }
}

/// Web `RecentOrders`: five most recent orders.
class _RecentOrdersCard extends ConsumerWidget {
  const _RecentOrdersCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(ordersListProvider((status: null, page: 1)));
    return _InfoCard(
      title: context.l10n.recentOrders,
      actionLabel: context.l10n.viewAll,
      onAction: () => context.push('/profile/orders'),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (_, _) => Text(context.l10n.noOrdersYet, style: TextStyle(color: AppColors.gray2)),
        data: (page) {
          if (page.items.isEmpty) {
            return Center(child: Text(context.l10n.noOrdersYet, style: TextStyle(color: AppColors.gray2)));
          }
          return Column(
            children: [
              for (final o in page.items.take(5))
                InkWell(
                  onTap: () => context.push('/profile/orders/${o.id}'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('#${o.reference}',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                              Text(formatDateLocalized('EEE MMM dd yyyy', DateTime.tryParse(o.placed_at)?.toLocal() ?? DateTime.now()),
                                  style: const TextStyle(color: AppColors.gray2, fontSize: 12)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(formatIqd(o.total),
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            StatusBadge(status: o.status, kind: StatusBadgeKind.recentOrder),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
