// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_fav.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomerFav {

 int get id; String get sku; String get name; num get price; num? get sale_price; num? get effective_price; bool get has_discount; bool get in_stock; bool get is_featured; List<String> get badges; String? get primary_image; CustomerFavBrand get brand;
/// Create a copy of CustomerFav
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerFavCopyWith<CustomerFav> get copyWith => _$CustomerFavCopyWithImpl<CustomerFav>(this as CustomerFav, _$identity);

  /// Serializes this CustomerFav to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CustomerFav;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerFav&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.sku, _this.sku) || other.sku == _this.sku)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.sale_price, _this.sale_price) || other.sale_price == _this.sale_price)&&(identical(other.effective_price, _this.effective_price) || other.effective_price == _this.effective_price)&&(identical(other.has_discount, _this.has_discount) || other.has_discount == _this.has_discount)&&(identical(other.in_stock, _this.in_stock) || other.in_stock == _this.in_stock)&&(identical(other.is_featured, _this.is_featured) || other.is_featured == _this.is_featured)&&const DeepCollectionEquality().equals(other.badges, _this.badges)&&(identical(other.primary_image, _this.primary_image) || other.primary_image == _this.primary_image)&&(identical(other.brand, _this.brand) || other.brand == _this.brand));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CustomerFav;
  return Object.hash(runtimeType,_this.id,_this.sku,_this.name,_this.price,_this.sale_price,_this.effective_price,_this.has_discount,_this.in_stock,_this.is_featured,const DeepCollectionEquality().hash(_this.badges),_this.primary_image,_this.brand);
}

@override
String toString() {
  final _this = this as CustomerFav;
  return 'CustomerFav(id: ${_this.id}, sku: ${_this.sku}, name: ${_this.name}, price: ${_this.price}, sale_price: ${_this.sale_price}, effective_price: ${_this.effective_price}, has_discount: ${_this.has_discount}, in_stock: ${_this.in_stock}, is_featured: ${_this.is_featured}, badges: ${_this.badges}, primary_image: ${_this.primary_image}, brand: ${_this.brand})';
}


}

/// @nodoc
abstract mixin class $CustomerFavCopyWith<$Res>  {
  factory $CustomerFavCopyWith(CustomerFav value, $Res Function(CustomerFav) _then) = _$CustomerFavCopyWithImpl;
@useResult
$Res call({
 int id, String sku, String name, num price, num? sale_price, num? effective_price, bool has_discount, bool in_stock, bool is_featured, List<String> badges, String? primary_image, CustomerFavBrand brand
});


$CustomerFavBrandCopyWith<$Res> get brand;

}
/// @nodoc
class _$CustomerFavCopyWithImpl<$Res>
    implements $CustomerFavCopyWith<$Res> {
  _$CustomerFavCopyWithImpl(this._self, this._then);

  final CustomerFav _self;
  final $Res Function(CustomerFav) _then;

/// Create a copy of CustomerFav
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sku = null,Object? name = null,Object? price = null,Object? sale_price = freezed,Object? effective_price = freezed,Object? has_discount = null,Object? in_stock = null,Object? is_featured = null,Object? badges = null,Object? primary_image = freezed,Object? brand = null,}) {
  return _then(CustomerFav(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as num,sale_price: freezed == sale_price ? _self.sale_price : sale_price // ignore: cast_nullable_to_non_nullable
as num?,effective_price: freezed == effective_price ? _self.effective_price : effective_price // ignore: cast_nullable_to_non_nullable
as num?,has_discount: null == has_discount ? _self.has_discount : has_discount // ignore: cast_nullable_to_non_nullable
as bool,in_stock: null == in_stock ? _self.in_stock : in_stock // ignore: cast_nullable_to_non_nullable
as bool,is_featured: null == is_featured ? _self.is_featured : is_featured // ignore: cast_nullable_to_non_nullable
as bool,badges: null == badges ? _self.badges : badges // ignore: cast_nullable_to_non_nullable
as List<String>,primary_image: freezed == primary_image ? _self.primary_image : primary_image // ignore: cast_nullable_to_non_nullable
as String?,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as CustomerFavBrand,
  ));
}
/// Create a copy of CustomerFav
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerFavBrandCopyWith<$Res> get brand {
  
  return $CustomerFavBrandCopyWith<$Res>(_self.brand, (value) {
    return _then(_self.copyWith(brand: value));
  });
}
}


/// Adds pattern-matching-related methods to [CustomerFav].
extension CustomerFavPatterns on CustomerFav {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerFav value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerFav() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerFav value)  $default,){
final _that = this;
switch (_that) {
case _CustomerFav():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerFav value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerFav() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String sku,  String name,  num price,  num? sale_price,  num? effective_price,  bool has_discount,  bool in_stock,  bool is_featured,  List<String> badges,  String? primary_image,  CustomerFavBrand brand)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerFav() when $default != null:
return $default(_that.id,_that.sku,_that.name,_that.price,_that.sale_price,_that.effective_price,_that.has_discount,_that.in_stock,_that.is_featured,_that.badges,_that.primary_image,_that.brand);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String sku,  String name,  num price,  num? sale_price,  num? effective_price,  bool has_discount,  bool in_stock,  bool is_featured,  List<String> badges,  String? primary_image,  CustomerFavBrand brand)  $default,) {final _that = this;
switch (_that) {
case _CustomerFav():
return $default(_that.id,_that.sku,_that.name,_that.price,_that.sale_price,_that.effective_price,_that.has_discount,_that.in_stock,_that.is_featured,_that.badges,_that.primary_image,_that.brand);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String sku,  String name,  num price,  num? sale_price,  num? effective_price,  bool has_discount,  bool in_stock,  bool is_featured,  List<String> badges,  String? primary_image,  CustomerFavBrand brand)?  $default,) {final _that = this;
switch (_that) {
case _CustomerFav() when $default != null:
return $default(_that.id,_that.sku,_that.name,_that.price,_that.sale_price,_that.effective_price,_that.has_discount,_that.in_stock,_that.is_featured,_that.badges,_that.primary_image,_that.brand);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomerFav implements CustomerFav {
  const _CustomerFav({required this.id, required this.sku, required this.name, required this.price, this.sale_price, this.effective_price, required this.has_discount, required this.in_stock, required this.is_featured,  List<String> badges = const <String>[], this.primary_image, required this.brand}): _badges = badges;
  factory _CustomerFav.fromJson(Map<String, dynamic> json) => _$CustomerFavFromJson(json);

@override final  int id;
@override final  String sku;
@override final  String name;
@override final  num price;
@override final  num? sale_price;
@override final  num? effective_price;
@override final  bool has_discount;
@override final  bool in_stock;
@override final  bool is_featured;
 final  List<String> _badges;
@override@JsonKey() List<String> get badges {
  if (_badges is EqualUnmodifiableListView) return _badges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_badges);
}

@override final  String? primary_image;
@override final  CustomerFavBrand brand;

/// Create a copy of CustomerFav
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerFavCopyWith<_CustomerFav> get copyWith => __$CustomerFavCopyWithImpl<_CustomerFav>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerFavToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerFav&&(identical(other.id, id) || other.id == id)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.sale_price, sale_price) || other.sale_price == sale_price)&&(identical(other.effective_price, effective_price) || other.effective_price == effective_price)&&(identical(other.has_discount, has_discount) || other.has_discount == has_discount)&&(identical(other.in_stock, in_stock) || other.in_stock == in_stock)&&(identical(other.is_featured, is_featured) || other.is_featured == is_featured)&&const DeepCollectionEquality().equals(other.badges, _badges)&&(identical(other.primary_image, primary_image) || other.primary_image == primary_image)&&(identical(other.brand, brand) || other.brand == brand));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,sku,name,price,sale_price,effective_price,has_discount,in_stock,is_featured,const DeepCollectionEquality().hash(_badges),primary_image,brand);
}

@override
String toString() {
    return 'CustomerFav(id: $id, sku: $sku, name: $name, price: $price, sale_price: $sale_price, effective_price: $effective_price, has_discount: $has_discount, in_stock: $in_stock, is_featured: $is_featured, badges: $badges, primary_image: $primary_image, brand: $brand)';
}


}

/// @nodoc
abstract mixin class _$CustomerFavCopyWith<$Res> implements $CustomerFavCopyWith<$Res> {
  factory _$CustomerFavCopyWith(_CustomerFav value, $Res Function(_CustomerFav) _then) = __$CustomerFavCopyWithImpl;
@override @useResult
$Res call({
 int id, String sku, String name, num price, num? sale_price, num? effective_price, bool has_discount, bool in_stock, bool is_featured, List<String> badges, String? primary_image, CustomerFavBrand brand
});


@override $CustomerFavBrandCopyWith<$Res> get brand;

}
/// @nodoc
class __$CustomerFavCopyWithImpl<$Res>
    implements _$CustomerFavCopyWith<$Res> {
  __$CustomerFavCopyWithImpl(this._self, this._then);

  final _CustomerFav _self;
  final $Res Function(_CustomerFav) _then;

/// Create a copy of CustomerFav
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sku = null,Object? name = null,Object? price = null,Object? sale_price = freezed,Object? effective_price = freezed,Object? has_discount = null,Object? in_stock = null,Object? is_featured = null,Object? badges = null,Object? primary_image = freezed,Object? brand = null,}) {
  return _then(_CustomerFav(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as num,sale_price: freezed == sale_price ? _self.sale_price : sale_price // ignore: cast_nullable_to_non_nullable
as num?,effective_price: freezed == effective_price ? _self.effective_price : effective_price // ignore: cast_nullable_to_non_nullable
as num?,has_discount: null == has_discount ? _self.has_discount : has_discount // ignore: cast_nullable_to_non_nullable
as bool,in_stock: null == in_stock ? _self.in_stock : in_stock // ignore: cast_nullable_to_non_nullable
as bool,is_featured: null == is_featured ? _self.is_featured : is_featured // ignore: cast_nullable_to_non_nullable
as bool,badges: null == badges ? _self._badges : badges // ignore: cast_nullable_to_non_nullable
as List<String>,primary_image: freezed == primary_image ? _self.primary_image : primary_image // ignore: cast_nullable_to_non_nullable
as String?,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as CustomerFavBrand,
  ));
}

/// Create a copy of CustomerFav
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerFavBrandCopyWith<$Res> get brand {
  
  return $CustomerFavBrandCopyWith<$Res>(_self.brand, (value) {
    return _then(_self.copyWith(brand: value));
  });
}
}


/// @nodoc
mixin _$CustomerFavBrand {

 int get id; String get slug; String get name;
/// Create a copy of CustomerFavBrand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerFavBrandCopyWith<CustomerFavBrand> get copyWith => _$CustomerFavBrandCopyWithImpl<CustomerFavBrand>(this as CustomerFavBrand, _$identity);

  /// Serializes this CustomerFavBrand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CustomerFavBrand;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerFavBrand&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CustomerFavBrand;
  return Object.hash(runtimeType,_this.id,_this.slug,_this.name);
}

@override
String toString() {
  final _this = this as CustomerFavBrand;
  return 'CustomerFavBrand(id: ${_this.id}, slug: ${_this.slug}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $CustomerFavBrandCopyWith<$Res>  {
  factory $CustomerFavBrandCopyWith(CustomerFavBrand value, $Res Function(CustomerFavBrand) _then) = _$CustomerFavBrandCopyWithImpl;
@useResult
$Res call({
 int id, String slug, String name
});




}
/// @nodoc
class _$CustomerFavBrandCopyWithImpl<$Res>
    implements $CustomerFavBrandCopyWith<$Res> {
  _$CustomerFavBrandCopyWithImpl(this._self, this._then);

  final CustomerFavBrand _self;
  final $Res Function(CustomerFavBrand) _then;

/// Create a copy of CustomerFavBrand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? name = null,}) {
  return _then(CustomerFavBrand(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerFavBrand].
extension CustomerFavBrandPatterns on CustomerFavBrand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerFavBrand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerFavBrand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerFavBrand value)  $default,){
final _that = this;
switch (_that) {
case _CustomerFavBrand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerFavBrand value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerFavBrand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String slug,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerFavBrand() when $default != null:
return $default(_that.id,_that.slug,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String slug,  String name)  $default,) {final _that = this;
switch (_that) {
case _CustomerFavBrand():
return $default(_that.id,_that.slug,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String slug,  String name)?  $default,) {final _that = this;
switch (_that) {
case _CustomerFavBrand() when $default != null:
return $default(_that.id,_that.slug,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomerFavBrand implements CustomerFavBrand {
  const _CustomerFavBrand({required this.id, required this.slug, required this.name});
  factory _CustomerFavBrand.fromJson(Map<String, dynamic> json) => _$CustomerFavBrandFromJson(json);

@override final  int id;
@override final  String slug;
@override final  String name;

/// Create a copy of CustomerFavBrand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerFavBrandCopyWith<_CustomerFavBrand> get copyWith => __$CustomerFavBrandCopyWithImpl<_CustomerFavBrand>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerFavBrandToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerFavBrand&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,slug,name);
}

@override
String toString() {
    return 'CustomerFavBrand(id: $id, slug: $slug, name: $name)';
}


}

/// @nodoc
abstract mixin class _$CustomerFavBrandCopyWith<$Res> implements $CustomerFavBrandCopyWith<$Res> {
  factory _$CustomerFavBrandCopyWith(_CustomerFavBrand value, $Res Function(_CustomerFavBrand) _then) = __$CustomerFavBrandCopyWithImpl;
@override @useResult
$Res call({
 int id, String slug, String name
});




}
/// @nodoc
class __$CustomerFavBrandCopyWithImpl<$Res>
    implements _$CustomerFavBrandCopyWith<$Res> {
  __$CustomerFavBrandCopyWithImpl(this._self, this._then);

  final _CustomerFavBrand _self;
  final $Res Function(_CustomerFavBrand) _then;

/// Create a copy of CustomerFavBrand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? name = null,}) {
  return _then(_CustomerFavBrand(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
