import '../../../l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../orders/presentation/order_widgets.dart' show NeedHelpCard;
import '../models/notification.dart';
import '../providers/notifications_provider.dart';

/// GET /notifications list, tap / context.l10n.markAsRead -> POST
/// /notifications/{id}/read, context.l10n.markAllAsRead -> POST /notifications/read-all.
/// Mirrors `frontend/app/[locale]/notifications/**` (heading, list, promo
/// banner + help card).
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsListProvider);
    final notifier = ref.read(notificationsListProvider.notifier);
    final hasUnread = (notificationsAsync.value ?? const []).any((n) => !n.is_read);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, title: Text(context.l10n.notifications)),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: notifier.refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              Text(context.l10n.notifications,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              Text(context.l10n.notificationsHeadingDescription,
                  textAlign: TextAlign.center, style: TextStyle(color: AppColors.gray2, fontSize: 14)),
              const SizedBox(height: 28),
              notificationsAsync.when(
                loading: () => Column(
                  children: [
                    for (var i = 0; i < 4; i++)
                      Container(
                        height: 56,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(color: AppColors.gray3, borderRadius: AppRadii.radiusLg),
                      ),
                  ],
                ),
                error: (error, _) => Column(
                  children: [
                    Text(context.l10n.unexpectedError, style: TextStyle(color: AppColors.gray2)),
                    const SizedBox(height: 12),
                    OutlinedButton(onPressed: notifier.refresh, child: Text(context.l10n.retry)),
                  ],
                ),
                data: (notifications) {
                  if (notifications.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text(context.l10n.youDontHaveNotifications,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (hasUnread)
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: notifier.markAllRead,
                              child: Text(context.l10n.markAllAsRead),
                            ),
                          ),
                        ),
                      for (final n in notifications) ...[
                        _NotificationTile(
                          notification: n,
                          onTap: () {
                            if (n.is_read) return;
                            notifier.markRead(n.id);
                          },
                        ),
                        const SizedBox(height: 12),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              const _PromoBanner(),
              const SizedBox(height: 16),
              const NeedHelpCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification, required this.onTap});

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final unread = !notification.is_read;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: unread ? Colors.white : AppColors.gray3,
          borderRadius: BorderRadius.circular(8),
          boxShadow: unread
              ? const [BoxShadow(color: Color(0x0F1A1C1C), blurRadius: 24, offset: Offset(0, 12))]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.notifications_none, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.title,
                      style: TextStyle(
                          color: unread ? AppColors.foregroundLight : Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16)),
                  const SizedBox(height: 2),
                  Text(notification.body,
                      style: TextStyle(color: unread ? const Color(0xFF6B7280) : AppColors.gray2, fontSize: 13)),
                  if (unread) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 30,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: onTap,
                        child: Text(context.l10n.markAsRead, style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Web promo tile linking to the store (`/images/notifications-banner.png`).
class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/store'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Positioned.fill(child: Image.asset('assets/images/notifications-banner.png', fit: BoxFit.cover)),
            Container(
              constraints: const BoxConstraints(minHeight: 185),
              padding: const EdgeInsets.all(24),
              alignment: AlignmentDirectional.bottomStart,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                    child: Text(context.l10n.bestTiresInIraq, style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 14),
                  Text(context.l10n.chooseYourPerfectTire,
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Text(context.l10n.chooseYourPerfectTireDescription,
                      style: TextStyle(color: AppColors.gray4, fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
