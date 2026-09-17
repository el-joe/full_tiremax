// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Order _$OrderFromJson(Map<String, dynamic> json) => _Order(
  id: (json['id'] as num).toInt(),
  reference: json['reference'] as String,
  type: json['type'] as String,
  status: json['status'] as String,
  payment_method: json['payment_method'] as String,
  payment_status: json['payment_status'] as String,
  subtotal: json['subtotal'] as num,
  discount: json['discount'] as num,
  shipping_fee: json['shipping_fee'] as num,
  installation_fee: json['installation_fee'] as num,
  total: json['total'] as num,
  customer_name: json['customer_name'] as String,
  customer_phone: json['customer_phone'] as String,
  customer_email: json['customer_email'] as String,
  shipping_address: json['shipping_address'] as String,
  tracking_number: json['tracking_number'] as String,
  placed_at: json['placed_at'] as String,
  governorate: json['governorate'] == null
      ? null
      : Governorate.fromJson(json['governorate'] as Map<String, dynamic>),
  branch: json['branch'] == null
      ? null
      : Branch.fromJson(json['branch'] as Map<String, dynamic>),
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <OrderItem>[],
);

Map<String, dynamic> _$OrderToJson(_Order instance) => <String, dynamic>{
  'id': instance.id,
  'reference': instance.reference,
  'type': instance.type,
  'status': instance.status,
  'payment_method': instance.payment_method,
  'payment_status': instance.payment_status,
  'subtotal': instance.subtotal,
  'discount': instance.discount,
  'shipping_fee': instance.shipping_fee,
  'installation_fee': instance.installation_fee,
  'total': instance.total,
  'customer_name': instance.customer_name,
  'customer_phone': instance.customer_phone,
  'customer_email': instance.customer_email,
  'shipping_address': instance.shipping_address,
  'tracking_number': instance.tracking_number,
  'placed_at': instance.placed_at,
  'governorate': instance.governorate,
  'branch': instance.branch,
  'items': instance.items,
};

_OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => _OrderItem(
  id: (json['id'] as num).toInt(),
  product_id: (json['product_id'] as num).toInt(),
  product_name: json['product_name'] as String,
  product_sku: json['product_sku'] as String,
  quantity: (json['quantity'] as num).toInt(),
  unit_price: json['unit_price'] as num,
  total: json['total'] as num,
);

Map<String, dynamic> _$OrderItemToJson(_OrderItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.product_id,
      'product_name': instance.product_name,
      'product_sku': instance.product_sku,
      'quantity': instance.quantity,
      'unit_price': instance.unit_price,
      'total': instance.total,
    };
