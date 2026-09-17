// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Brand _$BrandFromJson(Map<String, dynamic> json) => _Brand(
  id: (json['id'] as num).toInt(),
  slug: json['slug'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  logo: json['logo'] as String?,
  country: json['country'] as String,
  is_active: json['is_active'] as bool,
);

Map<String, dynamic> _$BrandToJson(_Brand instance) => <String, dynamic>{
  'id': instance.id,
  'slug': instance.slug,
  'name': instance.name,
  'description': instance.description,
  'logo': instance.logo,
  'country': instance.country,
  'is_active': instance.is_active,
};
