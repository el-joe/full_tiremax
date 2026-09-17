import 'package:freezed_annotation/freezed_annotation.dart';

part 'flash_sale.freezed.dart';
part 'flash_sale.g.dart';

/// Mirrors the `GET /flash-sales` list item shape from the Postman
/// collection: `{ id, title, discount_percent, starts_at, ends_at, is_active }`.
@freezed
abstract class FlashSale with _$FlashSale {
  const factory FlashSale({
    required int id,
    required String title,
    required num discount_percent,
    String? starts_at,
    String? ends_at,
    @Default(true) bool is_active,
  }) = _FlashSale;

  factory FlashSale.fromJson(Map<String, dynamic> json) =>
      _$FlashSaleFromJson(json);
}
