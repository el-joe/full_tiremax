// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CartItem _$CartItemFromJson(Map<String, dynamic> json) => _CartItem(
  id: (json['id'] as num).toInt(),
  product_id: (json['product_id'] as num).toInt(),
  product: CartProduct.fromJson(json['product'] as Map<String, dynamic>),
  quantity: (json['quantity'] as num).toInt(),
  unit_price: json['unit_price'] as num,
  total: json['total'] as num,
);

Map<String, dynamic> _$CartItemToJson(_CartItem instance) => <String, dynamic>{
  'id': instance.id,
  'product_id': instance.product_id,
  'product': instance.product,
  'quantity': instance.quantity,
  'unit_price': instance.unit_price,
  'total': instance.total,
};
