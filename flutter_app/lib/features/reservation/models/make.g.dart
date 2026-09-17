// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'make.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Make _$MakeFromJson(Map<String, dynamic> json) => _Make(
  id: (json['id'] as num).toInt(),
  slug: json['slug'] as String,
  name: json['name'] as String,
  logo: json['logo'] as String?,
);

Map<String, dynamic> _$MakeToJson(_Make instance) => <String, dynamic>{
  'id': instance.id,
  'slug': instance.slug,
  'name': instance.name,
  'logo': instance.logo,
};
