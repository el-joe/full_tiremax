// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'year_vehicle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_YearVehicleModel _$YearVehicleModelFromJson(Map<String, dynamic> json) =>
    _YearVehicleModel(
      id: (json['id'] as num).toInt(),
      vehicle_model_id: (json['vehicle_model_id'] as num).toInt(),
      year_from: (json['year_from'] as num).toInt(),
      year_to: (json['year_to'] as num).toInt(),
      trim_code: json['trim_code'] as String?,
      trim_name: json['trim_name'] as String?,
      engine: json['engine'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$YearVehicleModelToJson(_YearVehicleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vehicle_model_id': instance.vehicle_model_id,
      'year_from': instance.year_from,
      'year_to': instance.year_to,
      'trim_code': instance.trim_code,
      'trim_name': instance.trim_name,
      'engine': instance.engine,
      'notes': instance.notes,
    };
