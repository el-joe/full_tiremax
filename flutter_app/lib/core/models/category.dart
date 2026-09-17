import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

/// Mirrors `frontend/types/product.type.ts` (`ICategory`).
@freezed
abstract class Category with _$Category {
  const factory Category({
    required int id,
    required String slug,
    required String name,
    String? description,
    required String product_type,
    String? icon,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}
