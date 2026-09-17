import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/brand.dart';

part 'cart_product.freezed.dart';
part 'cart_product.g.dart';

/// Mirrors `frontend/types/customerCart.type.ts` (`ICartProduct`).
///
/// Note: this endpoint returns its own local `Brand` shape (no
/// `description`/`logo` nullability difference from the shared brand type),
/// so it reuses `core/models/brand.dart`.
@freezed
abstract class CartProduct with _$CartProduct {
  const factory CartProduct({
    required int id,
    required String sku,
    required String type,
    required String name,
    required String short_description,
    String? description,
    String? pattern_name,
    String? usage_notes,
    required num price,
    num? sale_price,
    required num effective_price,
    required bool has_discount,
    required bool is_flash_sale,
    num? flash_sale,
    required int stock,
    required bool in_stock,
    required int manufacture_year,
    required int manufacturer_warranty_months,
    required int agency_warranty_months,
    num? expert_rating,
    required int sales_count,
    required int views_count,
    required bool is_featured,
    @Default(<String>[]) List<String> images,
    String? primary_image,
    required Brand brand,
  }) = _CartProduct;

  factory CartProduct.fromJson(Map<String, dynamic> json) =>
      _$CartProductFromJson(json);
}
