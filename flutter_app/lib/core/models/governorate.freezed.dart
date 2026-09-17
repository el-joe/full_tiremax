// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'governorate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Governorate {

 int get id; String get code; String get name; bool get is_basra; num get shipping_fee;
/// Create a copy of Governorate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GovernorateCopyWith<Governorate> get copyWith => _$GovernorateCopyWithImpl<Governorate>(this as Governorate, _$identity);

  /// Serializes this Governorate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Governorate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Governorate&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.is_basra, _this.is_basra) || other.is_basra == _this.is_basra)&&(identical(other.shipping_fee, _this.shipping_fee) || other.shipping_fee == _this.shipping_fee));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Governorate;
  return Object.hash(runtimeType,_this.id,_this.code,_this.name,_this.is_basra,_this.shipping_fee);
}

@override
String toString() {
  final _this = this as Governorate;
  return 'Governorate(id: ${_this.id}, code: ${_this.code}, name: ${_this.name}, is_basra: ${_this.is_basra}, shipping_fee: ${_this.shipping_fee})';
}


}

/// @nodoc
abstract mixin class $GovernorateCopyWith<$Res>  {
  factory $GovernorateCopyWith(Governorate value, $Res Function(Governorate) _then) = _$GovernorateCopyWithImpl;
@useResult
$Res call({
 int id, String code, String name, bool is_basra, num shipping_fee
});




}
/// @nodoc
class _$GovernorateCopyWithImpl<$Res>
    implements $GovernorateCopyWith<$Res> {
  _$GovernorateCopyWithImpl(this._self, this._then);

  final Governorate _self;
  final $Res Function(Governorate) _then;

/// Create a copy of Governorate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? is_basra = null,Object? shipping_fee = null,}) {
  return _then(Governorate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,is_basra: null == is_basra ? _self.is_basra : is_basra // ignore: cast_nullable_to_non_nullable
as bool,shipping_fee: null == shipping_fee ? _self.shipping_fee : shipping_fee // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [Governorate].
extension GovernoratePatterns on Governorate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Governorate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Governorate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Governorate value)  $default,){
final _that = this;
switch (_that) {
case _Governorate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Governorate value)?  $default,){
final _that = this;
switch (_that) {
case _Governorate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String code,  String name,  bool is_basra,  num shipping_fee)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Governorate() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.is_basra,_that.shipping_fee);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String code,  String name,  bool is_basra,  num shipping_fee)  $default,) {final _that = this;
switch (_that) {
case _Governorate():
return $default(_that.id,_that.code,_that.name,_that.is_basra,_that.shipping_fee);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String code,  String name,  bool is_basra,  num shipping_fee)?  $default,) {final _that = this;
switch (_that) {
case _Governorate() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.is_basra,_that.shipping_fee);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Governorate implements Governorate {
  const _Governorate({required this.id, required this.code, required this.name, required this.is_basra, required this.shipping_fee});
  factory _Governorate.fromJson(Map<String, dynamic> json) => _$GovernorateFromJson(json);

@override final  int id;
@override final  String code;
@override final  String name;
@override final  bool is_basra;
@override final  num shipping_fee;

/// Create a copy of Governorate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GovernorateCopyWith<_Governorate> get copyWith => __$GovernorateCopyWithImpl<_Governorate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GovernorateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Governorate&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.is_basra, is_basra) || other.is_basra == is_basra)&&(identical(other.shipping_fee, shipping_fee) || other.shipping_fee == shipping_fee));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,name,is_basra,shipping_fee);
}

@override
String toString() {
    return 'Governorate(id: $id, code: $code, name: $name, is_basra: $is_basra, shipping_fee: $shipping_fee)';
}


}

/// @nodoc
abstract mixin class _$GovernorateCopyWith<$Res> implements $GovernorateCopyWith<$Res> {
  factory _$GovernorateCopyWith(_Governorate value, $Res Function(_Governorate) _then) = __$GovernorateCopyWithImpl;
@override @useResult
$Res call({
 int id, String code, String name, bool is_basra, num shipping_fee
});




}
/// @nodoc
class __$GovernorateCopyWithImpl<$Res>
    implements _$GovernorateCopyWith<$Res> {
  __$GovernorateCopyWithImpl(this._self, this._then);

  final _Governorate _self;
  final $Res Function(_Governorate) _then;

/// Create a copy of Governorate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? is_basra = null,Object? shipping_fee = null,}) {
  return _then(_Governorate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,is_basra: null == is_basra ? _self.is_basra : is_basra // ignore: cast_nullable_to_non_nullable
as bool,shipping_fee: null == shipping_fee ? _self.shipping_fee : shipping_fee // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

// dart format on
