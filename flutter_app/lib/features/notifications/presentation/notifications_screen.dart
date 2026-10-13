import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/format.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/widgets/widgets.dart';
import '../models/notification.dart';
import '../providers/notifications_provider.dart';

/// GET /notifications list grouped Today / Earlier. Tap or swipe marks an
/// item read (POST /notifications/{id}/read); the app-bar action marks all
/// (POST /notifications/read-all).
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final notificationsAsync = ref.watch(notificationsListProvider);
    final notifier = ref.read(notificationsListProvider.notifier);
    final hasUnread = (notificationsAsync.value ?? const []).any(
      (n) => !n.is_read,
    );

    return AppScaffold(
      title: l.notifications,
      actions: [
        if (hasUnread)
          IconButton(
            tooltip: l.markAllAsRead,
            constraints: const BoxConstraints(
              minWidth: AppSpacing.minTap,
              minHeight: AppSpacing.minTap,
            ),
            icon: const Icon(Icons.done_all, color: AppColors.primary),
            onPressed: notifier.markAllRead,
          ),
      ],
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: notifier.refresh,
        child: notificationsAsync.when(
          loading: () => const SkeletonList(itemHeight: 76),
          error: (error, _) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: 360,
                child: ErrorState(
                  message: l.unexpectedError,
                  onRetry: notifier.refresh,
                ),
              ),
            ],
          ),
          data: (notifications) {
            if (notifications.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: 360,
                    child: EmptyState(
                      icon: Icons.notifications_none,
                      title: l.youDontHaveNotifications,
                      message: l.notificationsHeadingDescription,
                    ),
                  ),
                ],
              );
            }
            final now = DateTime.now();
            bool isToday(AppNotification n) {
              final d = n.created_at.toLocal();
              return d.year == now.year &&
                  d.month == now.month &&
                  d.day == now.day;
            }

            final today = notifications.where(isToday).toList();
            final earlier = notifications.where((n) => !isToday(n)).toList();
            Widget group(String title, List<AppNotification> items) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppSpacing.sm,
                    bottom: AppSpacing.sm,
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
                for (final n in items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _NotificationTile(
                      notification: n,
                      onRead: () => notifier.markRead(n.id),
                    ),
                  ),
              ],
            );
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.gutter),
              children: [
                if (today.isNotEmpty) group(l.notificationsToday, today),
                if (earlier.isNotEmpty) group(l.notificationsEarlier, earlier),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification, required this.onRead});

  final AppNotification notification;
  final VoidCallback onRead;

  @override
  Widget build(BuildContext context) {
    final unread = !notification.is_read;
    final card = AppCard(
      onTap: unread ? onRead : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: unread
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : AppColors.gray4,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.notifications_none,
              size: 22,
              color: unread ? AppColors.onPrimary : AppColors.gray2,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: unread ? FontWeight.w700 : FontWeight.w400,
                    color: AppColors.foregroundLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  notification.body,
                  style: const TextStyle(fontSize: 13, color: AppColors.gray2),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  formatDateLocalized(
                    'MMM d, h:mm a',
                    notification.created_at.toLocal(),
                  ),
                  style: const TextStyle(fontSize: 12, color: AppColors.gray2),
                ),
              ],
            ),
          ),
          if (unread)
            Container(
              key: const ValueKey('unread-dot'),
              width: 10,
              height: 10,
              margin: const EdgeInsetsDirectional.only(
                start: AppSpacing.sm,
                top: 4,
              ),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
    if (!unread) return card;
    return Dismissible(
      key: ValueKey('n-${notification.id}'),
      background: _swipeBg(Alignment.centerLeft),
      secondaryBackground: _swipeBg(Alignment.centerRight),
      confirmDismiss: (_) async {
        onRead();
        return false;
      },
      child: card,
    );
  }

  Widget _swipeBg(Alignment a) => Container(
    alignment: a,
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
    decoration: BoxDecoration(
      color: AppColors.green.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(16),
    ),
    child: const Icon(Icons.done, color: AppColors.green),
  );
}
