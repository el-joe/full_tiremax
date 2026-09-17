import 'package:freezed_annotation/freezed_annotation.dart';

part 'brand.freezed.dart';
part 'brand.g.dart';

/// Mirrors `frontend/types/brand.type.ts` (`IBrand`).
@freezed
abstract class Brand with _$Brand {
  const factory Brand({
    required int id,
    required String slug,
    required String name,
    String? description,
    String? logo,
    required String country,
    required bool is_active,
  }) = _Brand;

  factory Brand.fromJson(Map<String, dynamic> json) => _$BrandFromJson(json);
}
