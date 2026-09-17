// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomerCart _$CustomerCartFromJson(Map<String, dynamic> json) =>
    _CustomerCart(
      id: (json['id'] as num).toInt(),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => CartItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <CartItem>[],
      subtotal: json['subtotal'] as num,
      items_count: (json['items_count'] as num).toInt(),
      governorate_id: (json['governorate_id'] as num?)?.toInt(),
      governorate: json['governorate'] == null
          ? null
          : Governorate.fromJson(json['governorate'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CustomerCartToJson(_CustomerCart instance) =>
    <String, dynamic>{
      'id': instance.id,
      'items': instance.items,
      'subtotal': instance.subtotal,
      'items_count': instance.items_count,
      'governorate_id': instance.governorate_id,
      'governorate': instance.governorate,
    };
