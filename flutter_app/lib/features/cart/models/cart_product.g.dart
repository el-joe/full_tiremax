// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CartProduct _$CartProductFromJson(Map<String, dynamic> json) => _CartProduct(
  id: (json['id'] as num).toInt(),
  sku: json['sku'] as String,
  type: json['type'] as String,
  name: json['name'] as String,
  short_description: json['short_description'] as String,
  description: json['description'] as String?,
  pattern_name: json['pattern_name'] as String?,
  usage_notes: json['usage_notes'] as String?,
  price: json['price'] as num,
  sale_price: json['sale_price'] as num?,
  effective_price: json['effective_price'] as num,
  has_discount: json['has_discount'] as bool,
  is_flash_sale: json['is_flash_sale'] as bool,
  flash_sale: json['flash_sale'] as num?,
  stock: (json['stock'] as num).toInt(),
  in_stock: json['in_stock'] as bool,
  manufacture_year: (json['manufacture_year'] as num).toInt(),
  manufacturer_warranty_months: (json['manufacturer_warranty_months'] as num)
      .toInt(),
  agency_warranty_months: (json['agency_warranty_months'] as num).toInt(),
  expert_rating: json['expert_rating'] as num?,
  sales_count: (json['sales_count'] as num).toInt(),
  views_count: (json['views_count'] as num).toInt(),
  is_featured: json['is_featured'] as bool,
  images:
      (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  primary_image: json['primary_image'] as String?,
  brand: Brand.fromJson(json['brand'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CartProductToJson(_CartProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sku': instance.sku,
      'type': instance.type,
      'name': instance.name,
      'short_description': instance.short_description,
      'description': instance.description,
      'pattern_name': instance.pattern_name,
      'usage_notes': instance.usage_notes,
      'price': instance.price,
      'sale_price': instance.sale_price,
      'effective_price': instance.effective_price,
      'has_discount': instance.has_discount,
      'is_flash_sale': instance.is_flash_sale,
      'flash_sale': instance.flash_sale,
      'stock': instance.stock,
      'in_stock': instance.in_stock,
      'manufacture_year': instance.manufacture_year,
      'manufacturer_warranty_months': instance.manufacturer_warranty_months,
      'agency_warranty_months': instance.agency_warranty_months,
      'expert_rating': instance.expert_rating,
      'sales_count': instance.sales_count,
      'views_count': instance.views_count,
      'is_featured': instance.is_featured,
      'images': instance.images,
      'primary_image': instance.primary_image,
      'brand': instance.brand,
    };
