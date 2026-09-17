import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle_model.freezed.dart';
part 'vehicle_model.g.dart';

/// Mirrors `frontend/types/vehicleModel.type.ts` (`IVehicleModel`).
@freezed
abstract class VehicleModel with _$VehicleModel {
  const factory VehicleModel({
    required int id,
    required String slug,
    required String name,
    required int vehicle_make_id,
  }) = _VehicleModel;

  factory VehicleModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleModelFromJson(json);
}
