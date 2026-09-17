// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'battery_spec.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BatterySpec {

 num get voltage; num get ampere_hour; num get cca; String get battery_type; String get terminal_position; String get size_code;
/// Create a copy of BatterySpec
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BatterySpecCopyWith<BatterySpec> get copyWith => _$BatterySpecCopyWithImpl<BatterySpec>(this as BatterySpec, _$identity);

  /// Serializes this BatterySpec to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BatterySpec;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BatterySpec&&(identical(other.voltage, _this.voltage) || other.voltage == _this.voltage)&&(identical(other.ampere_hour, _this.ampere_hour) || other.ampere_hour == _this.ampere_hour)&&(identical(other.cca, _this.cca) || other.cca == _this.cca)&&(identical(other.battery_type, _this.battery_type) || other.battery_type == _this.battery_type)&&(identical(other.terminal_position, _this.terminal_position) || other.terminal_position == _this.terminal_position)&&(identical(other.size_code, _this.size_code) || other.size_code == _this.size_code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BatterySpec;
  return Object.hash(runtimeType,_this.voltage,_this.ampere_hour,_this.cca,_this.battery_type,_this.terminal_position,_this.size_code);
}

@override
String toString() {
  final _this = this as BatterySpec;
  return 'BatterySpec(voltage: ${_this.voltage}, ampere_hour: ${_this.ampere_hour}, cca: ${_this.cca}, battery_type: ${_this.battery_type}, terminal_position: ${_this.terminal_position}, size_code: ${_this.size_code})';
}


}

/// @nodoc
abstract mixin class $BatterySpecCopyWith<$Res>  {
  factory $BatterySpecCopyWith(BatterySpec value, $Res Function(BatterySpec) _then) = _$BatterySpecCopyWithImpl;
@useResult
$Res call({
 num voltage, num ampere_hour, num cca, String battery_type, String terminal_position, String size_code
});




}
/// @nodoc
class _$BatterySpecCopyWithImpl<$Res>
    implements $BatterySpecCopyWith<$Res> {
  _$BatterySpecCopyWithImpl(this._self, this._then);

  final BatterySpec _self;
  final $Res Function(BatterySpec) _then;

/// Create a copy of BatterySpec
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? voltage = null,Object? ampere_hour = null,Object? cca = null,Object? battery_type = null,Object? terminal_position = null,Object? size_code = null,}) {
  return _then(BatterySpec(
voltage: null == voltage ? _self.voltage : voltage // ignore: cast_nullable_to_non_nullable
as num,ampere_hour: null == ampere_hour ? _self.ampere_hour : ampere_hour // ignore: cast_nullable_to_non_nullable
as num,cca: null == cca ? _self.cca : cca // ignore: cast_nullable_to_non_nullable
as num,battery_type: null == battery_type ? _self.battery_type : battery_type // ignore: cast_nullable_to_non_nullable
as String,terminal_position: null == terminal_position ? _self.terminal_position : terminal_position // ignore: cast_nullable_to_non_nullable
as String,size_code: null == size_code ? _self.size_code : size_code // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BatterySpec].
extension BatterySpecPatterns on BatterySpec {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BatterySpec value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BatterySpec() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BatterySpec value)  $default,){
final _that = this;
switch (_that) {
case _BatterySpec():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BatterySpec value)?  $default,){
final _that = this;
switch (_that) {
case _BatterySpec() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( num voltage,  num ampere_hour,  num cca,  String battery_type,  String terminal_position,  String size_code)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BatterySpec() when $default != null:
return $default(_that.voltage,_that.ampere_hour,_that.cca,_that.battery_type,_that.terminal_position,_that.size_code);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( num voltage,  num ampere_hour,  num cca,  String battery_type,  String terminal_position,  String size_code)  $default,) {final _that = this;
switch (_that) {
case _BatterySpec():
return $default(_that.voltage,_that.ampere_hour,_that.cca,_that.battery_type,_that.terminal_position,_that.size_code);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( num voltage,  num ampere_hour,  num cca,  String battery_type,  String terminal_position,  String size_code)?  $default,) {final _that = this;
switch (_that) {
case _BatterySpec() when $default != null:
return $default(_that.voltage,_that.ampere_hour,_that.cca,_that.battery_type,_that.terminal_position,_that.size_code);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BatterySpec implements BatterySpec {
  const _BatterySpec({required this.voltage, required this.ampere_hour, required this.cca, required this.battery_type, required this.terminal_position, required this.size_code});
  factory _BatterySpec.fromJson(Map<String, dynamic> json) => _$BatterySpecFromJson(json);

@override final  num voltage;
@override final  num ampere_hour;
@override final  num cca;
@override final  String battery_type;
@override final  String terminal_position;
@override final  String size_code;

/// Create a copy of BatterySpec
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BatterySpecCopyWith<_BatterySpec> get copyWith => __$BatterySpecCopyWithImpl<_BatterySpec>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BatterySpecToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BatterySpec&&(identical(other.voltage, voltage) || other.voltage == voltage)&&(identical(other.ampere_hour, ampere_hour) || other.ampere_hour == ampere_hour)&&(identical(other.cca, cca) || other.cca == cca)&&(identical(other.battery_type, battery_type) || other.battery_type == battery_type)&&(identical(other.terminal_position, terminal_position) || other.terminal_position == terminal_position)&&(identical(other.size_code, size_code) || other.size_code == size_code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,voltage,ampere_hour,cca,battery_type,terminal_position,size_code);
}

@override
String toString() {
    return 'BatterySpec(voltage: $voltage, ampere_hour: $ampere_hour, cca: $cca, battery_type: $battery_type, terminal_position: $terminal_position, size_code: $size_code)';
}


}

/// @nodoc
abstract mixin class _$BatterySpecCopyWith<$Res> implements $BatterySpecCopyWith<$Res> {
  factory _$BatterySpecCopyWith(_BatterySpec value, $Res Function(_BatterySpec) _then) = __$BatterySpecCopyWithImpl;
@override @useResult
$Res call({
 num voltage, num ampere_hour, num cca, String battery_type, String terminal_position, String size_code
});




}
/// @nodoc
class __$BatterySpecCopyWithImpl<$Res>
    implements _$BatterySpecCopyWith<$Res> {
  __$BatterySpecCopyWithImpl(this._self, this._then);

  final _BatterySpec _self;
  final $Res Function(_BatterySpec) _then;

/// Create a copy of BatterySpec
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? voltage = null,Object? ampere_hour = null,Object? cca = null,Object? battery_type = null,Object? terminal_position = null,Object? size_code = null,}) {
  return _then(_BatterySpec(
voltage: null == voltage ? _self.voltage : voltage // ignore: cast_nullable_to_non_nullable
as num,ampere_hour: null == ampere_hour ? _self.ampere_hour : ampere_hour // ignore: cast_nullable_to_non_nullable
as num,cca: null == cca ? _self.cca : cca // ignore: cast_nullable_to_non_nullable
as num,battery_type: null == battery_type ? _self.battery_type : battery_type // ignore: cast_nullable_to_non_nullable
as String,terminal_position: null == terminal_position ? _self.terminal_position : terminal_position // ignore: cast_nullable_to_non_nullable
as String,size_code: null == size_code ? _self.size_code : size_code // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
