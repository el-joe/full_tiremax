// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Payment _$PaymentFromJson(Map<String, dynamic> json) => _Payment(
  id: (json['id'] as num).toInt(),
  order_id: (json['order_id'] as num).toInt(),
  payment_gateway_id: (json['payment_gateway_id'] as num).toInt(),
  amount: json['amount'] as num,
  currency: json['currency'] as String,
  status: json['status'] as String,
  transaction_id: json['transaction_id'] as String?,
  redirect_url: json['redirect_url'] as String?,
  gateway_response: json['gateway_response'] as Map<String, dynamic>?,
  paid_at: json['paid_at'] as String?,
  gateway: PaymentGateway.fromJson(json['gateway'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PaymentToJson(_Payment instance) => <String, dynamic>{
  'id': instance.id,
  'order_id': instance.order_id,
  'payment_gateway_id': instance.payment_gateway_id,
  'amount': instance.amount,
  'currency': instance.currency,
  'status': instance.status,
  'transaction_id': instance.transaction_id,
  'redirect_url': instance.redirect_url,
  'gateway_response': instance.gateway_response,
  'paid_at': instance.paid_at,
  'gateway': instance.gateway,
};

_PaymentGateway _$PaymentGatewayFromJson(Map<String, dynamic> json) =>
    _PaymentGateway(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      display_name: json['display_name'] as String,
      driver: json['driver'] as String,
    );

Map<String, dynamic> _$PaymentGatewayToJson(_PaymentGateway instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'display_name': instance.display_name,
      'driver': instance.driver,
    };
