// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Product {

 int get id; String get sku; String get type; String get name; String get short_description; String? get description; String get pattern_name; String? get usage_notes; num get price; num? get sale_price; num get effective_price; bool get has_discount; bool get is_flash_sale; FlashSaleInfo? get flash_sale; int get stock; bool get in_stock; int get manufacture_year; int get manufacturer_warranty_months; int get agency_warranty_months; num? get expert_rating; int get sales_count; int get views_count; bool get is_featured; List<String> get badges; List<ProductImage> get images; String? get primary_image; Brand get brand; Category get category; TireSpec? get tire_spec; BatterySpec? get battery_spec;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Product;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.sku, _this.sku) || other.sku == _this.sku)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.short_description, _this.short_description) || other.short_description == _this.short_description)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.pattern_name, _this.pattern_name) || other.pattern_name == _this.pattern_name)&&(identical(other.usage_notes, _this.usage_notes) || other.usage_notes == _this.usage_notes)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.sale_price, _this.sale_price) || other.sale_price == _this.sale_price)&&(identical(other.effective_price, _this.effective_price) || other.effective_price == _this.effective_price)&&(identical(other.has_discount, _this.has_discount) || other.has_discount == _this.has_discount)&&(identical(other.is_flash_sale, _this.is_flash_sale) || other.is_flash_sale == _this.is_flash_sale)&&(identical(other.flash_sale, _this.flash_sale) || other.flash_sale == _this.flash_sale)&&(identical(other.stock, _this.stock) || other.stock == _this.stock)&&(identical(other.in_stock, _this.in_stock) || other.in_stock == _this.in_stock)&&(identical(other.manufacture_year, _this.manufacture_year) || other.manufacture_year == _this.manufacture_year)&&(identical(other.manufacturer_warranty_months, _this.manufacturer_warranty_months) || other.manufacturer_warranty_months == _this.manufacturer_warranty_months)&&(identical(other.agency_warranty_months, _this.agency_warranty_months) || other.agency_warranty_months == _this.agency_warranty_months)&&(identical(other.expert_rating, _this.expert_rating) || other.expert_rating == _this.expert_rating)&&(identical(other.sales_count, _this.sales_count) || other.sales_count == _this.sales_count)&&(identical(other.views_count, _this.views_count) || other.views_count == _this.views_count)&&(identical(other.is_featured, _this.is_featured) || other.is_featured == _this.is_featured)&&const DeepCollectionEquality().equals(other.badges, _this.badges)&&const DeepCollectionEquality().equals(other.images, _this.images)&&(identical(other.primary_image, _this.primary_image) || other.primary_image == _this.primary_image)&&(identical(other.brand, _this.brand) || other.brand == _this.brand)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.tire_spec, _this.tire_spec) || other.tire_spec == _this.tire_spec)&&(identical(other.battery_spec, _this.battery_spec) || other.battery_spec == _this.battery_spec));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Product;
  return Object.hashAll([runtimeType,_this.id,_this.sku,_this.type,_this.name,_this.short_description,_this.description,_this.pattern_name,_this.usage_notes,_this.price,_this.sale_price,_this.effective_price,_this.has_discount,_this.is_flash_sale,_this.flash_sale,_this.stock,_this.in_stock,_this.manufacture_year,_this.manufacturer_warranty_months,_this.agency_warranty_months,_this.expert_rating,_this.sales_count,_this.views_count,_this.is_featured,const DeepCollectionEquality().hash(_this.badges),const DeepCollectionEquality().hash(_this.images),_this.primary_image,_this.brand,_this.category,_this.tire_spec,_this.battery_spec]);
}

@override
String toString() {
  final _this = this as Product;
  return 'Product(id: ${_this.id}, sku: ${_this.sku}, type: ${_this.type}, name: ${_this.name}, short_description: ${_this.short_description}, description: ${_this.description}, pattern_name: ${_this.pattern_name}, usage_notes: ${_this.usage_notes}, price: ${_this.price}, sale_price: ${_this.sale_price}, effective_price: ${_this.effective_price}, has_discount: ${_this.has_discount}, is_flash_sale: ${_this.is_flash_sale}, flash_sale: ${_this.flash_sale}, stock: ${_this.stock}, in_stock: ${_this.in_stock}, manufacture_year: ${_this.manufacture_year}, manufacturer_warranty_months: ${_this.manufacturer_warranty_months}, agency_warranty_months: ${_this.agency_warranty_months}, expert_rating: ${_this.expert_rating}, sales_count: ${_this.sales_count}, views_count: ${_this.views_count}, is_featured: ${_this.is_featured}, badges: ${_this.badges}, images: ${_this.images}, primary_image: ${_this.primary_image}, brand: ${_this.brand}, category: ${_this.category}, tire_spec: ${_this.tire_spec}, battery_spec: ${_this.battery_spec})';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 int id, String sku, String type, String name, String short_description, String? description, String pattern_name, String? usage_notes, num price, num? sale_price, num effective_price, bool has_discount, bool is_flash_sale, FlashSaleInfo? flash_sale, int stock, bool in_stock, int manufacture_year, int manufacturer_warranty_months, int agency_warranty_months, num? expert_rating, int sales_count, int views_count, bool is_featured, List<String> badges, List<ProductImage> images, String? primary_image, Brand brand, Category category, TireSpec? tire_spec, BatterySpec? battery_spec
});


$FlashSaleInfoCopyWith<$Res>? get flash_sale;$BrandCopyWith<$Res> get brand;$CategoryCopyWith<$Res> get category;$TireSpecCopyWith<$Res>? get tire_spec;$BatterySpecCopyWith<$Res>? get battery_spec;

}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sku = null,Object? type = null,Object? name = null,Object? short_description = null,Object? description = freezed,Object? pattern_name = null,Object? usage_notes = freezed,Object? price = null,Object? sale_price = freezed,Object? effective_price = null,Object? has_discount = null,Object? is_flash_sale = null,Object? flash_sale = freezed,Object? stock = null,Object? in_stock = null,Object? manufacture_year = null,Object? manufacturer_warranty_months = null,Object? agency_warranty_months = null,Object? expert_rating = freezed,Object? sales_count = null,Object? views_count = null,Object? is_featured = null,Object? badges = null,Object? images = null,Object? primary_image = freezed,Object? brand = null,Object? category = null,Object? tire_spec = freezed,Object? battery_spec = freezed,}) {
  return _then(Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,short_description: null == short_description ? _self.short_description : short_description // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,pattern_name: null == pattern_name ? _self.pattern_name : pattern_name // ignore: cast_nullable_to_non_nullable
as String,usage_notes: freezed == usage_notes ? _self.usage_notes : usage_notes // ignore: cast_nullable_to_non_nullable
as String?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as num,sale_price: freezed == sale_price ? _self.sale_price : sale_price // ignore: cast_nullable_to_non_nullable
as num?,effective_price: null == effective_price ? _self.effective_price : effective_price // ignore: cast_nullable_to_non_nullable
as num,has_discount: null == has_discount ? _self.has_discount : has_discount // ignore: cast_nullable_to_non_nullable
as bool,is_flash_sale: null == is_flash_sale ? _self.is_flash_sale : is_flash_sale // ignore: cast_nullable_to_non_nullable
as bool,flash_sale: freezed == flash_sale ? _self.flash_sale : flash_sale // ignore: cast_nullable_to_non_nullable
as FlashSaleInfo?,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,in_stock: null == in_stock ? _self.in_stock : in_stock // ignore: cast_nullable_to_non_nullable
as bool,manufacture_year: null == manufacture_year ? _self.manufacture_year : manufacture_year // ignore: cast_nullable_to_non_nullable
as int,manufacturer_warranty_months: null == manufacturer_warranty_months ? _self.manufacturer_warranty_months : manufacturer_warranty_months // ignore: cast_nullable_to_non_nullable
as int,agency_warranty_months: null == agency_warranty_months ? _self.agency_warranty_months : agency_warranty_months // ignore: cast_nullable_to_non_nullable
as int,expert_rating: freezed == expert_rating ? _self.expert_rating : expert_rating // ignore: cast_nullable_to_non_nullable
as num?,sales_count: null == sales_count ? _self.sales_count : sales_count // ignore: cast_nullable_to_non_nullable
as int,views_count: null == views_count ? _self.views_count : views_count // ignore: cast_nullable_to_non_nullable
as int,is_featured: null == is_featured ? _self.is_featured : is_featured // ignore: cast_nullable_to_non_nullable
as bool,badges: null == badges ? _self.badges : badges // ignore: cast_nullable_to_non_nullable
as List<String>,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<ProductImage>,primary_image: freezed == primary_image ? _self.primary_image : primary_image // ignore: cast_nullable_to_non_nullable
as String?,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as Brand,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category,tire_spec: freezed == tire_spec ? _self.tire_spec : tire_spec // ignore: cast_nullable_to_non_nullable
as TireSpec?,battery_spec: freezed == battery_spec ? _self.battery_spec : battery_spec // ignore: cast_nullable_to_non_nullable
as BatterySpec?,
  ));
}
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FlashSaleInfoCopyWith<$Res>? get flash_sale {
    if (_self.flash_sale == null) {
    return null;
  }

  return $FlashSaleInfoCopyWith<$Res>(_self.flash_sale!, (value) {
    return _then(_self.copyWith(flash_sale: value));
  });
}/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BrandCopyWith<$Res> get brand {
  
  return $BrandCopyWith<$Res>(_self.brand, (value) {
    return _then(_self.copyWith(brand: value));
  });
}/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res> get category {
  
  return $CategoryCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TireSpecCopyWith<$Res>? get tire_spec {
    if (_self.tire_spec == null) {
    return null;
  }

  return $TireSpecCopyWith<$Res>(_self.tire_spec!, (value) {
    return _then(_self.copyWith(tire_spec: value));
  });
}/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BatterySpecCopyWith<$Res>? get battery_spec {
    if (_self.battery_spec == null) {
    return null;
  }

  return $BatterySpecCopyWith<$Res>(_self.battery_spec!, (value) {
    return _then(_self.copyWith(battery_spec: value));
  });
}
}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String sku,  String type,  String name,  String short_description,  String? description,  String pattern_name,  String? usage_notes,  num price,  num? sale_price,  num effective_price,  bool has_discount,  bool is_flash_sale,  FlashSaleInfo? flash_sale,  int stock,  bool in_stock,  int manufacture_year,  int manufacturer_warranty_months,  int agency_warranty_months,  num? expert_rating,  int sales_count,  int views_count,  bool is_featured,  List<String> badges,  List<ProductImage> images,  String? primary_image,  Brand brand,  Category category,  TireSpec? tire_spec,  BatterySpec? battery_spec)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.sku,_that.type,_that.name,_that.short_description,_that.description,_that.pattern_name,_that.usage_notes,_that.price,_that.sale_price,_that.effective_price,_that.has_discount,_that.is_flash_sale,_that.flash_sale,_that.stock,_that.in_stock,_that.manufacture_year,_that.manufacturer_warranty_months,_that.agency_warranty_months,_that.expert_rating,_that.sales_count,_that.views_count,_that.is_featured,_that.badges,_that.images,_that.primary_image,_that.brand,_that.category,_that.tire_spec,_that.battery_spec);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String sku,  String type,  String name,  String short_description,  String? description,  String pattern_name,  String? usage_notes,  num price,  num? sale_price,  num effective_price,  bool has_discount,  bool is_flash_sale,  FlashSaleInfo? flash_sale,  int stock,  bool in_stock,  int manufacture_year,  int manufacturer_warranty_months,  int agency_warranty_months,  num? expert_rating,  int sales_count,  int views_count,  bool is_featured,  List<String> badges,  List<ProductImage> images,  String? primary_image,  Brand brand,  Category category,  TireSpec? tire_spec,  BatterySpec? battery_spec)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.sku,_that.type,_that.name,_that.short_description,_that.description,_that.pattern_name,_that.usage_notes,_that.price,_that.sale_price,_that.effective_price,_that.has_discount,_that.is_flash_sale,_that.flash_sale,_that.stock,_that.in_stock,_that.manufacture_year,_that.manufacturer_warranty_months,_that.agency_warranty_months,_that.expert_rating,_that.sales_count,_that.views_count,_that.is_featured,_that.badges,_that.images,_that.primary_image,_that.brand,_that.category,_that.tire_spec,_that.battery_spec);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String sku,  String type,  String name,  String short_description,  String? description,  String pattern_name,  String? usage_notes,  num price,  num? sale_price,  num effective_price,  bool has_discount,  bool is_flash_sale,  FlashSaleInfo? flash_sale,  int stock,  bool in_stock,  int manufacture_year,  int manufacturer_warranty_months,  int agency_warranty_months,  num? expert_rating,  int sales_count,  int views_count,  bool is_featured,  List<String> badges,  List<ProductImage> images,  String? primary_image,  Brand brand,  Category category,  TireSpec? tire_spec,  BatterySpec? battery_spec)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.sku,_that.type,_that.name,_that.short_description,_that.description,_that.pattern_name,_that.usage_notes,_that.price,_that.sale_price,_that.effective_price,_that.has_discount,_that.is_flash_sale,_that.flash_sale,_that.stock,_that.in_stock,_that.manufacture_year,_that.manufacturer_warranty_months,_that.agency_warranty_months,_that.expert_rating,_that.sales_count,_that.views_count,_that.is_featured,_that.badges,_that.images,_that.primary_image,_that.brand,_that.category,_that.tire_spec,_that.battery_spec);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Product implements Product {
  const _Product({required this.id, required this.sku, required this.type, required this.name, required this.short_description, this.description, required this.pattern_name, this.usage_notes, required this.price, this.sale_price, required this.effective_price, required this.has_discount, required this.is_flash_sale, this.flash_sale, required this.stock, required this.in_stock, required this.manufacture_year, required this.manufacturer_warranty_months, required this.agency_warranty_months, this.expert_rating, required this.sales_count, required this.views_count, required this.is_featured,  List<String> badges = const <String>[],  List<ProductImage> images = const <ProductImage>[], this.primary_image, required this.brand, required this.category, this.tire_spec, this.battery_spec}): _badges = badges,_images = images;
  factory _Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

@override final  int id;
@override final  String sku;
@override final  String type;
@override final  String name;
@override final  String short_description;
@override final  String? description;
@override final  String pattern_name;
@override final  String? usage_notes;
@override final  num price;
@override final  num? sale_price;
@override final  num effective_price;
@override final  bool has_discount;
@override final  bool is_flash_sale;
@override final  FlashSaleInfo? flash_sale;
@override final  int stock;
@override final  bool in_stock;
@override final  int manufacture_year;
@override final  int manufacturer_warranty_months;
@override final  int agency_warranty_months;
@override final  num? expert_rating;
@override final  int sales_count;
@override final  int views_count;
@override final  bool is_featured;
 final  List<String> _badges;
@override@JsonKey() List<String> get badges {
  if (_badges is EqualUnmodifiableListView) return _badges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_badges);
}

 final  List<ProductImage> _images;
@override@JsonKey() List<ProductImage> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

@override final  String? primary_image;
@override final  Brand brand;
@override final  Category category;
@override final  TireSpec? tire_spec;
@override final  BatterySpec? battery_spec;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.short_description, short_description) || other.short_description == short_description)&&(identical(other.description, description) || other.description == description)&&(identical(other.pattern_name, pattern_name) || other.pattern_name == pattern_name)&&(identical(other.usage_notes, usage_notes) || other.usage_notes == usage_notes)&&(identical(other.price, price) || other.price == price)&&(identical(other.sale_price, sale_price) || other.sale_price == sale_price)&&(identical(other.effective_price, effective_price) || other.effective_price == effective_price)&&(identical(other.has_discount, has_discount) || other.has_discount == has_discount)&&(identical(other.is_flash_sale, is_flash_sale) || other.is_flash_sale == is_flash_sale)&&(identical(other.flash_sale, flash_sale) || other.flash_sale == flash_sale)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.in_stock, in_stock) || other.in_stock == in_stock)&&(identical(other.manufacture_year, manufacture_year) || other.manufacture_year == manufacture_year)&&(identical(other.manufacturer_warranty_months, manufacturer_warranty_months) || other.manufacturer_warranty_months == manufacturer_warranty_months)&&(identical(other.agency_warranty_months, agency_warranty_months) || other.agency_warranty_months == agency_warranty_months)&&(identical(other.expert_rating, expert_rating) || other.expert_rating == expert_rating)&&(identical(other.sales_count, sales_count) || other.sales_count == sales_count)&&(identical(other.views_count, views_count) || other.views_count == views_count)&&(identical(other.is_featured, is_featured) || other.is_featured == is_featured)&&const DeepCollectionEquality().equals(other.badges, _badges)&&const DeepCollectionEquality().equals(other.images, _images)&&(identical(other.primary_image, primary_image) || other.primary_image == primary_image)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.category, category) || other.category == category)&&(identical(other.tire_spec, tire_spec) || other.tire_spec == tire_spec)&&(identical(other.battery_spec, battery_spec) || other.battery_spec == battery_spec));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,sku,type,name,short_description,description,pattern_name,usage_notes,price,sale_price,effective_price,has_discount,is_flash_sale,flash_sale,stock,in_stock,manufacture_year,manufacturer_warranty_months,agency_warranty_months,expert_rating,sales_count,views_count,is_featured,const DeepCollectionEquality().hash(_badges),const DeepCollectionEquality().hash(_images),primary_image,brand,category,tire_spec,battery_spec]);
}

@override
String toString() {
    return 'Product(id: $id, sku: $sku, type: $type, name: $name, short_description: $short_description, description: $description, pattern_name: $pattern_name, usage_notes: $usage_notes, price: $price, sale_price: $sale_price, effective_price: $effective_price, has_discount: $has_discount, is_flash_sale: $is_flash_sale, flash_sale: $flash_sale, stock: $stock, in_stock: $in_stock, manufacture_year: $manufacture_year, manufacturer_warranty_months: $manufacturer_warranty_months, agency_warranty_months: $agency_warranty_months, expert_rating: $expert_rating, sales_count: $sales_count, views_count: $views_count, is_featured: $is_featured, badges: $badges, images: $images, primary_image: $primary_image, brand: $brand, category: $category, tire_spec: $tire_spec, battery_spec: $battery_spec)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 int id, String sku, String type, String name, String short_description, String? description, String pattern_name, String? usage_notes, num price, num? sale_price, num effective_price, bool has_discount, bool is_flash_sale, FlashSaleInfo? flash_sale, int stock, bool in_stock, int manufacture_year, int manufacturer_warranty_months, int agency_warranty_months, num? expert_rating, int sales_count, int views_count, bool is_featured, List<String> badges, List<ProductImage> images, String? primary_image, Brand brand, Category category, TireSpec? tire_spec, BatterySpec? battery_spec
});


@override $FlashSaleInfoCopyWith<$Res>? get flash_sale;@override $BrandCopyWith<$Res> get brand;@override $CategoryCopyWith<$Res> get category;@override $TireSpecCopyWith<$Res>? get tire_spec;@override $BatterySpecCopyWith<$Res>? get battery_spec;

}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sku = null,Object? type = null,Object? name = null,Object? short_description = null,Object? description = freezed,Object? pattern_name = null,Object? usage_notes = freezed,Object? price = null,Object? sale_price = freezed,Object? effective_price = null,Object? has_discount = null,Object? is_flash_sale = null,Object? flash_sale = freezed,Object? stock = null,Object? in_stock = null,Object? manufacture_year = null,Object? manufacturer_warranty_months = null,Object? agency_warranty_months = null,Object? expert_rating = freezed,Object? sales_count = null,Object? views_count = null,Object? is_featured = null,Object? badges = null,Object? images = null,Object? primary_image = freezed,Object? brand = null,Object? category = null,Object? tire_spec = freezed,Object? battery_spec = freezed,}) {
  return _then(_Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,short_description: null == short_description ? _self.short_description : short_description // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,pattern_name: null == pattern_name ? _self.pattern_name : pattern_name // ignore: cast_nullable_to_non_nullable
as String,usage_notes: freezed == usage_notes ? _self.usage_notes : usage_notes // ignore: cast_nullable_to_non_nullable
as String?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as num,sale_price: freezed == sale_price ? _self.sale_price : sale_price // ignore: cast_nullable_to_non_nullable
as num?,effective_price: null == effective_price ? _self.effective_price : effective_price // ignore: cast_nullable_to_non_nullable
as num,has_discount: null == has_discount ? _self.has_discount : has_discount // ignore: cast_nullable_to_non_nullable
as bool,is_flash_sale: null == is_flash_sale ? _self.is_flash_sale : is_flash_sale // ignore: cast_nullable_to_non_nullable
as bool,flash_sale: freezed == flash_sale ? _self.flash_sale : flash_sale // ignore: cast_nullable_to_non_nullable
as FlashSaleInfo?,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,in_stock: null == in_stock ? _self.in_stock : in_stock // ignore: cast_nullable_to_non_nullable
as bool,manufacture_year: null == manufacture_year ? _self.manufacture_year : manufacture_year // ignore: cast_nullable_to_non_nullable
as int,manufacturer_warranty_months: null == manufacturer_warranty_months ? _self.manufacturer_warranty_months : manufacturer_warranty_months // ignore: cast_nullable_to_non_nullable
as int,agency_warranty_months: null == agency_warranty_months ? _self.agency_warranty_months : agency_warranty_months // ignore: cast_nullable_to_non_nullable
as int,expert_rating: freezed == expert_rating ? _self.expert_rating : expert_rating // ignore: cast_nullable_to_non_nullable
as num?,sales_count: null == sales_count ? _self.sales_count : sales_count // ignore: cast_nullable_to_non_nullable
as int,views_count: null == views_count ? _self.views_count : views_count // ignore: cast_nullable_to_non_nullable
as int,is_featured: null == is_featured ? _self.is_featured : is_featured // ignore: cast_nullable_to_non_nullable
as bool,badges: null == badges ? _self._badges : badges // ignore: cast_nullable_to_non_nullable
as List<String>,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<ProductImage>,primary_image: freezed == primary_image ? _self.primary_image : primary_image // ignore: cast_nullable_to_non_nullable
as String?,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as Brand,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category,tire_spec: freezed == tire_spec ? _self.tire_spec : tire_spec // ignore: cast_nullable_to_non_nullable
as TireSpec?,battery_spec: freezed == battery_spec ? _self.battery_spec : battery_spec // ignore: cast_nullable_to_non_nullable
as BatterySpec?,
  ));
}

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FlashSaleInfoCopyWith<$Res>? get flash_sale {
    if (_self.flash_sale == null) {
    return null;
  }

  return $FlashSaleInfoCopyWith<$Res>(_self.flash_sale!, (value) {
    return _then(_self.copyWith(flash_sale: value));
  });
}/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BrandCopyWith<$Res> get brand {
  
  return $BrandCopyWith<$Res>(_self.brand, (value) {
    return _then(_self.copyWith(brand: value));
  });
}/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res> get category {
  
  return $CategoryCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TireSpecCopyWith<$Res>? get tire_spec {
    if (_self.tire_spec == null) {
    return null;
  }

  return $TireSpecCopyWith<$Res>(_self.tire_spec!, (value) {
    return _then(_self.copyWith(tire_spec: value));
  });
}/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BatterySpecCopyWith<$Res>? get battery_spec {
    if (_self.battery_spec == null) {
    return null;
  }

  return $BatterySpecCopyWith<$Res>(_self.battery_spec!, (value) {
    return _then(_self.copyWith(battery_spec: value));
  });
}
}

// dart format on
