// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Vehicle {

 int get id; int get vehicle_model_id; int get year_from; int get year_to; String? get trim_code; String? get trim_name; String? get engine; String? get notes; VehicleModelSummary get model;
/// Create a copy of Vehicle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VehicleCopyWith<Vehicle> get copyWith => _$VehicleCopyWithImpl<Vehicle>(this as Vehicle, _$identity);

  /// Serializes this Vehicle to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Vehicle;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Vehicle&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.vehicle_model_id, _this.vehicle_model_id) || other.vehicle_model_id == _this.vehicle_model_id)&&(identical(other.year_from, _this.year_from) || other.year_from == _this.year_from)&&(identical(other.year_to, _this.year_to) || other.year_to == _this.year_to)&&(identical(other.trim_code, _this.trim_code) || other.trim_code == _this.trim_code)&&(identical(other.trim_name, _this.trim_name) || other.trim_name == _this.trim_name)&&(identical(other.engine, _this.engine) || other.engine == _this.engine)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.model, _this.model) || other.model == _this.model));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Vehicle;
  return Object.hash(runtimeType,_this.id,_this.vehicle_model_id,_this.year_from,_this.year_to,_this.trim_code,_this.trim_name,_this.engine,_this.notes,_this.model);
}

@override
String toString() {
  final _this = this as Vehicle;
  return 'Vehicle(id: ${_this.id}, vehicle_model_id: ${_this.vehicle_model_id}, year_from: ${_this.year_from}, year_to: ${_this.year_to}, trim_code: ${_this.trim_code}, trim_name: ${_this.trim_name}, engine: ${_this.engine}, notes: ${_this.notes}, model: ${_this.model})';
}


}

/// @nodoc
abstract mixin class $VehicleCopyWith<$Res>  {
  factory $VehicleCopyWith(Vehicle value, $Res Function(Vehicle) _then) = _$VehicleCopyWithImpl;
@useResult
$Res call({
 int id, int vehicle_model_id, int year_from, int year_to, String? trim_code, String? trim_name, String? engine, String? notes, VehicleModelSummary model
});


$VehicleModelSummaryCopyWith<$Res> get model;

}
/// @nodoc
class _$VehicleCopyWithImpl<$Res>
    implements $VehicleCopyWith<$Res> {
  _$VehicleCopyWithImpl(this._self, this._then);

  final Vehicle _self;
  final $Res Function(Vehicle) _then;

/// Create a copy of Vehicle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? vehicle_model_id = null,Object? year_from = null,Object? year_to = null,Object? trim_code = freezed,Object? trim_name = freezed,Object? engine = freezed,Object? notes = freezed,Object? model = null,}) {
  return _then(Vehicle(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,vehicle_model_id: null == vehicle_model_id ? _self.vehicle_model_id : vehicle_model_id // ignore: cast_nullable_to_non_nullable
as int,year_from: null == year_from ? _self.year_from : year_from // ignore: cast_nullable_to_non_nullable
as int,year_to: null == year_to ? _self.year_to : year_to // ignore: cast_nullable_to_non_nullable
as int,trim_code: freezed == trim_code ? _self.trim_code : trim_code // ignore: cast_nullable_to_non_nullable
as String?,trim_name: freezed == trim_name ? _self.trim_name : trim_name // ignore: cast_nullable_to_non_nullable
as String?,engine: freezed == engine ? _self.engine : engine // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as VehicleModelSummary,
  ));
}
/// Create a copy of Vehicle
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VehicleModelSummaryCopyWith<$Res> get model {
  
  return $VehicleModelSummaryCopyWith<$Res>(_self.model, (value) {
    return _then(_self.copyWith(model: value));
  });
}
}


/// Adds pattern-matching-related methods to [Vehicle].
extension VehiclePatterns on Vehicle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Vehicle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Vehicle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Vehicle value)  $default,){
final _that = this;
switch (_that) {
case _Vehicle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Vehicle value)?  $default,){
final _that = this;
switch (_that) {
case _Vehicle() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int vehicle_model_id,  int year_from,  int year_to,  String? trim_code,  String? trim_name,  String? engine,  String? notes,  VehicleModelSummary model)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Vehicle() when $default != null:
return $default(_that.id,_that.vehicle_model_id,_that.year_from,_that.year_to,_that.trim_code,_that.trim_name,_that.engine,_that.notes,_that.model);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int vehicle_model_id,  int year_from,  int year_to,  String? trim_code,  String? trim_name,  String? engine,  String? notes,  VehicleModelSummary model)  $default,) {final _that = this;
switch (_that) {
case _Vehicle():
return $default(_that.id,_that.vehicle_model_id,_that.year_from,_that.year_to,_that.trim_code,_that.trim_name,_that.engine,_that.notes,_that.model);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int vehicle_model_id,  int year_from,  int year_to,  String? trim_code,  String? trim_name,  String? engine,  String? notes,  VehicleModelSummary model)?  $default,) {final _that = this;
switch (_that) {
case _Vehicle() when $default != null:
return $default(_that.id,_that.vehicle_model_id,_that.year_from,_that.year_to,_that.trim_code,_that.trim_name,_that.engine,_that.notes,_that.model);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Vehicle implements Vehicle {
  const _Vehicle({required this.id, required this.vehicle_model_id, required this.year_from, required this.year_to, this.trim_code, this.trim_name, this.engine, this.notes, required this.model});
  factory _Vehicle.fromJson(Map<String, dynamic> json) => _$VehicleFromJson(json);

@override final  int id;
@override final  int vehicle_model_id;
@override final  int year_from;
@override final  int year_to;
@override final  String? trim_code;
@override final  String? trim_name;
@override final  String? engine;
@override final  String? notes;
@override final  VehicleModelSummary model;

/// Create a copy of Vehicle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VehicleCopyWith<_Vehicle> get copyWith => __$VehicleCopyWithImpl<_Vehicle>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VehicleToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Vehicle&&(identical(other.id, id) || other.id == id)&&(identical(other.vehicle_model_id, vehicle_model_id) || other.vehicle_model_id == vehicle_model_id)&&(identical(other.year_from, year_from) || other.year_from == year_from)&&(identical(other.year_to, year_to) || other.year_to == year_to)&&(identical(other.trim_code, trim_code) || other.trim_code == trim_code)&&(identical(other.trim_name, trim_name) || other.trim_name == trim_name)&&(identical(other.engine, engine) || other.engine == engine)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.model, model) || other.model == model));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,vehicle_model_id,year_from,year_to,trim_code,trim_name,engine,notes,model);
}

@override
String toString() {
    return 'Vehicle(id: $id, vehicle_model_id: $vehicle_model_id, year_from: $year_from, year_to: $year_to, trim_code: $trim_code, trim_name: $trim_name, engine: $engine, notes: $notes, model: $model)';
}


}

/// @nodoc
abstract mixin class _$VehicleCopyWith<$Res> implements $VehicleCopyWith<$Res> {
  factory _$VehicleCopyWith(_Vehicle value, $Res Function(_Vehicle) _then) = __$VehicleCopyWithImpl;
@override @useResult
$Res call({
 int id, int vehicle_model_id, int year_from, int year_to, String? trim_code, String? trim_name, String? engine, String? notes, VehicleModelSummary model
});


@override $VehicleModelSummaryCopyWith<$Res> get model;

}
/// @nodoc
class __$VehicleCopyWithImpl<$Res>
    implements _$VehicleCopyWith<$Res> {
  __$VehicleCopyWithImpl(this._self, this._then);

  final _Vehicle _self;
  final $Res Function(_Vehicle) _then;

/// Create a copy of Vehicle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? vehicle_model_id = null,Object? year_from = null,Object? year_to = null,Object? trim_code = freezed,Object? trim_name = freezed,Object? engine = freezed,Object? notes = freezed,Object? model = null,}) {
  return _then(_Vehicle(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,vehicle_model_id: null == vehicle_model_id ? _self.vehicle_model_id : vehicle_model_id // ignore: cast_nullable_to_non_nullable
as int,year_from: null == year_from ? _self.year_from : year_from // ignore: cast_nullable_to_non_nullable
as int,year_to: null == year_to ? _self.year_to : year_to // ignore: cast_nullable_to_non_nullable
as int,trim_code: freezed == trim_code ? _self.trim_code : trim_code // ignore: cast_nullable_to_non_nullable
as String?,trim_name: freezed == trim_name ? _self.trim_name : trim_name // ignore: cast_nullable_to_non_nullable
as String?,engine: freezed == engine ? _self.engine : engine // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as VehicleModelSummary,
  ));
}

/// Create a copy of Vehicle
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VehicleModelSummaryCopyWith<$Res> get model {
  
  return $VehicleModelSummaryCopyWith<$Res>(_self.model, (value) {
    return _then(_self.copyWith(model: value));
  });
}
}


/// @nodoc
mixin _$VehicleModelSummary {

 int get id; String get slug; String get name; int get vehicle_make_id;
/// Create a copy of VehicleModelSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VehicleModelSummaryCopyWith<VehicleModelSummary> get copyWith => _$VehicleModelSummaryCopyWithImpl<VehicleModelSummary>(this as VehicleModelSummary, _$identity);

  /// Serializes this VehicleModelSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as VehicleModelSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VehicleModelSummary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.vehicle_make_id, _this.vehicle_make_id) || other.vehicle_make_id == _this.vehicle_make_id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as VehicleModelSummary;
  return Object.hash(runtimeType,_this.id,_this.slug,_this.name,_this.vehicle_make_id);
}

@override
String toString() {
  final _this = this as VehicleModelSummary;
  return 'VehicleModelSummary(id: ${_this.id}, slug: ${_this.slug}, name: ${_this.name}, vehicle_make_id: ${_this.vehicle_make_id})';
}


}

/// @nodoc
abstract mixin class $VehicleModelSummaryCopyWith<$Res>  {
  factory $VehicleModelSummaryCopyWith(VehicleModelSummary value, $Res Function(VehicleModelSummary) _then) = _$VehicleModelSummaryCopyWithImpl;
@useResult
$Res call({
 int id, String slug, String name, int vehicle_make_id
});




}
/// @nodoc
class _$VehicleModelSummaryCopyWithImpl<$Res>
    implements $VehicleModelSummaryCopyWith<$Res> {
  _$VehicleModelSummaryCopyWithImpl(this._self, this._then);

  final VehicleModelSummary _self;
  final $Res Function(VehicleModelSummary) _then;

/// Create a copy of VehicleModelSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? vehicle_make_id = null,}) {
  return _then(VehicleModelSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,vehicle_make_id: null == vehicle_make_id ? _self.vehicle_make_id : vehicle_make_id // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [VehicleModelSummary].
extension VehicleModelSummaryPatterns on VehicleModelSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VehicleModelSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VehicleModelSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VehicleModelSummary value)  $default,){
final _that = this;
switch (_that) {
case _VehicleModelSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VehicleModelSummary value)?  $default,){
final _that = this;
switch (_that) {
case _VehicleModelSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String slug,  String name,  int vehicle_make_id)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VehicleModelSummary() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.vehicle_make_id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String slug,  String name,  int vehicle_make_id)  $default,) {final _that = this;
switch (_that) {
case _VehicleModelSummary():
return $default(_that.id,_that.slug,_that.name,_that.vehicle_make_id);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String slug,  String name,  int vehicle_make_id)?  $default,) {final _that = this;
switch (_that) {
case _VehicleModelSummary() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.vehicle_make_id);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VehicleModelSummary implements VehicleModelSummary {
  const _VehicleModelSummary({required this.id, required this.slug, required this.name, required this.vehicle_make_id});
  factory _VehicleModelSummary.fromJson(Map<String, dynamic> json) => _$VehicleModelSummaryFromJson(json);

@override final  int id;
@override final  String slug;
@override final  String name;
@override final  int vehicle_make_id;

/// Create a copy of VehicleModelSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VehicleModelSummaryCopyWith<_VehicleModelSummary> get copyWith => __$VehicleModelSummaryCopyWithImpl<_VehicleModelSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VehicleModelSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VehicleModelSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.vehicle_make_id, vehicle_make_id) || other.vehicle_make_id == vehicle_make_id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,slug,name,vehicle_make_id);
}

@override
String toString() {
    return 'VehicleModelSummary(id: $id, slug: $slug, name: $name, vehicle_make_id: $vehicle_make_id)';
}


}

/// @nodoc
abstract mixin class _$VehicleModelSummaryCopyWith<$Res> implements $VehicleModelSummaryCopyWith<$Res> {
  factory _$VehicleModelSummaryCopyWith(_VehicleModelSummary value, $Res Function(_VehicleModelSummary) _then) = __$VehicleModelSummaryCopyWithImpl;
@override @useResult
$Res call({
 int id, String slug, String name, int vehicle_make_id
});




}
/// @nodoc
class __$VehicleModelSummaryCopyWithImpl<$Res>
    implements _$VehicleModelSummaryCopyWith<$Res> {
  __$VehicleModelSummaryCopyWithImpl(this._self, this._then);

  final _VehicleModelSummary _self;
  final $Res Function(_VehicleModelSummary) _then;

/// Create a copy of VehicleModelSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? vehicle_make_id = null,}) {
  return _then(_VehicleModelSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,vehicle_make_id: null == vehicle_make_id ? _self.vehicle_make_id : vehicle_make_id // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
