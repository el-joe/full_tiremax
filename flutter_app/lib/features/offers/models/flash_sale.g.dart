// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flash_sale.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FlashSale _$FlashSaleFromJson(Map<String, dynamic> json) => _FlashSale(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  discount_percent: json['discount_percent'] as num,
  starts_at: json['starts_at'] as String?,
  ends_at: json['ends_at'] as String?,
  is_active: json['is_active'] as bool? ?? true,
);

Map<String, dynamic> _$FlashSaleToJson(_FlashSale instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'discount_percent': instance.discount_percent,
      'starts_at': instance.starts_at,
      'ends_at': instance.ends_at,
      'is_active': instance.is_active,
    };
