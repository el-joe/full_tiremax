// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Branch _$BranchFromJson(Map<String, dynamic> json) => _Branch(
  id: (json['id'] as num).toInt(),
  code: json['code'] as String,
  name: json['name'] as String,
  address: json['address'] as String,
  description: json['description'] as String?,
  phone: json['phone'] as String,
  email: json['email'] as String?,
  latitude: json['latitude'] as num,
  longitude: json['longitude'] as num,
  is_main: json['is_main'] as bool,
  is_active: json['is_active'] as bool,
  schedules:
      (json['schedules'] as List<dynamic>?)
          ?.map((e) => Schedule.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Schedule>[],
);

Map<String, dynamic> _$BranchToJson(_Branch instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'name': instance.name,
  'address': instance.address,
  'description': instance.description,
  'phone': instance.phone,
  'email': instance.email,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'is_main': instance.is_main,
  'is_active': instance.is_active,
  'schedules': instance.schedules,
};

_Schedule _$ScheduleFromJson(Map<String, dynamic> json) => _Schedule(
  day_of_week: (json['day_of_week'] as num).toInt(),
  opens_at: json['opens_at'] as String?,
  closes_at: json['closes_at'] as String?,
  capacity: (json['capacity'] as num).toInt(),
  is_closed: json['is_closed'] as bool,
);

Map<String, dynamic> _$ScheduleToJson(_Schedule instance) => <String, dynamic>{
  'day_of_week': instance.day_of_week,
  'opens_at': instance.opens_at,
  'closes_at': instance.closes_at,
  'capacity': instance.capacity,
  'is_closed': instance.is_closed,
};
