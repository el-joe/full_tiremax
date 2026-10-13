import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/widgets/widgets.dart';
import '../../auth/providers/auth_provider.dart';

/// Account hub: header card (name/phone) + grouped list tiles. Language
/// toggle and logout (confirm dialog) live here; the web dashboard widgets
/// (recent orders, favourites grid, upcoming booking) are intentionally
/// dropped — each has its own screen.
class ProfileHomeScreen extends ConsumerWidget {
  const ProfileHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customer = ref.watch(customerProvider);
    final locale = ref.watch(localeProvider);
    final l = context.l10n;
    final isAr = locale.languageCode == 'ar';

    Widget section(String title, List<Widget> tiles) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xs,
            AppSpacing.xl,
            AppSpacing.xs,
            AppSpacing.sm,
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.gray2,
            ),
          ),
        ),
        TileGroup(children: tiles),
      ],
    );

    return AppScaffold(
      title: l.profileTitle,
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        children: [
          AppCard(
            onTap: () => context.push('/profile/settings'),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    (customer?.name ?? '').trim().isEmpty
                        ? '?'
                        : customer!.name.trim().characters.first.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.chrome,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer?.name ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.foregroundLight,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        customer?.phone ?? '',
                        textDirection: TextDirection.ltr,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.gray2,
                        ),
                      ),
                      if ((customer?.email ?? '').isNotEmpty)
                        Text(
                          customer!.email!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textDirection: TextDirection.ltr,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.gray2,
                          ),
                        ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.edit_outlined,
                  size: 20,
                  color: AppColors.gray2,
                ),
              ],
            ),
          ),
          section(l.profileSectionActivity, [
            GroupTile(
              icon: Icons.receipt_long_outlined,
              label: l.profileMyOrders,
              onTap: () => context.push('/profile/orders'),
            ),
            GroupTile(
              icon: Icons.event_available_outlined,
              label: l.profileMyBookings,
              onTap: () => context.push('/profile/reservations'),
            ),
            GroupTile(
              icon: Icons.favorite_border,
              label: l.favorites,
              onTap: () => context.push('/favorites'),
            ),
            GroupTile(
              icon: Icons.notifications_none,
              label: l.notificationsTitle,
              onTap: () => context.push('/notifications'),
            ),
            GroupTile(
              icon: Icons.local_shipping_outlined,
              label: l.trackOrder,
              onTap: () => context.push('/track-order'),
            ),
          ]),
          section(l.profileSectionAccount, [
            GroupTile(
              icon: Icons.settings_outlined,
              label: l.profileSettings,
              onTap: () => context.push('/profile/settings'),
            ),
            GroupTile(
              icon: Icons.location_on_outlined,
              label: l.profileAddresses,
              onTap: () => context.push('/profile/addresses'),
            ),
            GroupTile(
              icon: Icons.language,
              label: l.profileLanguage,
              onTap: () => ref
                  .read(localeProvider.notifier)
                  .setLocale(Locale(isAr ? 'en' : 'ar')),
              trailing: StatusPill(
                label: isAr
                    ? l.profileLanguageEnglish
                    : l.profileLanguageArabic,
                color: AppColors.blue,
              ),
            ),
          ]),
          section(l.profileSectionSupport, [
            GroupTile(
              icon: Icons.support_agent_outlined,
              label: l.contactUs,
              onTap: () => context.push('/contact'),
            ),
            GroupTile(
              icon: Icons.privacy_tip_outlined,
              label: l.profilePrivacyPolicy,
              onTap: () => context.push('/privacy-policy'),
            ),
            GroupTile(
              icon: Icons.description_outlined,
              label: l.profileTerms,
              onTap: () => context.push('/terms'),
            ),
          ]),
          const SizedBox(height: AppSpacing.xl),
          TileGroup(
            children: [
              GroupTile(
                icon: Icons.logout,
                label: l.profileLogOut,
                destructive: true,
                onTap: () => _confirmLogout(context, ref),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          context.l10n.logoutTitle,
          style: const TextStyle(
            color: AppColors.foregroundLight,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          context.l10n.logoutWarning,
          style: const TextStyle(color: AppColors.gray2),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              context.l10n.logoutCancel,
              style: const TextStyle(color: AppColors.gray2),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go('/');
            },
            child: Text(
              context.l10n.logoutConfirm,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
