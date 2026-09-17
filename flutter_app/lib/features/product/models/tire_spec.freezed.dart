// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tire_spec.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TireSpec {

 num get width; num get aspect_ratio; num get rim_diameter; String get load_index; String get speed_rating; String get usage_type; bool get runflat; String get size_string;
/// Create a copy of TireSpec
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TireSpecCopyWith<TireSpec> get copyWith => _$TireSpecCopyWithImpl<TireSpec>(this as TireSpec, _$identity);

  /// Serializes this TireSpec to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TireSpec;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TireSpec&&(identical(other.width, _this.width) || other.width == _this.width)&&(identical(other.aspect_ratio, _this.aspect_ratio) || other.aspect_ratio == _this.aspect_ratio)&&(identical(other.rim_diameter, _this.rim_diameter) || other.rim_diameter == _this.rim_diameter)&&(identical(other.load_index, _this.load_index) || other.load_index == _this.load_index)&&(identical(other.speed_rating, _this.speed_rating) || other.speed_rating == _this.speed_rating)&&(identical(other.usage_type, _this.usage_type) || other.usage_type == _this.usage_type)&&(identical(other.runflat, _this.runflat) || other.runflat == _this.runflat)&&(identical(other.size_string, _this.size_string) || other.size_string == _this.size_string));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TireSpec;
  return Object.hash(runtimeType,_this.width,_this.aspect_ratio,_this.rim_diameter,_this.load_index,_this.speed_rating,_this.usage_type,_this.runflat,_this.size_string);
}

@override
String toString() {
  final _this = this as TireSpec;
  return 'TireSpec(width: ${_this.width}, aspect_ratio: ${_this.aspect_ratio}, rim_diameter: ${_this.rim_diameter}, load_index: ${_this.load_index}, speed_rating: ${_this.speed_rating}, usage_type: ${_this.usage_type}, runflat: ${_this.runflat}, size_string: ${_this.size_string})';
}


}

/// @nodoc
abstract mixin class $TireSpecCopyWith<$Res>  {
  factory $TireSpecCopyWith(TireSpec value, $Res Function(TireSpec) _then) = _$TireSpecCopyWithImpl;
@useResult
$Res call({
 num width, num aspect_ratio, num rim_diameter, String load_index, String speed_rating, String usage_type, bool runflat, String size_string
});




}
/// @nodoc
class _$TireSpecCopyWithImpl<$Res>
    implements $TireSpecCopyWith<$Res> {
  _$TireSpecCopyWithImpl(this._self, this._then);

  final TireSpec _self;
  final $Res Function(TireSpec) _then;

/// Create a copy of TireSpec
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? width = null,Object? aspect_ratio = null,Object? rim_diameter = null,Object? load_index = null,Object? speed_rating = null,Object? usage_type = null,Object? runflat = null,Object? size_string = null,}) {
  return _then(TireSpec(
width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as num,aspect_ratio: null == aspect_ratio ? _self.aspect_ratio : aspect_ratio // ignore: cast_nullable_to_non_nullable
as num,rim_diameter: null == rim_diameter ? _self.rim_diameter : rim_diameter // ignore: cast_nullable_to_non_nullable
as num,load_index: null == load_index ? _self.load_index : load_index // ignore: cast_nullable_to_non_nullable
as String,speed_rating: null == speed_rating ? _self.speed_rating : speed_rating // ignore: cast_nullable_to_non_nullable
as String,usage_type: null == usage_type ? _self.usage_type : usage_type // ignore: cast_nullable_to_non_nullable
as String,runflat: null == runflat ? _self.runflat : runflat // ignore: cast_nullable_to_non_nullable
as bool,size_string: null == size_string ? _self.size_string : size_string // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TireSpec].
extension TireSpecPatterns on TireSpec {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TireSpec value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TireSpec() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TireSpec value)  $default,){
final _that = this;
switch (_that) {
case _TireSpec():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TireSpec value)?  $default,){
final _that = this;
switch (_that) {
case _TireSpec() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( num width,  num aspect_ratio,  num rim_diameter,  String load_index,  String speed_rating,  String usage_type,  bool runflat,  String size_string)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TireSpec() when $default != null:
return $default(_that.width,_that.aspect_ratio,_that.rim_diameter,_that.load_index,_that.speed_rating,_that.usage_type,_that.runflat,_that.size_string);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( num width,  num aspect_ratio,  num rim_diameter,  String load_index,  String speed_rating,  String usage_type,  bool runflat,  String size_string)  $default,) {final _that = this;
switch (_that) {
case _TireSpec():
return $default(_that.width,_that.aspect_ratio,_that.rim_diameter,_that.load_index,_that.speed_rating,_that.usage_type,_that.runflat,_that.size_string);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( num width,  num aspect_ratio,  num rim_diameter,  String load_index,  String speed_rating,  String usage_type,  bool runflat,  String size_string)?  $default,) {final _that = this;
switch (_that) {
case _TireSpec() when $default != null:
return $default(_that.width,_that.aspect_ratio,_that.rim_diameter,_that.load_index,_that.speed_rating,_that.usage_type,_that.runflat,_that.size_string);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TireSpec implements TireSpec {
  const _TireSpec({required this.width, required this.aspect_ratio, required this.rim_diameter, required this.load_index, required this.speed_rating, required this.usage_type, required this.runflat, required this.size_string});
  factory _TireSpec.fromJson(Map<String, dynamic> json) => _$TireSpecFromJson(json);

@override final  num width;
@override final  num aspect_ratio;
@override final  num rim_diameter;
@override final  String load_index;
@override final  String speed_rating;
@override final  String usage_type;
@override final  bool runflat;
@override final  String size_string;

/// Create a copy of TireSpec
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TireSpecCopyWith<_TireSpec> get copyWith => __$TireSpecCopyWithImpl<_TireSpec>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TireSpecToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TireSpec&&(identical(other.width, width) || other.width == width)&&(identical(other.aspect_ratio, aspect_ratio) || other.aspect_ratio == aspect_ratio)&&(identical(other.rim_diameter, rim_diameter) || other.rim_diameter == rim_diameter)&&(identical(other.load_index, load_index) || other.load_index == load_index)&&(identical(other.speed_rating, speed_rating) || other.speed_rating == speed_rating)&&(identical(other.usage_type, usage_type) || other.usage_type == usage_type)&&(identical(other.runflat, runflat) || other.runflat == runflat)&&(identical(other.size_string, size_string) || other.size_string == size_string));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,width,aspect_ratio,rim_diameter,load_index,speed_rating,usage_type,runflat,size_string);
}

@override
String toString() {
    return 'TireSpec(width: $width, aspect_ratio: $aspect_ratio, rim_diameter: $rim_diameter, load_index: $load_index, speed_rating: $speed_rating, usage_type: $usage_type, runflat: $runflat, size_string: $size_string)';
}


}

/// @nodoc
abstract mixin class _$TireSpecCopyWith<$Res> implements $TireSpecCopyWith<$Res> {
  factory _$TireSpecCopyWith(_TireSpec value, $Res Function(_TireSpec) _then) = __$TireSpecCopyWithImpl;
@override @useResult
$Res call({
 num width, num aspect_ratio, num rim_diameter, String load_index, String speed_rating, String usage_type, bool runflat, String size_string
});




}
/// @nodoc
class __$TireSpecCopyWithImpl<$Res>
    implements _$TireSpecCopyWith<$Res> {
  __$TireSpecCopyWithImpl(this._self, this._then);

  final _TireSpec _self;
  final $Res Function(_TireSpec) _then;

/// Create a copy of TireSpec
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? width = null,Object? aspect_ratio = null,Object? rim_diameter = null,Object? load_index = null,Object? speed_rating = null,Object? usage_type = null,Object? runflat = null,Object? size_string = null,}) {
  return _then(_TireSpec(
width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as num,aspect_ratio: null == aspect_ratio ? _self.aspect_ratio : aspect_ratio // ignore: cast_nullable_to_non_nullable
as num,rim_diameter: null == rim_diameter ? _self.rim_diameter : rim_diameter // ignore: cast_nullable_to_non_nullable
as num,load_index: null == load_index ? _self.load_index : load_index // ignore: cast_nullable_to_non_nullable
as String,speed_rating: null == speed_rating ? _self.speed_rating : speed_rating // ignore: cast_nullable_to_non_nullable
as String,usage_type: null == usage_type ? _self.usage_type : usage_type // ignore: cast_nullable_to_non_nullable
as String,runflat: null == runflat ? _self.runflat : runflat // ignore: cast_nullable_to_non_nullable
as bool,size_string: null == size_string ? _self.size_string : size_string // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
