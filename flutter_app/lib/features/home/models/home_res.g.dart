// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HomeRes _$HomeResFromJson(Map<String, dynamic> json) => _HomeRes(
  featured:
      (json['featured'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Product>[],
  best_sellers:
      (json['best_sellers'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Product>[],
  new_arrivals:
      (json['new_arrivals'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Product>[],
  offers:
      (json['offers'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Product>[],
  brands:
      (json['brands'] as List<dynamic>?)
          ?.map((e) => Brand.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Brand>[],
  governorates:
      (json['governorates'] as List<dynamic>?)
          ?.map((e) => Governorate.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Governorate>[],
);

Map<String, dynamic> _$HomeResToJson(_HomeRes instance) => <String, dynamic>{
  'featured': instance.featured,
  'best_sellers': instance.best_sellers,
  'new_arrivals': instance.new_arrivals,
  'offers': instance.offers,
  'brands': instance.brands,
  'governorates': instance.governorates,
};
