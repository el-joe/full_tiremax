import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment.freezed.dart';
part 'payment.g.dart';

/// Mirrors `frontend/types/payment.type.ts` (`IPayment`).
@freezed
abstract class Payment with _$Payment {
  const factory Payment({
    required int id,
    required int order_id,
    required int payment_gateway_id,
    required num amount,
    required String currency,
    required String status,
    String? transaction_id,
    String? redirect_url,
    Map<String, dynamic>? gateway_response,
    String? paid_at,
    required PaymentGateway gateway,
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);
}

/// Mirrors the inline `gateway` object in `payment.type.ts`.
@freezed
abstract class PaymentGateway with _$PaymentGateway {
  const factory PaymentGateway({
    required int id,
    required String name,
    required String display_name,
    required String driver,
  }) = _PaymentGateway;

  factory PaymentGateway.fromJson(Map<String, dynamic> json) =>
      _$PaymentGatewayFromJson(json);
}
