import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../models/notification.dart';

/// Handles the `/notifications` endpoints, mirroring
/// `frontend/hooks/useNotifications.ts`.
class NotificationsRepository {
  NotificationsRepository(this._dio);

  final Dio _dio;

  Future<List<AppNotification>> fetchNotifications() async {
    final response = await _dio.get('notifications');
    final body = response.data as Map<String, dynamic>;
    final data = body['data'] as List<dynamic>;
    return data
        .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<int> fetchUnreadCount() async {
    final response = await _dio.get('notifications/unread-count');
    final body = response.data as Map<String, dynamic>;
    final data = body['data'];
    if (data is Map<String, dynamic>) {
      return (data['count'] as num?)?.toInt() ?? 0;
    }
    if (data is num) return data.toInt();
    return 0;
  }

  Future<void> markRead(String id) async {
    await _dio.post('notifications/$id/read');
  }

  Future<void> markAllRead() async {
    await _dio.post('notifications/read-all');
  }
}

final notificationsRepositoryProvider = Provider<NotificationsRepository>((ref) {
  return NotificationsRepository(ref.watch(apiClientProvider));
});
