import 'package:freezed_annotation/freezed_annotation.dart';

part 'tire_spec.freezed.dart';
part 'tire_spec.g.dart';

/// Mirrors `frontend/types/product.type.ts` (`TireSpec`).
@freezed
abstract class TireSpec with _$TireSpec {
  const factory TireSpec({
    required num width,
    required num aspect_ratio,
    required num rim_diameter,
    required String load_index,
    required String speed_rating,
    required String usage_type,
    required bool runflat,
    required String size_string,
  }) = _TireSpec;

  factory TireSpec.fromJson(Map<String, dynamic> json) =>
      _$TireSpecFromJson(json);
}
