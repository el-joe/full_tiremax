// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flash_sale_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FlashSaleInfo {

 int get id; String get title; num get discount_percent; String get ends_at; int get countdown_seconds;
/// Create a copy of FlashSaleInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FlashSaleInfoCopyWith<FlashSaleInfo> get copyWith => _$FlashSaleInfoCopyWithImpl<FlashSaleInfo>(this as FlashSaleInfo, _$identity);

  /// Serializes this FlashSaleInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FlashSaleInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FlashSaleInfo&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.discount_percent, _this.discount_percent) || other.discount_percent == _this.discount_percent)&&(identical(other.ends_at, _this.ends_at) || other.ends_at == _this.ends_at)&&(identical(other.countdown_seconds, _this.countdown_seconds) || other.countdown_seconds == _this.countdown_seconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FlashSaleInfo;
  return Object.hash(runtimeType,_this.id,_this.title,_this.discount_percent,_this.ends_at,_this.countdown_seconds);
}

@override
String toString() {
  final _this = this as FlashSaleInfo;
  return 'FlashSaleInfo(id: ${_this.id}, title: ${_this.title}, discount_percent: ${_this.discount_percent}, ends_at: ${_this.ends_at}, countdown_seconds: ${_this.countdown_seconds})';
}


}

/// @nodoc
abstract mixin class $FlashSaleInfoCopyWith<$Res>  {
  factory $FlashSaleInfoCopyWith(FlashSaleInfo value, $Res Function(FlashSaleInfo) _then) = _$FlashSaleInfoCopyWithImpl;
@useResult
$Res call({
 int id, String title, num discount_percent, String ends_at, int countdown_seconds
});




}
/// @nodoc
class _$FlashSaleInfoCopyWithImpl<$Res>
    implements $FlashSaleInfoCopyWith<$Res> {
  _$FlashSaleInfoCopyWithImpl(this._self, this._then);

  final FlashSaleInfo _self;
  final $Res Function(FlashSaleInfo) _then;

/// Create a copy of FlashSaleInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? discount_percent = null,Object? ends_at = null,Object? countdown_seconds = null,}) {
  return _then(FlashSaleInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,discount_percent: null == discount_percent ? _self.discount_percent : discount_percent // ignore: cast_nullable_to_non_nullable
as num,ends_at: null == ends_at ? _self.ends_at : ends_at // ignore: cast_nullable_to_non_nullable
as String,countdown_seconds: null == countdown_seconds ? _self.countdown_seconds : countdown_seconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FlashSaleInfo].
extension FlashSaleInfoPatterns on FlashSaleInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FlashSaleInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FlashSaleInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FlashSaleInfo value)  $default,){
final _that = this;
switch (_that) {
case _FlashSaleInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FlashSaleInfo value)?  $default,){
final _that = this;
switch (_that) {
case _FlashSaleInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  num discount_percent,  String ends_at,  int countdown_seconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FlashSaleInfo() when $default != null:
return $default(_that.id,_that.title,_that.discount_percent,_that.ends_at,_that.countdown_seconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  num discount_percent,  String ends_at,  int countdown_seconds)  $default,) {final _that = this;
switch (_that) {
case _FlashSaleInfo():
return $default(_that.id,_that.title,_that.discount_percent,_that.ends_at,_that.countdown_seconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  num discount_percent,  String ends_at,  int countdown_seconds)?  $default,) {final _that = this;
switch (_that) {
case _FlashSaleInfo() when $default != null:
return $default(_that.id,_that.title,_that.discount_percent,_that.ends_at,_that.countdown_seconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FlashSaleInfo implements FlashSaleInfo {
  const _FlashSaleInfo({required this.id, required this.title, required this.discount_percent, required this.ends_at, required this.countdown_seconds});
  factory _FlashSaleInfo.fromJson(Map<String, dynamic> json) => _$FlashSaleInfoFromJson(json);

@override final  int id;
@override final  String title;
@override final  num discount_percent;
@override final  String ends_at;
@override final  int countdown_seconds;

/// Create a copy of FlashSaleInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FlashSaleInfoCopyWith<_FlashSaleInfo> get copyWith => __$FlashSaleInfoCopyWithImpl<_FlashSaleInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FlashSaleInfoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FlashSaleInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.discount_percent, discount_percent) || other.discount_percent == discount_percent)&&(identical(other.ends_at, ends_at) || other.ends_at == ends_at)&&(identical(other.countdown_seconds, countdown_seconds) || other.countdown_seconds == countdown_seconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,discount_percent,ends_at,countdown_seconds);
}

@override
String toString() {
    return 'FlashSaleInfo(id: $id, title: $title, discount_percent: $discount_percent, ends_at: $ends_at, countdown_seconds: $countdown_seconds)';
}


}

/// @nodoc
abstract mixin class _$FlashSaleInfoCopyWith<$Res> implements $FlashSaleInfoCopyWith<$Res> {
  factory _$FlashSaleInfoCopyWith(_FlashSaleInfo value, $Res Function(_FlashSaleInfo) _then) = __$FlashSaleInfoCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, num discount_percent, String ends_at, int countdown_seconds
});




}
/// @nodoc
class __$FlashSaleInfoCopyWithImpl<$Res>
    implements _$FlashSaleInfoCopyWith<$Res> {
  __$FlashSaleInfoCopyWithImpl(this._self, this._then);

  final _FlashSaleInfo _self;
  final $Res Function(_FlashSaleInfo) _then;

/// Create a copy of FlashSaleInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? discount_percent = null,Object? ends_at = null,Object? countdown_seconds = null,}) {
  return _then(_FlashSaleInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,discount_percent: null == discount_percent ? _self.discount_percent : discount_percent // ignore: cast_nullable_to_non_nullable
as num,ends_at: null == ends_at ? _self.ends_at : ends_at // ignore: cast_nullable_to_non_nullable
as String,countdown_seconds: null == countdown_seconds ? _self.countdown_seconds : countdown_seconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
