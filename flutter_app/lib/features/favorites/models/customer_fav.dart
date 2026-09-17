import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_fav.freezed.dart';
part 'customer_fav.g.dart';

/// Mirrors `frontend/types/customerFav.type.ts` (`ICustomerFav`).
@freezed
abstract class CustomerFav with _$CustomerFav {
  const factory CustomerFav({
    required int id,
    required String sku,
    required String name,
    required num price,
    num? sale_price,
    num? effective_price,
    required bool has_discount,
    required bool in_stock,
    required bool is_featured,
    @Default(<String>[]) List<String> badges,
    String? primary_image,
    required CustomerFavBrand brand,
  }) = _CustomerFav;

  factory CustomerFav.fromJson(Map<String, dynamic> json) =>
      _$CustomerFavFromJson(json);
}

/// Mirrors `Brand` nested in `customerFav.type.ts` (narrower than the
/// shared `core/models/brand.dart` `Brand`).
@freezed
abstract class CustomerFavBrand with _$CustomerFavBrand {
  const factory CustomerFavBrand({
    required int id,
    required String slug,
    required String name,
  }) = _CustomerFavBrand;

  factory CustomerFavBrand.fromJson(Map<String, dynamic> json) =>
      _$CustomerFavBrandFromJson(json);
}
