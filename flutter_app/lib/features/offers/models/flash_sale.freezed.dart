// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flash_sale.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FlashSale {

 int get id; String get title; num get discount_percent; String? get starts_at; String? get ends_at; bool get is_active;
/// Create a copy of FlashSale
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FlashSaleCopyWith<FlashSale> get copyWith => _$FlashSaleCopyWithImpl<FlashSale>(this as FlashSale, _$identity);

  /// Serializes this FlashSale to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FlashSale;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FlashSale&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.discount_percent, _this.discount_percent) || other.discount_percent == _this.discount_percent)&&(identical(other.starts_at, _this.starts_at) || other.starts_at == _this.starts_at)&&(identical(other.ends_at, _this.ends_at) || other.ends_at == _this.ends_at)&&(identical(other.is_active, _this.is_active) || other.is_active == _this.is_active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FlashSale;
  return Object.hash(runtimeType,_this.id,_this.title,_this.discount_percent,_this.starts_at,_this.ends_at,_this.is_active);
}

@override
String toString() {
  final _this = this as FlashSale;
  return 'FlashSale(id: ${_this.id}, title: ${_this.title}, discount_percent: ${_this.discount_percent}, starts_at: ${_this.starts_at}, ends_at: ${_this.ends_at}, is_active: ${_this.is_active})';
}


}

/// @nodoc
abstract mixin class $FlashSaleCopyWith<$Res>  {
  factory $FlashSaleCopyWith(FlashSale value, $Res Function(FlashSale) _then) = _$FlashSaleCopyWithImpl;
@useResult
$Res call({
 int id, String title, num discount_percent, String? starts_at, String? ends_at, bool is_active
});




}
/// @nodoc
class _$FlashSaleCopyWithImpl<$Res>
    implements $FlashSaleCopyWith<$Res> {
  _$FlashSaleCopyWithImpl(this._self, this._then);

  final FlashSale _self;
  final $Res Function(FlashSale) _then;

/// Create a copy of FlashSale
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? discount_percent = null,Object? starts_at = freezed,Object? ends_at = freezed,Object? is_active = null,}) {
  return _then(FlashSale(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,discount_percent: null == discount_percent ? _self.discount_percent : discount_percent // ignore: cast_nullable_to_non_nullable
as num,starts_at: freezed == starts_at ? _self.starts_at : starts_at // ignore: cast_nullable_to_non_nullable
as String?,ends_at: freezed == ends_at ? _self.ends_at : ends_at // ignore: cast_nullable_to_non_nullable
as String?,is_active: null == is_active ? _self.is_active : is_active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FlashSale].
extension FlashSalePatterns on FlashSale {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FlashSale value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FlashSale() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FlashSale value)  $default,){
final _that = this;
switch (_that) {
case _FlashSale():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FlashSale value)?  $default,){
final _that = this;
switch (_that) {
case _FlashSale() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  num discount_percent,  String? starts_at,  String? ends_at,  bool is_active)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FlashSale() when $default != null:
return $default(_that.id,_that.title,_that.discount_percent,_that.starts_at,_that.ends_at,_that.is_active);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  num discount_percent,  String? starts_at,  String? ends_at,  bool is_active)  $default,) {final _that = this;
switch (_that) {
case _FlashSale():
return $default(_that.id,_that.title,_that.discount_percent,_that.starts_at,_that.ends_at,_that.is_active);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  num discount_percent,  String? starts_at,  String? ends_at,  bool is_active)?  $default,) {final _that = this;
switch (_that) {
case _FlashSale() when $default != null:
return $default(_that.id,_that.title,_that.discount_percent,_that.starts_at,_that.ends_at,_that.is_active);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FlashSale implements FlashSale {
  const _FlashSale({required this.id, required this.title, required this.discount_percent, this.starts_at, this.ends_at, this.is_active = true});
  factory _FlashSale.fromJson(Map<String, dynamic> json) => _$FlashSaleFromJson(json);

@override final  int id;
@override final  String title;
@override final  num discount_percent;
@override final  String? starts_at;
@override final  String? ends_at;
@override@JsonKey() final  bool is_active;

/// Create a copy of FlashSale
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FlashSaleCopyWith<_FlashSale> get copyWith => __$FlashSaleCopyWithImpl<_FlashSale>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FlashSaleToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FlashSale&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.discount_percent, discount_percent) || other.discount_percent == discount_percent)&&(identical(other.starts_at, starts_at) || other.starts_at == starts_at)&&(identical(other.ends_at, ends_at) || other.ends_at == ends_at)&&(identical(other.is_active, is_active) || other.is_active == is_active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,discount_percent,starts_at,ends_at,is_active);
}

@override
String toString() {
    return 'FlashSale(id: $id, title: $title, discount_percent: $discount_percent, starts_at: $starts_at, ends_at: $ends_at, is_active: $is_active)';
}


}

/// @nodoc
abstract mixin class _$FlashSaleCopyWith<$Res> implements $FlashSaleCopyWith<$Res> {
  factory _$FlashSaleCopyWith(_FlashSale value, $Res Function(_FlashSale) _then) = __$FlashSaleCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, num discount_percent, String? starts_at, String? ends_at, bool is_active
});




}
/// @nodoc
class __$FlashSaleCopyWithImpl<$Res>
    implements _$FlashSaleCopyWith<$Res> {
  __$FlashSaleCopyWithImpl(this._self, this._then);

  final _FlashSale _self;
  final $Res Function(_FlashSale) _then;

/// Create a copy of FlashSale
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? discount_percent = null,Object? starts_at = freezed,Object? ends_at = freezed,Object? is_active = null,}) {
  return _then(_FlashSale(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,discount_percent: null == discount_percent ? _self.discount_percent : discount_percent // ignore: cast_nullable_to_non_nullable
as num,starts_at: freezed == starts_at ? _self.starts_at : starts_at // ignore: cast_nullable_to_non_nullable
as String?,ends_at: freezed == ends_at ? _self.ends_at : ends_at // ignore: cast_nullable_to_non_nullable
as String?,is_active: null == is_active ? _self.is_active : is_active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
