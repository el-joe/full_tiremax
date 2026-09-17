import 'package:freezed_annotation/freezed_annotation.dart';

part 'year_vehicle_model.freezed.dart';
part 'year_vehicle_model.g.dart';

/// Mirrors `frontend/types/yearVehicleModel.type.ts` (`IYearVehicleModel`).
@freezed
abstract class YearVehicleModel with _$YearVehicleModel {
  const factory YearVehicleModel({
    required int id,
    required int vehicle_model_id,
    required int year_from,
    required int year_to,
    String? trim_code,
    String? trim_name,
    String? engine,
    String? notes,
  }) = _YearVehicleModel;

  factory YearVehicleModel.fromJson(Map<String, dynamic> json) =>
      _$YearVehicleModelFromJson(json);
}
