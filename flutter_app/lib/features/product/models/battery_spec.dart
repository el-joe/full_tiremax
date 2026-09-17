import 'package:freezed_annotation/freezed_annotation.dart';

part 'battery_spec.freezed.dart';
part 'battery_spec.g.dart';

/// Mirrors `frontend/types/product.type.ts` (`IBatterySpec`).
@freezed
abstract class BatterySpec with _$BatterySpec {
  const factory BatterySpec({
    required num voltage,
    required num ampere_hour,
    required num cca,
    required String battery_type,
    required String terminal_position,
    required String size_code,
  }) = _BatterySpec;

  factory BatterySpec.fromJson(Map<String, dynamic> json) =>
      _$BatterySpecFromJson(json);
}
