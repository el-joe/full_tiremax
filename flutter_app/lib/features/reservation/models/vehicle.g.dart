// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Vehicle _$VehicleFromJson(Map<String, dynamic> json) => _Vehicle(
  id: (json['id'] as num).toInt(),
  vehicle_model_id: (json['vehicle_model_id'] as num).toInt(),
  year_from: (json['year_from'] as num).toInt(),
  year_to: (json['year_to'] as num).toInt(),
  trim_code: json['trim_code'] as String?,
  trim_name: json['trim_name'] as String?,
  engine: json['engine'] as String?,
  notes: json['notes'] as String?,
  model: VehicleModelSummary.fromJson(json['model'] as Map<String, dynamic>),
);

Map<String, dynamic> _$VehicleToJson(_Vehicle instance) => <String, dynamic>{
  'id': instance.id,
  'vehicle_model_id': instance.vehicle_model_id,
  'year_from': instance.year_from,
  'year_to': instance.year_to,
  'trim_code': instance.trim_code,
  'trim_name': instance.trim_name,
  'engine': instance.engine,
  'notes': instance.notes,
  'model': instance.model,
};

_VehicleModelSummary _$VehicleModelSummaryFromJson(Map<String, dynamic> json) =>
    _VehicleModelSummary(
      id: (json['id'] as num).toInt(),
      slug: json['slug'] as String,
      name: json['name'] as String,
      vehicle_make_id: (json['vehicle_make_id'] as num).toInt(),
    );

Map<String, dynamic> _$VehicleModelSummaryToJson(
  _VehicleModelSummary instance,
) => <String, dynamic>{
  'id': instance.id,
  'slug': instance.slug,
  'name': instance.name,
  'vehicle_make_id': instance.vehicle_make_id,
};
