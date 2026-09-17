import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/governorate.dart';
import 'cart_item.dart';

part 'customer_cart.freezed.dart';
part 'customer_cart.g.dart';

/// Mirrors `frontend/types/customerCart.type.ts` (`ICustomerCart`).
@freezed
abstract class CustomerCart with _$CustomerCart {
  const factory CustomerCart({
    required int id,
    @Default(<CartItem>[]) List<CartItem> items,
    required num subtotal,
    required int items_count,
    int? governorate_id,
    Governorate? governorate,
  }) = _CustomerCart;

  factory CustomerCart.fromJson(Map<String, dynamic> json) =>
      _$CustomerCartFromJson(json);
}
