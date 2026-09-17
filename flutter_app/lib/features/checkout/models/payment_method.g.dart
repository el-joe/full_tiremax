// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) =>
    _PaymentMethod(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      display_name: json['display_name'] as String,
      driver: json['driver'] as String,
      is_active: json['is_active'] as bool,
    );

Map<String, dynamic> _$PaymentMethodToJson(_PaymentMethod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'display_name': instance.display_name,
      'driver': instance.driver,
      'is_active': instance.is_active,
    };
