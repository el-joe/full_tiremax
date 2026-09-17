import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../models/notification.dart';
import '../providers/notifications_provider.dart';

/// GET /notifications list, tap -> POST /notifications/{id}/read (+ navigate
/// to the related order if `data.order_id` is present), "mark all read" ->
/// POST /notifications/read-all. Mirrors
/// `frontend/app/[locale]/notifications/**`.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsListProvider);
    final hasUnread = (notificationsAsync.value ?? const []).any((n) => !n.is_read);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Notifications'),
        actions: [
          if (hasUnread)
            TextButton(
              onPressed: () => ref.read(notificationsListProvider.notifier).markAllRead(),
              child: const Text('Mark all read', style: TextStyle(color: AppColors.primary)),
            ),
        ],
      ),
      body: SafeArea(
        child: notificationsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (error, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$error', style: const TextStyle(color: AppColors.gray2)),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => ref.read(notificationsListProvider.notifier).refresh(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (notifications) {
            if (notifications.isEmpty) {
              return const Center(
                child: Text('No notifications yet.', style: TextStyle(color: AppColors.gray2)),
              );
            }
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => ref.read(notificationsListProvider.notifier).refresh(),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: notifications.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return _NotificationTile(
                    notification: notification,
                    onTap: () {
                      ref.read(notificationsListProvider.notifier).markRead(notification.id);
                      final orderId = notification.data.order_id;
                      if (orderId != null) {
                        context.push('/profile/orders/$orderId');
                      }
                    },
                  );
                },
              ),
            );
          },
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
      borderRadius: AppRadii.radiusXl,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.gray3,
          borderRadius: AppRadii.radiusXl,
          border: Border(
            left: BorderSide(color: unread ? AppColors.primary : Colors.transparent, width: 4),
          ),
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: unread ? FontWeight.w800 : FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(notification.body, style: const TextStyle(color: AppColors.gray2, fontSize: 12)),
                  const SizedBox(height: 6),
                  Text(
                    DateFormat('MMM d, yyyy • h:mm a').format(notification.created_at.toLocal()),
                    style: const TextStyle(color: AppColors.gray2, fontSize: 10),
                  ),
                ],
              ),
            ),
            if (unread)
              Container(
                margin: const EdgeInsets.only(left: 8, top: 2),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              ),
          ],
        ),
      ),
    );
  }
}
