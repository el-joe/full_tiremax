import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../l10n/app_localizations.dart';

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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: AppRadii.radiusXl),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.onPrimary,
                    child: Icon(Icons.person, color: AppColors.primary, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.profileWelcome(customer?.name ?? ''),
                            style: const TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.w800, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(customer?.email ?? '', style: const TextStyle(color: AppColors.onPrimary, fontSize: 12)),
                        Text(customer?.phone ?? '', style: const TextStyle(color: AppColors.onPrimary, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
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

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.gray3,
        title: Text(l10n.profileLogOut, style: const TextStyle(color: Colors.white)),
        content: Text(l10n.profileLogOutConfirm, style: const TextStyle(color: AppColors.gray2)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(l10n.commonCancel)),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go('/');
            },
            child: Text(l10n.profileLogOut, style: const TextStyle(color: AppColors.red)),
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
