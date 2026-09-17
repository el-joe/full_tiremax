// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flash_sale_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FlashSaleInfo _$FlashSaleInfoFromJson(Map<String, dynamic> json) =>
    _FlashSaleInfo(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      discount_percent: json['discount_percent'] as num,
      ends_at: json['ends_at'] as String,
      countdown_seconds: (json['countdown_seconds'] as num).toInt(),
    );

Map<String, dynamic> _$FlashSaleInfoToJson(_FlashSaleInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'discount_percent': instance.discount_percent,
      'ends_at': instance.ends_at,
      'countdown_seconds': instance.countdown_seconds,
    };
