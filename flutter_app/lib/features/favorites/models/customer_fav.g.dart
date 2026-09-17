// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_fav.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomerFav _$CustomerFavFromJson(Map<String, dynamic> json) => _CustomerFav(
  id: (json['id'] as num).toInt(),
  sku: json['sku'] as String,
  name: json['name'] as String,
  price: json['price'] as num,
  sale_price: json['sale_price'] as num?,
  effective_price: json['effective_price'] as num?,
  has_discount: json['has_discount'] as bool,
  in_stock: json['in_stock'] as bool,
  is_featured: json['is_featured'] as bool,
  badges:
      (json['badges'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  primary_image: json['primary_image'] as String?,
  brand: CustomerFavBrand.fromJson(json['brand'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CustomerFavToJson(_CustomerFav instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sku': instance.sku,
      'name': instance.name,
      'price': instance.price,
      'sale_price': instance.sale_price,
      'effective_price': instance.effective_price,
      'has_discount': instance.has_discount,
      'in_stock': instance.in_stock,
      'is_featured': instance.is_featured,
      'badges': instance.badges,
      'primary_image': instance.primary_image,
      'brand': instance.brand,
    };

_CustomerFavBrand _$CustomerFavBrandFromJson(Map<String, dynamic> json) =>
    _CustomerFavBrand(
      id: (json['id'] as num).toInt(),
      slug: json['slug'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$CustomerFavBrandToJson(_CustomerFavBrand instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
    };
