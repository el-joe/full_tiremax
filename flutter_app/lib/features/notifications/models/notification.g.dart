// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    _AppNotification(
      id: json['id'] as String,
      type: json['type'] as String,
      data: _notificationDataFromJson(json['data'] as Map<String, dynamic>),
      read_at: json['read_at'] as String?,
      created_at: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$AppNotificationToJson(_AppNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'data': _notificationDataToJson(instance.data),
      'read_at': instance.read_at,
      'created_at': instance.created_at.toIso8601String(),
    };
