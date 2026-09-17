import 'package:freezed_annotation/freezed_annotation.dart';

part 'flash_sale_info.freezed.dart';
part 'flash_sale_info.g.dart';

/// Mirrors the inline `flash_sale` object type in
/// `frontend/types/product.type.ts` (`IProduct.flash_sale`).
@freezed
abstract class FlashSaleInfo with _$FlashSaleInfo {
  const factory FlashSaleInfo({
    required int id,
    required String title,
    required num discount_percent,
    required String ends_at,
    required int countdown_seconds,
  }) = _FlashSaleInfo;

  factory FlashSaleInfo.fromJson(Map<String, dynamic> json) =>
      _$FlashSaleInfoFromJson(json);
}
