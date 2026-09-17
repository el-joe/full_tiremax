import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle.freezed.dart';
part 'vehicle.g.dart';

/// Mirrors `frontend/types/vehicle.type.ts` (`IVehicle`) — a specific
/// trim/year variant of a vehicle model.
@freezed
abstract class Vehicle with _$Vehicle {
  const factory Vehicle({
    required int id,
    required int vehicle_model_id,
    required int year_from,
    required int year_to,
    String? trim_code,
    String? trim_name,
    String? engine,
    String? notes,
    required VehicleModelSummary model,
  }) = _Vehicle;

  factory Vehicle.fromJson(Map<String, dynamic> json) =>
      _$VehicleFromJson(json);
}

/// Mirrors `Model` nested in `vehicle.type.ts`.
@freezed
abstract class VehicleModelSummary with _$VehicleModelSummary {
  const factory VehicleModelSummary({
    required int id,
    required String slug,
    required String name,
    required int vehicle_make_id,
  }) = _VehicleModelSummary;

  factory VehicleModelSummary.fromJson(Map<String, dynamic> json) =>
      _$VehicleModelSummaryFromJson(json);
}
