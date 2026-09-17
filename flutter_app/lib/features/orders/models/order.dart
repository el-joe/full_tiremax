import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/branch.dart';
import '../../../core/models/governorate.dart';

part 'order.freezed.dart';
part 'order.g.dart';

/// Mirrors `frontend/types/order.type.ts` (`IOrder`).
@freezed
abstract class Order with _$Order {
  const factory Order({
    required int id,
    required String reference,
    required String type, // "delivery" | "basra"
    required String status,
    required String payment_method,
    required String payment_status,
    required num subtotal,
    required num discount,
    required num shipping_fee,
    required num installation_fee,
    required num total,
    required String customer_name,
    required String customer_phone,
    required String customer_email,
    required String shipping_address,
    required String tracking_number,
    required String placed_at,
    Governorate? governorate,
    Branch? branch,
    @Default(<OrderItem>[]) List<OrderItem> items,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

/// Mirrors `Item` nested in `order.type.ts`.
@freezed
abstract class OrderItem with _$OrderItem {
  const factory OrderItem({
    required int id,
    required int product_id,
    required String product_name,
    required String product_sku,
    required int quantity,
    required num unit_price,
    required num total,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
}
