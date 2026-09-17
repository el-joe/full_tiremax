// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Address _$AddressFromJson(Map<String, dynamic> json) => _Address(
  id: (json['id'] as num).toInt(),
  full_name: json['full_name'] as String,
  phone: json['phone'] as String,
  governorate: Governorate.fromJson(
    json['governorate'] as Map<String, dynamic>,
  ),
  city: City.fromJson(json['city'] as Map<String, dynamic>),
  address: json['address'] as String,
  is_default: json['is_default'] as bool,
);

Map<String, dynamic> _$AddressToJson(_Address instance) => <String, dynamic>{
  'id': instance.id,
  'full_name': instance.full_name,
  'phone': instance.phone,
  'governorate': instance.governorate,
  'city': instance.city,
  'address': instance.address,
  'is_default': instance.is_default,
};
