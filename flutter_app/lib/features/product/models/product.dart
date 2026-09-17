import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/brand.dart';
import '../../../core/models/category.dart';
import 'battery_spec.dart';
import 'flash_sale_info.dart';
import 'product_image.dart';
import 'tire_spec.dart';

part 'product.freezed.dart';
part 'product.g.dart';

/// Mirrors `frontend/types/product.type.ts` (`IProduct`).
@freezed
abstract class Product with _$Product {
  const factory Product({
    required int id,
    required String sku,
    required String type,
    required String name,
    required String short_description,
    String? description,
    required String pattern_name,
    String? usage_notes,
    required num price,
    num? sale_price,
    required num effective_price,
    required bool has_discount,
    required bool is_flash_sale,
    FlashSaleInfo? flash_sale,
    required int stock,
    required bool in_stock,
    required int manufacture_year,
    required int manufacturer_warranty_months,
    required int agency_warranty_months,
    num? expert_rating,
    required int sales_count,
    required int views_count,
    required bool is_featured,
    @Default(<String>[]) List<String> badges,
    @Default(<ProductImage>[]) List<ProductImage> images,
    String? primary_image,
    required Brand brand,
    required Category category,
    TireSpec? tire_spec,
    BatterySpec? battery_spec,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
