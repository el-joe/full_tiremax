// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tire_spec.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TireSpec _$TireSpecFromJson(Map<String, dynamic> json) => _TireSpec(
  width: json['width'] as num,
  aspect_ratio: json['aspect_ratio'] as num,
  rim_diameter: json['rim_diameter'] as num,
  load_index: json['load_index'] as String,
  speed_rating: json['speed_rating'] as String,
  usage_type: json['usage_type'] as String,
  runflat: json['runflat'] as bool,
  size_string: json['size_string'] as String,
);

Map<String, dynamic> _$TireSpecToJson(_TireSpec instance) => <String, dynamic>{
  'width': instance.width,
  'aspect_ratio': instance.aspect_ratio,
  'rim_diameter': instance.rim_diameter,
  'load_index': instance.load_index,
  'speed_rating': instance.speed_rating,
  'usage_type': instance.usage_type,
  'runflat': instance.runflat,
  'size_string': instance.size_string,
};
