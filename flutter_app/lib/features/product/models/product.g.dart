// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: (json['id'] as num).toInt(),
  sku: json['sku'] as String,
  type: json['type'] as String,
  name: json['name'] as String,
  short_description: json['short_description'] as String,
  description: json['description'] as String?,
  pattern_name: json['pattern_name'] as String,
  usage_notes: json['usage_notes'] as String?,
  price: json['price'] as num,
  sale_price: json['sale_price'] as num?,
  effective_price: json['effective_price'] as num,
  has_discount: json['has_discount'] as bool,
  is_flash_sale: json['is_flash_sale'] as bool,
  flash_sale: json['flash_sale'] == null
      ? null
      : FlashSaleInfo.fromJson(json['flash_sale'] as Map<String, dynamic>),
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
  badges:
      (json['badges'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  images:
      (json['images'] as List<dynamic>?)
          ?.map((e) => ProductImage.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ProductImage>[],
  primary_image: json['primary_image'] as String?,
  brand: Brand.fromJson(json['brand'] as Map<String, dynamic>),
  category: Category.fromJson(json['category'] as Map<String, dynamic>),
  tire_spec: json['tire_spec'] == null
      ? null
      : TireSpec.fromJson(json['tire_spec'] as Map<String, dynamic>),
  battery_spec: json['battery_spec'] == null
      ? null
      : BatterySpec.fromJson(json['battery_spec'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
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
  'badges': instance.badges,
  'images': instance.images,
  'primary_image': instance.primary_image,
  'brand': instance.brand,
  'category': instance.category,
  'tire_spec': instance.tire_spec,
  'battery_spec': instance.battery_spec,
};
