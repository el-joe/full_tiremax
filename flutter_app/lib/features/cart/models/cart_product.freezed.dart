// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CartProduct {

 int get id; String get sku; String get type; String get name; String get short_description; String get description; String get pattern_name; String get usage_notes; num get price; num get sale_price; num get effective_price; bool get has_discount; bool get is_flash_sale; num get flash_sale; int get stock; bool get in_stock; int get manufacture_year; int get manufacturer_warranty_months; int get agency_warranty_months; num get expert_rating; int get sales_count; int get views_count; bool get is_featured; List<String> get images; String? get primary_image; Brand get brand;
/// Create a copy of CartProduct
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartProductCopyWith<CartProduct> get copyWith => _$CartProductCopyWithImpl<CartProduct>(this as CartProduct, _$identity);

  /// Serializes this CartProduct to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CartProduct;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartProduct&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.sku, _this.sku) || other.sku == _this.sku)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.short_description, _this.short_description) || other.short_description == _this.short_description)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.pattern_name, _this.pattern_name) || other.pattern_name == _this.pattern_name)&&(identical(other.usage_notes, _this.usage_notes) || other.usage_notes == _this.usage_notes)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.sale_price, _this.sale_price) || other.sale_price == _this.sale_price)&&(identical(other.effective_price, _this.effective_price) || other.effective_price == _this.effective_price)&&(identical(other.has_discount, _this.has_discount) || other.has_discount == _this.has_discount)&&(identical(other.is_flash_sale, _this.is_flash_sale) || other.is_flash_sale == _this.is_flash_sale)&&(identical(other.flash_sale, _this.flash_sale) || other.flash_sale == _this.flash_sale)&&(identical(other.stock, _this.stock) || other.stock == _this.stock)&&(identical(other.in_stock, _this.in_stock) || other.in_stock == _this.in_stock)&&(identical(other.manufacture_year, _this.manufacture_year) || other.manufacture_year == _this.manufacture_year)&&(identical(other.manufacturer_warranty_months, _this.manufacturer_warranty_months) || other.manufacturer_warranty_months == _this.manufacturer_warranty_months)&&(identical(other.agency_warranty_months, _this.agency_warranty_months) || other.agency_warranty_months == _this.agency_warranty_months)&&(identical(other.expert_rating, _this.expert_rating) || other.expert_rating == _this.expert_rating)&&(identical(other.sales_count, _this.sales_count) || other.sales_count == _this.sales_count)&&(identical(other.views_count, _this.views_count) || other.views_count == _this.views_count)&&(identical(other.is_featured, _this.is_featured) || other.is_featured == _this.is_featured)&&const DeepCollectionEquality().equals(other.images, _this.images)&&(identical(other.primary_image, _this.primary_image) || other.primary_image == _this.primary_image)&&(identical(other.brand, _this.brand) || other.brand == _this.brand));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CartProduct;
  return Object.hashAll([runtimeType,_this.id,_this.sku,_this.type,_this.name,_this.short_description,_this.description,_this.pattern_name,_this.usage_notes,_this.price,_this.sale_price,_this.effective_price,_this.has_discount,_this.is_flash_sale,_this.flash_sale,_this.stock,_this.in_stock,_this.manufacture_year,_this.manufacturer_warranty_months,_this.agency_warranty_months,_this.expert_rating,_this.sales_count,_this.views_count,_this.is_featured,const DeepCollectionEquality().hash(_this.images),_this.primary_image,_this.brand]);
}

@override
String toString() {
  final _this = this as CartProduct;
  return 'CartProduct(id: ${_this.id}, sku: ${_this.sku}, type: ${_this.type}, name: ${_this.name}, short_description: ${_this.short_description}, description: ${_this.description}, pattern_name: ${_this.pattern_name}, usage_notes: ${_this.usage_notes}, price: ${_this.price}, sale_price: ${_this.sale_price}, effective_price: ${_this.effective_price}, has_discount: ${_this.has_discount}, is_flash_sale: ${_this.is_flash_sale}, flash_sale: ${_this.flash_sale}, stock: ${_this.stock}, in_stock: ${_this.in_stock}, manufacture_year: ${_this.manufacture_year}, manufacturer_warranty_months: ${_this.manufacturer_warranty_months}, agency_warranty_months: ${_this.agency_warranty_months}, expert_rating: ${_this.expert_rating}, sales_count: ${_this.sales_count}, views_count: ${_this.views_count}, is_featured: ${_this.is_featured}, images: ${_this.images}, primary_image: ${_this.primary_image}, brand: ${_this.brand})';
}


}

/// @nodoc
abstract mixin class $CartProductCopyWith<$Res>  {
  factory $CartProductCopyWith(CartProduct value, $Res Function(CartProduct) _then) = _$CartProductCopyWithImpl;
@useResult
$Res call({
 int id, String sku, String type, String name, String short_description, String description, String pattern_name, String usage_notes, num price, num sale_price, num effective_price, bool has_discount, bool is_flash_sale, num flash_sale, int stock, bool in_stock, int manufacture_year, int manufacturer_warranty_months, int agency_warranty_months, num expert_rating, int sales_count, int views_count, bool is_featured, List<String> images, String? primary_image, Brand brand
});


$BrandCopyWith<$Res> get brand;

}
/// @nodoc
class _$CartProductCopyWithImpl<$Res>
    implements $CartProductCopyWith<$Res> {
  _$CartProductCopyWithImpl(this._self, this._then);

  final CartProduct _self;
  final $Res Function(CartProduct) _then;

/// Create a copy of CartProduct
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sku = null,Object? type = null,Object? name = null,Object? short_description = null,Object? description = null,Object? pattern_name = null,Object? usage_notes = null,Object? price = null,Object? sale_price = null,Object? effective_price = null,Object? has_discount = null,Object? is_flash_sale = null,Object? flash_sale = null,Object? stock = null,Object? in_stock = null,Object? manufacture_year = null,Object? manufacturer_warranty_months = null,Object? agency_warranty_months = null,Object? expert_rating = null,Object? sales_count = null,Object? views_count = null,Object? is_featured = null,Object? images = null,Object? primary_image = freezed,Object? brand = null,}) {
  return _then(CartProduct(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,short_description: null == short_description ? _self.short_description : short_description // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,pattern_name: null == pattern_name ? _self.pattern_name : pattern_name // ignore: cast_nullable_to_non_nullable
as String,usage_notes: null == usage_notes ? _self.usage_notes : usage_notes // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as num,sale_price: null == sale_price ? _self.sale_price : sale_price // ignore: cast_nullable_to_non_nullable
as num,effective_price: null == effective_price ? _self.effective_price : effective_price // ignore: cast_nullable_to_non_nullable
as num,has_discount: null == has_discount ? _self.has_discount : has_discount // ignore: cast_nullable_to_non_nullable
as bool,is_flash_sale: null == is_flash_sale ? _self.is_flash_sale : is_flash_sale // ignore: cast_nullable_to_non_nullable
as bool,flash_sale: null == flash_sale ? _self.flash_sale : flash_sale // ignore: cast_nullable_to_non_nullable
as num,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,in_stock: null == in_stock ? _self.in_stock : in_stock // ignore: cast_nullable_to_non_nullable
as bool,manufacture_year: null == manufacture_year ? _self.manufacture_year : manufacture_year // ignore: cast_nullable_to_non_nullable
as int,manufacturer_warranty_months: null == manufacturer_warranty_months ? _self.manufacturer_warranty_months : manufacturer_warranty_months // ignore: cast_nullable_to_non_nullable
as int,agency_warranty_months: null == agency_warranty_months ? _self.agency_warranty_months : agency_warranty_months // ignore: cast_nullable_to_non_nullable
as int,expert_rating: null == expert_rating ? _self.expert_rating : expert_rating // ignore: cast_nullable_to_non_nullable
as num,sales_count: null == sales_count ? _self.sales_count : sales_count // ignore: cast_nullable_to_non_nullable
as int,views_count: null == views_count ? _self.views_count : views_count // ignore: cast_nullable_to_non_nullable
as int,is_featured: null == is_featured ? _self.is_featured : is_featured // ignore: cast_nullable_to_non_nullable
as bool,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>,primary_image: freezed == primary_image ? _self.primary_image : primary_image // ignore: cast_nullable_to_non_nullable
as String?,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as Brand,
  ));
}
/// Create a copy of CartProduct
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BrandCopyWith<$Res> get brand {
  
  return $BrandCopyWith<$Res>(_self.brand, (value) {
    return _then(_self.copyWith(brand: value));
  });
}
}


/// Adds pattern-matching-related methods to [CartProduct].
extension CartProductPatterns on CartProduct {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CartProduct value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CartProduct() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CartProduct value)  $default,){
final _that = this;
switch (_that) {
case _CartProduct():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CartProduct value)?  $default,){
final _that = this;
switch (_that) {
case _CartProduct() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String sku,  String type,  String name,  String short_description,  String description,  String pattern_name,  String usage_notes,  num price,  num sale_price,  num effective_price,  bool has_discount,  bool is_flash_sale,  num flash_sale,  int stock,  bool in_stock,  int manufacture_year,  int manufacturer_warranty_months,  int agency_warranty_months,  num expert_rating,  int sales_count,  int views_count,  bool is_featured,  List<String> images,  String? primary_image,  Brand brand)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CartProduct() when $default != null:
return $default(_that.id,_that.sku,_that.type,_that.name,_that.short_description,_that.description,_that.pattern_name,_that.usage_notes,_that.price,_that.sale_price,_that.effective_price,_that.has_discount,_that.is_flash_sale,_that.flash_sale,_that.stock,_that.in_stock,_that.manufacture_year,_that.manufacturer_warranty_months,_that.agency_warranty_months,_that.expert_rating,_that.sales_count,_that.views_count,_that.is_featured,_that.images,_that.primary_image,_that.brand);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String sku,  String type,  String name,  String short_description,  String description,  String pattern_name,  String usage_notes,  num price,  num sale_price,  num effective_price,  bool has_discount,  bool is_flash_sale,  num flash_sale,  int stock,  bool in_stock,  int manufacture_year,  int manufacturer_warranty_months,  int agency_warranty_months,  num expert_rating,  int sales_count,  int views_count,  bool is_featured,  List<String> images,  String? primary_image,  Brand brand)  $default,) {final _that = this;
switch (_that) {
case _CartProduct():
return $default(_that.id,_that.sku,_that.type,_that.name,_that.short_description,_that.description,_that.pattern_name,_that.usage_notes,_that.price,_that.sale_price,_that.effective_price,_that.has_discount,_that.is_flash_sale,_that.flash_sale,_that.stock,_that.in_stock,_that.manufacture_year,_that.manufacturer_warranty_months,_that.agency_warranty_months,_that.expert_rating,_that.sales_count,_that.views_count,_that.is_featured,_that.images,_that.primary_image,_that.brand);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String sku,  String type,  String name,  String short_description,  String description,  String pattern_name,  String usage_notes,  num price,  num sale_price,  num effective_price,  bool has_discount,  bool is_flash_sale,  num flash_sale,  int stock,  bool in_stock,  int manufacture_year,  int manufacturer_warranty_months,  int agency_warranty_months,  num expert_rating,  int sales_count,  int views_count,  bool is_featured,  List<String> images,  String? primary_image,  Brand brand)?  $default,) {final _that = this;
switch (_that) {
case _CartProduct() when $default != null:
return $default(_that.id,_that.sku,_that.type,_that.name,_that.short_description,_that.description,_that.pattern_name,_that.usage_notes,_that.price,_that.sale_price,_that.effective_price,_that.has_discount,_that.is_flash_sale,_that.flash_sale,_that.stock,_that.in_stock,_that.manufacture_year,_that.manufacturer_warranty_months,_that.agency_warranty_months,_that.expert_rating,_that.sales_count,_that.views_count,_that.is_featured,_that.images,_that.primary_image,_that.brand);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CartProduct implements CartProduct {
  const _CartProduct({required this.id, required this.sku, required this.type, required this.name, required this.short_description, required this.description, required this.pattern_name, required this.usage_notes, required this.price, required this.sale_price, required this.effective_price, required this.has_discount, required this.is_flash_sale, required this.flash_sale, required this.stock, required this.in_stock, required this.manufacture_year, required this.manufacturer_warranty_months, required this.agency_warranty_months, required this.expert_rating, required this.sales_count, required this.views_count, required this.is_featured,  List<String> images = const <String>[], this.primary_image, required this.brand}): _images = images;
  factory _CartProduct.fromJson(Map<String, dynamic> json) => _$CartProductFromJson(json);

@override final  int id;
@override final  String sku;
@override final  String type;
@override final  String name;
@override final  String short_description;
@override final  String description;
@override final  String pattern_name;
@override final  String usage_notes;
@override final  num price;
@override final  num sale_price;
@override final  num effective_price;
@override final  bool has_discount;
@override final  bool is_flash_sale;
@override final  num flash_sale;
@override final  int stock;
@override final  bool in_stock;
@override final  int manufacture_year;
@override final  int manufacturer_warranty_months;
@override final  int agency_warranty_months;
@override final  num expert_rating;
@override final  int sales_count;
@override final  int views_count;
@override final  bool is_featured;
 final  List<String> _images;
@override@JsonKey() List<String> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

@override final  String? primary_image;
@override final  Brand brand;

/// Create a copy of CartProduct
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartProductCopyWith<_CartProduct> get copyWith => __$CartProductCopyWithImpl<_CartProduct>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CartProductToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CartProduct&&(identical(other.id, id) || other.id == id)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.short_description, short_description) || other.short_description == short_description)&&(identical(other.description, description) || other.description == description)&&(identical(other.pattern_name, pattern_name) || other.pattern_name == pattern_name)&&(identical(other.usage_notes, usage_notes) || other.usage_notes == usage_notes)&&(identical(other.price, price) || other.price == price)&&(identical(other.sale_price, sale_price) || other.sale_price == sale_price)&&(identical(other.effective_price, effective_price) || other.effective_price == effective_price)&&(identical(other.has_discount, has_discount) || other.has_discount == has_discount)&&(identical(other.is_flash_sale, is_flash_sale) || other.is_flash_sale == is_flash_sale)&&(identical(other.flash_sale, flash_sale) || other.flash_sale == flash_sale)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.in_stock, in_stock) || other.in_stock == in_stock)&&(identical(other.manufacture_year, manufacture_year) || other.manufacture_year == manufacture_year)&&(identical(other.manufacturer_warranty_months, manufacturer_warranty_months) || other.manufacturer_warranty_months == manufacturer_warranty_months)&&(identical(other.agency_warranty_months, agency_warranty_months) || other.agency_warranty_months == agency_warranty_months)&&(identical(other.expert_rating, expert_rating) || other.expert_rating == expert_rating)&&(identical(other.sales_count, sales_count) || other.sales_count == sales_count)&&(identical(other.views_count, views_count) || other.views_count == views_count)&&(identical(other.is_featured, is_featured) || other.is_featured == is_featured)&&const DeepCollectionEquality().equals(other.images, _images)&&(identical(other.primary_image, primary_image) || other.primary_image == primary_image)&&(identical(other.brand, brand) || other.brand == brand));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,sku,type,name,short_description,description,pattern_name,usage_notes,price,sale_price,effective_price,has_discount,is_flash_sale,flash_sale,stock,in_stock,manufacture_year,manufacturer_warranty_months,agency_warranty_months,expert_rating,sales_count,views_count,is_featured,const DeepCollectionEquality().hash(_images),primary_image,brand]);
}

@override
String toString() {
    return 'CartProduct(id: $id, sku: $sku, type: $type, name: $name, short_description: $short_description, description: $description, pattern_name: $pattern_name, usage_notes: $usage_notes, price: $price, sale_price: $sale_price, effective_price: $effective_price, has_discount: $has_discount, is_flash_sale: $is_flash_sale, flash_sale: $flash_sale, stock: $stock, in_stock: $in_stock, manufacture_year: $manufacture_year, manufacturer_warranty_months: $manufacturer_warranty_months, agency_warranty_months: $agency_warranty_months, expert_rating: $expert_rating, sales_count: $sales_count, views_count: $views_count, is_featured: $is_featured, images: $images, primary_image: $primary_image, brand: $brand)';
}


}

/// @nodoc
abstract mixin class _$CartProductCopyWith<$Res> implements $CartProductCopyWith<$Res> {
  factory _$CartProductCopyWith(_CartProduct value, $Res Function(_CartProduct) _then) = __$CartProductCopyWithImpl;
@override @useResult
$Res call({
 int id, String sku, String type, String name, String short_description, String description, String pattern_name, String usage_notes, num price, num sale_price, num effective_price, bool has_discount, bool is_flash_sale, num flash_sale, int stock, bool in_stock, int manufacture_year, int manufacturer_warranty_months, int agency_warranty_months, num expert_rating, int sales_count, int views_count, bool is_featured, List<String> images, String? primary_image, Brand brand
});


@override $BrandCopyWith<$Res> get brand;

}
/// @nodoc
class __$CartProductCopyWithImpl<$Res>
    implements _$CartProductCopyWith<$Res> {
  __$CartProductCopyWithImpl(this._self, this._then);

  final _CartProduct _self;
  final $Res Function(_CartProduct) _then;

/// Create a copy of CartProduct
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sku = null,Object? type = null,Object? name = null,Object? short_description = null,Object? description = null,Object? pattern_name = null,Object? usage_notes = null,Object? price = null,Object? sale_price = null,Object? effective_price = null,Object? has_discount = null,Object? is_flash_sale = null,Object? flash_sale = null,Object? stock = null,Object? in_stock = null,Object? manufacture_year = null,Object? manufacturer_warranty_months = null,Object? agency_warranty_months = null,Object? expert_rating = null,Object? sales_count = null,Object? views_count = null,Object? is_featured = null,Object? images = null,Object? primary_image = freezed,Object? brand = null,}) {
  return _then(_CartProduct(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,short_description: null == short_description ? _self.short_description : short_description // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,pattern_name: null == pattern_name ? _self.pattern_name : pattern_name // ignore: cast_nullable_to_non_nullable
as String,usage_notes: null == usage_notes ? _self.usage_notes : usage_notes // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as num,sale_price: null == sale_price ? _self.sale_price : sale_price // ignore: cast_nullable_to_non_nullable
as num,effective_price: null == effective_price ? _self.effective_price : effective_price // ignore: cast_nullable_to_non_nullable
as num,has_discount: null == has_discount ? _self.has_discount : has_discount // ignore: cast_nullable_to_non_nullable
as bool,is_flash_sale: null == is_flash_sale ? _self.is_flash_sale : is_flash_sale // ignore: cast_nullable_to_non_nullable
as bool,flash_sale: null == flash_sale ? _self.flash_sale : flash_sale // ignore: cast_nullable_to_non_nullable
as num,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,in_stock: null == in_stock ? _self.in_stock : in_stock // ignore: cast_nullable_to_non_nullable
as bool,manufacture_year: null == manufacture_year ? _self.manufacture_year : manufacture_year // ignore: cast_nullable_to_non_nullable
as int,manufacturer_warranty_months: null == manufacturer_warranty_months ? _self.manufacturer_warranty_months : manufacturer_warranty_months // ignore: cast_nullable_to_non_nullable
as int,agency_warranty_months: null == agency_warranty_months ? _self.agency_warranty_months : agency_warranty_months // ignore: cast_nullable_to_non_nullable
as int,expert_rating: null == expert_rating ? _self.expert_rating : expert_rating // ignore: cast_nullable_to_non_nullable
as num,sales_count: null == sales_count ? _self.sales_count : sales_count // ignore: cast_nullable_to_non_nullable
as int,views_count: null == views_count ? _self.views_count : views_count // ignore: cast_nullable_to_non_nullable
as int,is_featured: null == is_featured ? _self.is_featured : is_featured // ignore: cast_nullable_to_non_nullable
as bool,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>,primary_image: freezed == primary_image ? _self.primary_image : primary_image // ignore: cast_nullable_to_non_nullable
as String?,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as Brand,
  ));
}

/// Create a copy of CartProduct
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BrandCopyWith<$Res> get brand {
  
  return $BrandCopyWith<$Res>(_self.brand, (value) {
    return _then(_self.copyWith(brand: value));
  });
}
}

// dart format on
