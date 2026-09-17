// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'year_vehicle_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$YearVehicleModel {

 int get id; int get vehicle_model_id; int get year_from; int get year_to; String? get trim_code; String? get trim_name; String? get engine; String? get notes;
/// Create a copy of YearVehicleModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YearVehicleModelCopyWith<YearVehicleModel> get copyWith => _$YearVehicleModelCopyWithImpl<YearVehicleModel>(this as YearVehicleModel, _$identity);

  /// Serializes this YearVehicleModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as YearVehicleModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YearVehicleModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.vehicle_model_id, _this.vehicle_model_id) || other.vehicle_model_id == _this.vehicle_model_id)&&(identical(other.year_from, _this.year_from) || other.year_from == _this.year_from)&&(identical(other.year_to, _this.year_to) || other.year_to == _this.year_to)&&(identical(other.trim_code, _this.trim_code) || other.trim_code == _this.trim_code)&&(identical(other.trim_name, _this.trim_name) || other.trim_name == _this.trim_name)&&(identical(other.engine, _this.engine) || other.engine == _this.engine)&&(identical(other.notes, _this.notes) || other.notes == _this.notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as YearVehicleModel;
  return Object.hash(runtimeType,_this.id,_this.vehicle_model_id,_this.year_from,_this.year_to,_this.trim_code,_this.trim_name,_this.engine,_this.notes);
}

@override
String toString() {
  final _this = this as YearVehicleModel;
  return 'YearVehicleModel(id: ${_this.id}, vehicle_model_id: ${_this.vehicle_model_id}, year_from: ${_this.year_from}, year_to: ${_this.year_to}, trim_code: ${_this.trim_code}, trim_name: ${_this.trim_name}, engine: ${_this.engine}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $YearVehicleModelCopyWith<$Res>  {
  factory $YearVehicleModelCopyWith(YearVehicleModel value, $Res Function(YearVehicleModel) _then) = _$YearVehicleModelCopyWithImpl;
@useResult
$Res call({
 int id, int vehicle_model_id, int year_from, int year_to, String? trim_code, String? trim_name, String? engine, String? notes
});




}
/// @nodoc
class _$YearVehicleModelCopyWithImpl<$Res>
    implements $YearVehicleModelCopyWith<$Res> {
  _$YearVehicleModelCopyWithImpl(this._self, this._then);

  final YearVehicleModel _self;
  final $Res Function(YearVehicleModel) _then;

/// Create a copy of YearVehicleModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? vehicle_model_id = null,Object? year_from = null,Object? year_to = null,Object? trim_code = freezed,Object? trim_name = freezed,Object? engine = freezed,Object? notes = freezed,}) {
  return _then(YearVehicleModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,vehicle_model_id: null == vehicle_model_id ? _self.vehicle_model_id : vehicle_model_id // ignore: cast_nullable_to_non_nullable
as int,year_from: null == year_from ? _self.year_from : year_from // ignore: cast_nullable_to_non_nullable
as int,year_to: null == year_to ? _self.year_to : year_to // ignore: cast_nullable_to_non_nullable
as int,trim_code: freezed == trim_code ? _self.trim_code : trim_code // ignore: cast_nullable_to_non_nullable
as String?,trim_name: freezed == trim_name ? _self.trim_name : trim_name // ignore: cast_nullable_to_non_nullable
as String?,engine: freezed == engine ? _self.engine : engine // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [YearVehicleModel].
extension YearVehicleModelPatterns on YearVehicleModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YearVehicleModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YearVehicleModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YearVehicleModel value)  $default,){
final _that = this;
switch (_that) {
case _YearVehicleModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YearVehicleModel value)?  $default,){
final _that = this;
switch (_that) {
case _YearVehicleModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int vehicle_model_id,  int year_from,  int year_to,  String? trim_code,  String? trim_name,  String? engine,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _YearVehicleModel() when $default != null:
return $default(_that.id,_that.vehicle_model_id,_that.year_from,_that.year_to,_that.trim_code,_that.trim_name,_that.engine,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int vehicle_model_id,  int year_from,  int year_to,  String? trim_code,  String? trim_name,  String? engine,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _YearVehicleModel():
return $default(_that.id,_that.vehicle_model_id,_that.year_from,_that.year_to,_that.trim_code,_that.trim_name,_that.engine,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int vehicle_model_id,  int year_from,  int year_to,  String? trim_code,  String? trim_name,  String? engine,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _YearVehicleModel() when $default != null:
return $default(_that.id,_that.vehicle_model_id,_that.year_from,_that.year_to,_that.trim_code,_that.trim_name,_that.engine,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _YearVehicleModel implements YearVehicleModel {
  const _YearVehicleModel({required this.id, required this.vehicle_model_id, required this.year_from, required this.year_to, this.trim_code, this.trim_name, this.engine, this.notes});
  factory _YearVehicleModel.fromJson(Map<String, dynamic> json) => _$YearVehicleModelFromJson(json);

@override final  int id;
@override final  int vehicle_model_id;
@override final  int year_from;
@override final  int year_to;
@override final  String? trim_code;
@override final  String? trim_name;
@override final  String? engine;
@override final  String? notes;

/// Create a copy of YearVehicleModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YearVehicleModelCopyWith<_YearVehicleModel> get copyWith => __$YearVehicleModelCopyWithImpl<_YearVehicleModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$YearVehicleModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _YearVehicleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.vehicle_model_id, vehicle_model_id) || other.vehicle_model_id == vehicle_model_id)&&(identical(other.year_from, year_from) || other.year_from == year_from)&&(identical(other.year_to, year_to) || other.year_to == year_to)&&(identical(other.trim_code, trim_code) || other.trim_code == trim_code)&&(identical(other.trim_name, trim_name) || other.trim_name == trim_name)&&(identical(other.engine, engine) || other.engine == engine)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,vehicle_model_id,year_from,year_to,trim_code,trim_name,engine,notes);
}

@override
String toString() {
    return 'YearVehicleModel(id: $id, vehicle_model_id: $vehicle_model_id, year_from: $year_from, year_to: $year_to, trim_code: $trim_code, trim_name: $trim_name, engine: $engine, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$YearVehicleModelCopyWith<$Res> implements $YearVehicleModelCopyWith<$Res> {
  factory _$YearVehicleModelCopyWith(_YearVehicleModel value, $Res Function(_YearVehicleModel) _then) = __$YearVehicleModelCopyWithImpl;
@override @useResult
$Res call({
 int id, int vehicle_model_id, int year_from, int year_to, String? trim_code, String? trim_name, String? engine, String? notes
});




}
/// @nodoc
class __$YearVehicleModelCopyWithImpl<$Res>
    implements _$YearVehicleModelCopyWith<$Res> {
  __$YearVehicleModelCopyWithImpl(this._self, this._then);

  final _YearVehicleModel _self;
  final $Res Function(_YearVehicleModel) _then;

/// Create a copy of YearVehicleModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? vehicle_model_id = null,Object? year_from = null,Object? year_to = null,Object? trim_code = freezed,Object? trim_name = freezed,Object? engine = freezed,Object? notes = freezed,}) {
  return _then(_YearVehicleModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,vehicle_model_id: null == vehicle_model_id ? _self.vehicle_model_id : vehicle_model_id // ignore: cast_nullable_to_non_nullable
as int,year_from: null == year_from ? _self.year_from : year_from // ignore: cast_nullable_to_non_nullable
as int,year_to: null == year_to ? _self.year_to : year_to // ignore: cast_nullable_to_non_nullable
as int,trim_code: freezed == trim_code ? _self.trim_code : trim_code // ignore: cast_nullable_to_non_nullable
as String?,trim_name: freezed == trim_name ? _self.trim_name : trim_name // ignore: cast_nullable_to_non_nullable
as String?,engine: freezed == engine ? _self.engine : engine // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
