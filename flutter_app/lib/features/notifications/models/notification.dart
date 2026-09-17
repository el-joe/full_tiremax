import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

/// Mirrors `frontend/types/notification.type.ts` (`INotification`).
///
/// NOTE: the real API response (per the Postman collection) does NOT carry
/// top-level `title`/`body` fields — only nested inside `data` (e.g.
/// `{ id, type, data: { title, body, order_id }, read_at, created_at }`).
/// [title]/[body] below are convenience getters proxying to [data] so
/// call sites can keep reading `notification.title` /
/// `notification.body` directly.
@freezed
abstract class AppNotification with _$AppNotification {
  const AppNotification._();

  const factory AppNotification({
    required String id,
    required String type,
    @JsonKey(fromJson: _notificationDataFromJson, toJson: _notificationDataToJson)
    required NotificationData data,
    String? read_at,
    required DateTime created_at,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);

  String get title => data.title;
  String get body => data.body;
  bool get is_read => read_at != null;
}

/// Mirrors `Data` nested in `notification.type.ts`:
/// `{ title, body, order_id?, [key: string]: unknown }`.
@freezed
abstract class NotificationData with _$NotificationData {
  const factory NotificationData({
    required String title,
    required String body,
    int? order_id,
    @Default(<String, dynamic>{}) Map<String, dynamic> extra,
  }) = _NotificationData;

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    final known = {'title', 'body', 'order_id'};
    final extra = Map<String, dynamic>.fromEntries(
      json.entries.where((e) => !known.contains(e.key)),
    );
    return NotificationData(
      title: json['title'] as String,
      body: json['body'] as String,
      order_id: json['order_id'] as int?,
      extra: extra,
    );
  }
}

NotificationData _notificationDataFromJson(Map<String, dynamic> json) =>
    NotificationData.fromJson(json);

Map<String, dynamic> _notificationDataToJson(NotificationData data) => {
  'title': data.title,
  'body': data.body,
  if (data.order_id != null) 'order_id': data.order_id,
  ...data.extra,
};
