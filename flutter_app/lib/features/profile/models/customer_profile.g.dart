// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomerProfile _$CustomerProfileFromJson(Map<String, dynamic> json) =>
    _CustomerProfile(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      locale: json['locale'] as String,
    );

Map<String, dynamic> _$CustomerProfileToJson(_CustomerProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'locale': instance.locale,
    };
