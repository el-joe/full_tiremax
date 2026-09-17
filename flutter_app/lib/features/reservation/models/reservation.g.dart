// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Reservation _$ReservationFromJson(Map<String, dynamic> json) => _Reservation(
  id: (json['id'] as num).toInt(),
  reference: json['reference'] as String,
  scheduled_at: DateTime.parse(json['scheduled_at'] as String),
  duration_minutes: (json['duration_minutes'] as num).toInt(),
  status: json['status'] as String,
  customer_notes: json['customer_notes'] as String?,
  branch: ReservationBranch.fromJson(json['branch'] as Map<String, dynamic>),
  service: ReservationService.fromJson(json['service'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ReservationToJson(_Reservation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reference': instance.reference,
      'scheduled_at': instance.scheduled_at.toIso8601String(),
      'duration_minutes': instance.duration_minutes,
      'status': instance.status,
      'customer_notes': instance.customer_notes,
      'branch': instance.branch,
      'service': instance.service,
    };

_ReservationBranch _$ReservationBranchFromJson(Map<String, dynamic> json) =>
    _ReservationBranch(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      latitude: json['latitude'] as num,
      longitude: json['longitude'] as num,
    );

Map<String, dynamic> _$ReservationBranchToJson(_ReservationBranch instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'address': instance.address,
      'phone': instance.phone,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

_ReservationService _$ReservationServiceFromJson(Map<String, dynamic> json) =>
    _ReservationService(
      id: (json['id'] as num).toInt(),
      slug: json['slug'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      duration_minutes: (json['duration_minutes'] as num).toInt(),
      price: json['price'] as num,
    );

Map<String, dynamic> _$ReservationServiceToJson(_ReservationService instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'description': instance.description,
      'duration_minutes': instance.duration_minutes,
      'price': instance.price,
    };
