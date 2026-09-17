import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_image.freezed.dart';
part 'product_image.g.dart';

/// Mirrors the inline `images` entry type in `frontend/types/product.type.ts`:
/// `{ url: string; is_primary: boolean }`.
@freezed
abstract class ProductImage with _$ProductImage {
  const factory ProductImage({
    required String url,
    required bool is_primary,
  }) = _ProductImage;

  factory ProductImage.fromJson(Map<String, dynamic> json) =>
      _$ProductImageFromJson(json);
}
