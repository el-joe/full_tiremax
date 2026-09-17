// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tyre_size.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TyreSize {

 num get width; num get aspect_ratio; num get rim_diameter;
/// Create a copy of TyreSize
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TyreSizeCopyWith<TyreSize> get copyWith => _$TyreSizeCopyWithImpl<TyreSize>(this as TyreSize, _$identity);

  /// Serializes this TyreSize to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TyreSize;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TyreSize&&(identical(other.width, _this.width) || other.width == _this.width)&&(identical(other.aspect_ratio, _this.aspect_ratio) || other.aspect_ratio == _this.aspect_ratio)&&(identical(other.rim_diameter, _this.rim_diameter) || other.rim_diameter == _this.rim_diameter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TyreSize;
  return Object.hash(runtimeType,_this.width,_this.aspect_ratio,_this.rim_diameter);
}

@override
String toString() {
  final _this = this as TyreSize;
  return 'TyreSize(width: ${_this.width}, aspect_ratio: ${_this.aspect_ratio}, rim_diameter: ${_this.rim_diameter})';
}


}

/// @nodoc
abstract mixin class $TyreSizeCopyWith<$Res>  {
  factory $TyreSizeCopyWith(TyreSize value, $Res Function(TyreSize) _then) = _$TyreSizeCopyWithImpl;
@useResult
$Res call({
 num width, num aspect_ratio, num rim_diameter
});




}
/// @nodoc
class _$TyreSizeCopyWithImpl<$Res>
    implements $TyreSizeCopyWith<$Res> {
  _$TyreSizeCopyWithImpl(this._self, this._then);

  final TyreSize _self;
  final $Res Function(TyreSize) _then;

/// Create a copy of TyreSize
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? width = null,Object? aspect_ratio = null,Object? rim_diameter = null,}) {
  return _then(TyreSize(
width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as num,aspect_ratio: null == aspect_ratio ? _self.aspect_ratio : aspect_ratio // ignore: cast_nullable_to_non_nullable
as num,rim_diameter: null == rim_diameter ? _self.rim_diameter : rim_diameter // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [TyreSize].
extension TyreSizePatterns on TyreSize {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TyreSize value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TyreSize() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TyreSize value)  $default,){
final _that = this;
switch (_that) {
case _TyreSize():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TyreSize value)?  $default,){
final _that = this;
switch (_that) {
case _TyreSize() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( num width,  num aspect_ratio,  num rim_diameter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TyreSize() when $default != null:
return $default(_that.width,_that.aspect_ratio,_that.rim_diameter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( num width,  num aspect_ratio,  num rim_diameter)  $default,) {final _that = this;
switch (_that) {
case _TyreSize():
return $default(_that.width,_that.aspect_ratio,_that.rim_diameter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( num width,  num aspect_ratio,  num rim_diameter)?  $default,) {final _that = this;
switch (_that) {
case _TyreSize() when $default != null:
return $default(_that.width,_that.aspect_ratio,_that.rim_diameter);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TyreSize implements TyreSize {
  const _TyreSize({required this.width, required this.aspect_ratio, required this.rim_diameter});
  factory _TyreSize.fromJson(Map<String, dynamic> json) => _$TyreSizeFromJson(json);

@override final  num width;
@override final  num aspect_ratio;
@override final  num rim_diameter;

/// Create a copy of TyreSize
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TyreSizeCopyWith<_TyreSize> get copyWith => __$TyreSizeCopyWithImpl<_TyreSize>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TyreSizeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TyreSize&&(identical(other.width, width) || other.width == width)&&(identical(other.aspect_ratio, aspect_ratio) || other.aspect_ratio == aspect_ratio)&&(identical(other.rim_diameter, rim_diameter) || other.rim_diameter == rim_diameter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,width,aspect_ratio,rim_diameter);
}

@override
String toString() {
    return 'TyreSize(width: $width, aspect_ratio: $aspect_ratio, rim_diameter: $rim_diameter)';
}


}

/// @nodoc
abstract mixin class _$TyreSizeCopyWith<$Res> implements $TyreSizeCopyWith<$Res> {
  factory _$TyreSizeCopyWith(_TyreSize value, $Res Function(_TyreSize) _then) = __$TyreSizeCopyWithImpl;
@override @useResult
$Res call({
 num width, num aspect_ratio, num rim_diameter
});




}
/// @nodoc
class __$TyreSizeCopyWithImpl<$Res>
    implements _$TyreSizeCopyWith<$Res> {
  __$TyreSizeCopyWithImpl(this._self, this._then);

  final _TyreSize _self;
  final $Res Function(_TyreSize) _then;

/// Create a copy of TyreSize
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? width = null,Object? aspect_ratio = null,Object? rim_diameter = null,}) {
  return _then(_TyreSize(
width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as num,aspect_ratio: null == aspect_ratio ? _self.aspect_ratio : aspect_ratio // ignore: cast_nullable_to_non_nullable
as num,rim_diameter: null == rim_diameter ? _self.rim_diameter : rim_diameter // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

// dart format on
