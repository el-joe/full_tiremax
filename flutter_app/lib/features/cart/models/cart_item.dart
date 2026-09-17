import 'package:freezed_annotation/freezed_annotation.dart';

import 'cart_product.dart';

part 'cart_item.freezed.dart';
part 'cart_item.g.dart';

/// Mirrors `frontend/types/customerCart.type.ts` (`ICartItem`).
@freezed
abstract class CartItem with _$CartItem {
  const factory CartItem({
    required int id,
    required int product_id,
    required CartProduct product,
    required int quantity,
    required num unit_price,
    required num total,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
}
