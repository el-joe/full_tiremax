import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_provider.dart';
import '../data/notifications_repository.dart';
import '../models/notification.dart';

/// The notifications list, backed by `GET /notifications`. Also drives
/// [unreadCountProvider] to keep the bottom-nav badge and this list's
/// "unread" left-accent bars consistent after marking read.
class NotificationsListNotifier extends AsyncNotifier<List<AppNotification>> {
  @override
  Future<List<AppNotification>> build() async {
    final repository = ref.read(notificationsRepositoryProvider);
    return repository.fetchNotifications();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      final repository = ref.read(notificationsRepositoryProvider);
      return repository.fetchNotifications();
    });
  }

  Future<void> markRead(String id) async {
    final previous = state.value ?? const [];
    final index = previous.indexWhere((n) => n.id == id);
    if (index == -1 || previous[index].is_read) return;

    final next = [...previous];
    next[index] = previous[index].copyWith(read_at: DateTime.now().toIso8601String());
    state = AsyncData(next);

    final repository = ref.read(notificationsRepositoryProvider);
    try {
      await repository.markRead(id);
      ref.invalidate(unreadCountProvider);
    } catch (_) {
      state = AsyncData(previous);
    }
  }

  Future<void> markAllRead() async {
    final previous = state.value ?? const [];
    final next = previous
        .map((n) => n.is_read ? n : n.copyWith(read_at: DateTime.now().toIso8601String()))
        .toList();
    state = AsyncData(next);

    final repository = ref.read(notificationsRepositoryProvider);
    try {
      await repository.markAllRead();
      ref.invalidate(unreadCountProvider);
    } catch (_) {
      state = AsyncData(previous);
    }
  }
}

final notificationsListProvider =
    AsyncNotifierProvider<NotificationsListNotifier, List<AppNotification>>(
  NotificationsListNotifier.new,
);

/// Drives the bottom-nav unread badge. Re-fetched whenever it's invalidated
/// (e.g. after marking read/all-read) and refreshed periodically while the
/// app is open, mirroring `useNotifications`' unread-count polling.
final unreadCountProvider = FutureProvider<int>((ref) async {
  final isLoggedIn = ref.watch(isLoggedInProvider);
  if (!isLoggedIn) return 0;
  final repository = ref.read(notificationsRepositoryProvider);
  try {
    return await repository.fetchUnreadCount();
  } catch (_) {
    return 0;
  }
});
