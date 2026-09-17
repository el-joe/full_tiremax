// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'governorate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Governorate _$GovernorateFromJson(Map<String, dynamic> json) => _Governorate(
  id: (json['id'] as num).toInt(),
  code: json['code'] as String,
  name: json['name'] as String,
  is_basra: json['is_basra'] as bool,
  shipping_fee: json['shipping_fee'] as num,
);

Map<String, dynamic> _$GovernorateToJson(_Governorate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'is_basra': instance.is_basra,
      'shipping_fee': instance.shipping_fee,
    };
