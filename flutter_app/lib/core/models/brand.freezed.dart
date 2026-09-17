// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brand.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Brand {

 int get id; String get slug; String get name; String? get description; String? get logo; String get country; bool get is_active;
/// Create a copy of Brand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrandCopyWith<Brand> get copyWith => _$BrandCopyWithImpl<Brand>(this as Brand, _$identity);

  /// Serializes this Brand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Brand;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Brand&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.logo, _this.logo) || other.logo == _this.logo)&&(identical(other.country, _this.country) || other.country == _this.country)&&(identical(other.is_active, _this.is_active) || other.is_active == _this.is_active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Brand;
  return Object.hash(runtimeType,_this.id,_this.slug,_this.name,_this.description,_this.logo,_this.country,_this.is_active);
}

@override
String toString() {
  final _this = this as Brand;
  return 'Brand(id: ${_this.id}, slug: ${_this.slug}, name: ${_this.name}, description: ${_this.description}, logo: ${_this.logo}, country: ${_this.country}, is_active: ${_this.is_active})';
}


}

/// @nodoc
abstract mixin class $BrandCopyWith<$Res>  {
  factory $BrandCopyWith(Brand value, $Res Function(Brand) _then) = _$BrandCopyWithImpl;
@useResult
$Res call({
 int id, String slug, String name, String? description, String? logo, String country, bool is_active
});




}
/// @nodoc
class _$BrandCopyWithImpl<$Res>
    implements $BrandCopyWith<$Res> {
  _$BrandCopyWithImpl(this._self, this._then);

  final Brand _self;
  final $Res Function(Brand) _then;

/// Create a copy of Brand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? description = freezed,Object? logo = freezed,Object? country = null,Object? is_active = null,}) {
  return _then(Brand(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,is_active: null == is_active ? _self.is_active : is_active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Brand].
extension BrandPatterns on Brand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Brand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Brand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Brand value)  $default,){
final _that = this;
switch (_that) {
case _Brand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Brand value)?  $default,){
final _that = this;
switch (_that) {
case _Brand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String slug,  String name,  String? description,  String? logo,  String country,  bool is_active)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Brand() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.description,_that.logo,_that.country,_that.is_active);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String slug,  String name,  String? description,  String? logo,  String country,  bool is_active)  $default,) {final _that = this;
switch (_that) {
case _Brand():
return $default(_that.id,_that.slug,_that.name,_that.description,_that.logo,_that.country,_that.is_active);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String slug,  String name,  String? description,  String? logo,  String country,  bool is_active)?  $default,) {final _that = this;
switch (_that) {
case _Brand() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.description,_that.logo,_that.country,_that.is_active);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Brand implements Brand {
  const _Brand({required this.id, required this.slug, required this.name, this.description, this.logo, required this.country, required this.is_active});
  factory _Brand.fromJson(Map<String, dynamic> json) => _$BrandFromJson(json);

@override final  int id;
@override final  String slug;
@override final  String name;
@override final  String? description;
@override final  String? logo;
@override final  String country;
@override final  bool is_active;

/// Create a copy of Brand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BrandCopyWith<_Brand> get copyWith => __$BrandCopyWithImpl<_Brand>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BrandToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Brand&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.country, country) || other.country == country)&&(identical(other.is_active, is_active) || other.is_active == is_active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,slug,name,description,logo,country,is_active);
}

@override
String toString() {
    return 'Brand(id: $id, slug: $slug, name: $name, description: $description, logo: $logo, country: $country, is_active: $is_active)';
}


}

/// @nodoc
abstract mixin class _$BrandCopyWith<$Res> implements $BrandCopyWith<$Res> {
  factory _$BrandCopyWith(_Brand value, $Res Function(_Brand) _then) = __$BrandCopyWithImpl;
@override @useResult
$Res call({
 int id, String slug, String name, String? description, String? logo, String country, bool is_active
});




}
/// @nodoc
class __$BrandCopyWithImpl<$Res>
    implements _$BrandCopyWith<$Res> {
  __$BrandCopyWithImpl(this._self, this._then);

  final _Brand _self;
  final $Res Function(_Brand) _then;

/// Create a copy of Brand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? description = freezed,Object? logo = freezed,Object? country = null,Object? is_active = null,}) {
  return _then(_Brand(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,is_active: null == is_active ? _self.is_active : is_active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
