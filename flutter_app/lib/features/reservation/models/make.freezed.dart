// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'make.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Make {

 int get id; String get slug; String get name; String? get logo;
/// Create a copy of Make
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MakeCopyWith<Make> get copyWith => _$MakeCopyWithImpl<Make>(this as Make, _$identity);

  /// Serializes this Make to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Make;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Make&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.logo, _this.logo) || other.logo == _this.logo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Make;
  return Object.hash(runtimeType,_this.id,_this.slug,_this.name,_this.logo);
}

@override
String toString() {
  final _this = this as Make;
  return 'Make(id: ${_this.id}, slug: ${_this.slug}, name: ${_this.name}, logo: ${_this.logo})';
}


}

/// @nodoc
abstract mixin class $MakeCopyWith<$Res>  {
  factory $MakeCopyWith(Make value, $Res Function(Make) _then) = _$MakeCopyWithImpl;
@useResult
$Res call({
 int id, String slug, String name, String? logo
});




}
/// @nodoc
class _$MakeCopyWithImpl<$Res>
    implements $MakeCopyWith<$Res> {
  _$MakeCopyWithImpl(this._self, this._then);

  final Make _self;
  final $Res Function(Make) _then;

/// Create a copy of Make
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? logo = freezed,}) {
  return _then(Make(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Make].
extension MakePatterns on Make {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Make value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Make() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Make value)  $default,){
final _that = this;
switch (_that) {
case _Make():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Make value)?  $default,){
final _that = this;
switch (_that) {
case _Make() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String slug,  String name,  String? logo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Make() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.logo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String slug,  String name,  String? logo)  $default,) {final _that = this;
switch (_that) {
case _Make():
return $default(_that.id,_that.slug,_that.name,_that.logo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String slug,  String name,  String? logo)?  $default,) {final _that = this;
switch (_that) {
case _Make() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.logo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Make implements Make {
  const _Make({required this.id, required this.slug, required this.name, this.logo});
  factory _Make.fromJson(Map<String, dynamic> json) => _$MakeFromJson(json);

@override final  int id;
@override final  String slug;
@override final  String name;
@override final  String? logo;

/// Create a copy of Make
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MakeCopyWith<_Make> get copyWith => __$MakeCopyWithImpl<_Make>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MakeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Make&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.logo, logo) || other.logo == logo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,slug,name,logo);
}

@override
String toString() {
    return 'Make(id: $id, slug: $slug, name: $name, logo: $logo)';
}


}

/// @nodoc
abstract mixin class _$MakeCopyWith<$Res> implements $MakeCopyWith<$Res> {
  factory _$MakeCopyWith(_Make value, $Res Function(_Make) _then) = __$MakeCopyWithImpl;
@override @useResult
$Res call({
 int id, String slug, String name, String? logo
});




}
/// @nodoc
class __$MakeCopyWithImpl<$Res>
    implements _$MakeCopyWith<$Res> {
  __$MakeCopyWithImpl(this._self, this._then);

  final _Make _self;
  final $Res Function(_Make) _then;

/// Create a copy of Make
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? logo = freezed,}) {
  return _then(_Make(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
