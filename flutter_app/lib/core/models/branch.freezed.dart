// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'branch.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Branch {

 int get id; String get code; String get name; String get address; String? get description; String get phone; String? get email; num get latitude; num get longitude; bool get is_main; bool get is_active; List<Schedule> get schedules;
/// Create a copy of Branch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BranchCopyWith<Branch> get copyWith => _$BranchCopyWithImpl<Branch>(this as Branch, _$identity);

  /// Serializes this Branch to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Branch;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Branch&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude)&&(identical(other.is_main, _this.is_main) || other.is_main == _this.is_main)&&(identical(other.is_active, _this.is_active) || other.is_active == _this.is_active)&&const DeepCollectionEquality().equals(other.schedules, _this.schedules));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Branch;
  return Object.hash(runtimeType,_this.id,_this.code,_this.name,_this.address,_this.description,_this.phone,_this.email,_this.latitude,_this.longitude,_this.is_main,_this.is_active,const DeepCollectionEquality().hash(_this.schedules));
}

@override
String toString() {
  final _this = this as Branch;
  return 'Branch(id: ${_this.id}, code: ${_this.code}, name: ${_this.name}, address: ${_this.address}, description: ${_this.description}, phone: ${_this.phone}, email: ${_this.email}, latitude: ${_this.latitude}, longitude: ${_this.longitude}, is_main: ${_this.is_main}, is_active: ${_this.is_active}, schedules: ${_this.schedules})';
}


}

/// @nodoc
abstract mixin class $BranchCopyWith<$Res>  {
  factory $BranchCopyWith(Branch value, $Res Function(Branch) _then) = _$BranchCopyWithImpl;
@useResult
$Res call({
 int id, String code, String name, String address, String? description, String phone, String? email, num latitude, num longitude, bool is_main, bool is_active, List<Schedule> schedules
});




}
/// @nodoc
class _$BranchCopyWithImpl<$Res>
    implements $BranchCopyWith<$Res> {
  _$BranchCopyWithImpl(this._self, this._then);

  final Branch _self;
  final $Res Function(Branch) _then;

/// Create a copy of Branch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? address = null,Object? description = freezed,Object? phone = null,Object? email = freezed,Object? latitude = null,Object? longitude = null,Object? is_main = null,Object? is_active = null,Object? schedules = null,}) {
  return _then(Branch(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as num,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as num,is_main: null == is_main ? _self.is_main : is_main // ignore: cast_nullable_to_non_nullable
as bool,is_active: null == is_active ? _self.is_active : is_active // ignore: cast_nullable_to_non_nullable
as bool,schedules: null == schedules ? _self.schedules : schedules // ignore: cast_nullable_to_non_nullable
as List<Schedule>,
  ));
}

}


/// Adds pattern-matching-related methods to [Branch].
extension BranchPatterns on Branch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Branch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Branch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Branch value)  $default,){
final _that = this;
switch (_that) {
case _Branch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Branch value)?  $default,){
final _that = this;
switch (_that) {
case _Branch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String code,  String name,  String address,  String? description,  String phone,  String? email,  num latitude,  num longitude,  bool is_main,  bool is_active,  List<Schedule> schedules)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Branch() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.address,_that.description,_that.phone,_that.email,_that.latitude,_that.longitude,_that.is_main,_that.is_active,_that.schedules);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String code,  String name,  String address,  String? description,  String phone,  String? email,  num latitude,  num longitude,  bool is_main,  bool is_active,  List<Schedule> schedules)  $default,) {final _that = this;
switch (_that) {
case _Branch():
return $default(_that.id,_that.code,_that.name,_that.address,_that.description,_that.phone,_that.email,_that.latitude,_that.longitude,_that.is_main,_that.is_active,_that.schedules);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String code,  String name,  String address,  String? description,  String phone,  String? email,  num latitude,  num longitude,  bool is_main,  bool is_active,  List<Schedule> schedules)?  $default,) {final _that = this;
switch (_that) {
case _Branch() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.address,_that.description,_that.phone,_that.email,_that.latitude,_that.longitude,_that.is_main,_that.is_active,_that.schedules);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Branch implements Branch {
  const _Branch({required this.id, required this.code, required this.name, required this.address, this.description, required this.phone, this.email, required this.latitude, required this.longitude, required this.is_main, required this.is_active,  List<Schedule> schedules = const <Schedule>[]}): _schedules = schedules;
  factory _Branch.fromJson(Map<String, dynamic> json) => _$BranchFromJson(json);

@override final  int id;
@override final  String code;
@override final  String name;
@override final  String address;
@override final  String? description;
@override final  String phone;
@override final  String? email;
@override final  num latitude;
@override final  num longitude;
@override final  bool is_main;
@override final  bool is_active;
 final  List<Schedule> _schedules;
@override@JsonKey() List<Schedule> get schedules {
  if (_schedules is EqualUnmodifiableListView) return _schedules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_schedules);
}


/// Create a copy of Branch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BranchCopyWith<_Branch> get copyWith => __$BranchCopyWithImpl<_Branch>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BranchToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Branch&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.description, description) || other.description == description)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.is_main, is_main) || other.is_main == is_main)&&(identical(other.is_active, is_active) || other.is_active == is_active)&&const DeepCollectionEquality().equals(other.schedules, _schedules));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,name,address,description,phone,email,latitude,longitude,is_main,is_active,const DeepCollectionEquality().hash(_schedules));
}

@override
String toString() {
    return 'Branch(id: $id, code: $code, name: $name, address: $address, description: $description, phone: $phone, email: $email, latitude: $latitude, longitude: $longitude, is_main: $is_main, is_active: $is_active, schedules: $schedules)';
}


}

/// @nodoc
abstract mixin class _$BranchCopyWith<$Res> implements $BranchCopyWith<$Res> {
  factory _$BranchCopyWith(_Branch value, $Res Function(_Branch) _then) = __$BranchCopyWithImpl;
@override @useResult
$Res call({
 int id, String code, String name, String address, String? description, String phone, String? email, num latitude, num longitude, bool is_main, bool is_active, List<Schedule> schedules
});




}
/// @nodoc
class __$BranchCopyWithImpl<$Res>
    implements _$BranchCopyWith<$Res> {
  __$BranchCopyWithImpl(this._self, this._then);

  final _Branch _self;
  final $Res Function(_Branch) _then;

/// Create a copy of Branch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? address = null,Object? description = freezed,Object? phone = null,Object? email = freezed,Object? latitude = null,Object? longitude = null,Object? is_main = null,Object? is_active = null,Object? schedules = null,}) {
  return _then(_Branch(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as num,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as num,is_main: null == is_main ? _self.is_main : is_main // ignore: cast_nullable_to_non_nullable
as bool,is_active: null == is_active ? _self.is_active : is_active // ignore: cast_nullable_to_non_nullable
as bool,schedules: null == schedules ? _self._schedules : schedules // ignore: cast_nullable_to_non_nullable
as List<Schedule>,
  ));
}


}


/// @nodoc
mixin _$Schedule {

 int get day_of_week; String? get opens_at; String? get closes_at; int get capacity; bool get is_closed;
/// Create a copy of Schedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleCopyWith<Schedule> get copyWith => _$ScheduleCopyWithImpl<Schedule>(this as Schedule, _$identity);

  /// Serializes this Schedule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Schedule;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Schedule&&(identical(other.day_of_week, _this.day_of_week) || other.day_of_week == _this.day_of_week)&&(identical(other.opens_at, _this.opens_at) || other.opens_at == _this.opens_at)&&(identical(other.closes_at, _this.closes_at) || other.closes_at == _this.closes_at)&&(identical(other.capacity, _this.capacity) || other.capacity == _this.capacity)&&(identical(other.is_closed, _this.is_closed) || other.is_closed == _this.is_closed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Schedule;
  return Object.hash(runtimeType,_this.day_of_week,_this.opens_at,_this.closes_at,_this.capacity,_this.is_closed);
}

@override
String toString() {
  final _this = this as Schedule;
  return 'Schedule(day_of_week: ${_this.day_of_week}, opens_at: ${_this.opens_at}, closes_at: ${_this.closes_at}, capacity: ${_this.capacity}, is_closed: ${_this.is_closed})';
}


}

/// @nodoc
abstract mixin class $ScheduleCopyWith<$Res>  {
  factory $ScheduleCopyWith(Schedule value, $Res Function(Schedule) _then) = _$ScheduleCopyWithImpl;
@useResult
$Res call({
 int day_of_week, String? opens_at, String? closes_at, int capacity, bool is_closed
});




}
/// @nodoc
class _$ScheduleCopyWithImpl<$Res>
    implements $ScheduleCopyWith<$Res> {
  _$ScheduleCopyWithImpl(this._self, this._then);

  final Schedule _self;
  final $Res Function(Schedule) _then;

/// Create a copy of Schedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day_of_week = null,Object? opens_at = freezed,Object? closes_at = freezed,Object? capacity = null,Object? is_closed = null,}) {
  return _then(Schedule(
day_of_week: null == day_of_week ? _self.day_of_week : day_of_week // ignore: cast_nullable_to_non_nullable
as int,opens_at: freezed == opens_at ? _self.opens_at : opens_at // ignore: cast_nullable_to_non_nullable
as String?,closes_at: freezed == closes_at ? _self.closes_at : closes_at // ignore: cast_nullable_to_non_nullable
as String?,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,is_closed: null == is_closed ? _self.is_closed : is_closed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Schedule].
extension SchedulePatterns on Schedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Schedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Schedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Schedule value)  $default,){
final _that = this;
switch (_that) {
case _Schedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Schedule value)?  $default,){
final _that = this;
switch (_that) {
case _Schedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int day_of_week,  String? opens_at,  String? closes_at,  int capacity,  bool is_closed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Schedule() when $default != null:
return $default(_that.day_of_week,_that.opens_at,_that.closes_at,_that.capacity,_that.is_closed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int day_of_week,  String? opens_at,  String? closes_at,  int capacity,  bool is_closed)  $default,) {final _that = this;
switch (_that) {
case _Schedule():
return $default(_that.day_of_week,_that.opens_at,_that.closes_at,_that.capacity,_that.is_closed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int day_of_week,  String? opens_at,  String? closes_at,  int capacity,  bool is_closed)?  $default,) {final _that = this;
switch (_that) {
case _Schedule() when $default != null:
return $default(_that.day_of_week,_that.opens_at,_that.closes_at,_that.capacity,_that.is_closed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Schedule implements Schedule {
  const _Schedule({required this.day_of_week, this.opens_at, this.closes_at, required this.capacity, required this.is_closed});
  factory _Schedule.fromJson(Map<String, dynamic> json) => _$ScheduleFromJson(json);

@override final  int day_of_week;
@override final  String? opens_at;
@override final  String? closes_at;
@override final  int capacity;
@override final  bool is_closed;

/// Create a copy of Schedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleCopyWith<_Schedule> get copyWith => __$ScheduleCopyWithImpl<_Schedule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Schedule&&(identical(other.day_of_week, day_of_week) || other.day_of_week == day_of_week)&&(identical(other.opens_at, opens_at) || other.opens_at == opens_at)&&(identical(other.closes_at, closes_at) || other.closes_at == closes_at)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.is_closed, is_closed) || other.is_closed == is_closed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,day_of_week,opens_at,closes_at,capacity,is_closed);
}

@override
String toString() {
    return 'Schedule(day_of_week: $day_of_week, opens_at: $opens_at, closes_at: $closes_at, capacity: $capacity, is_closed: $is_closed)';
}


}

/// @nodoc
abstract mixin class _$ScheduleCopyWith<$Res> implements $ScheduleCopyWith<$Res> {
  factory _$ScheduleCopyWith(_Schedule value, $Res Function(_Schedule) _then) = __$ScheduleCopyWithImpl;
@override @useResult
$Res call({
 int day_of_week, String? opens_at, String? closes_at, int capacity, bool is_closed
});




}
/// @nodoc
class __$ScheduleCopyWithImpl<$Res>
    implements _$ScheduleCopyWith<$Res> {
  __$ScheduleCopyWithImpl(this._self, this._then);

  final _Schedule _self;
  final $Res Function(_Schedule) _then;

/// Create a copy of Schedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day_of_week = null,Object? opens_at = freezed,Object? closes_at = freezed,Object? capacity = null,Object? is_closed = null,}) {
  return _then(_Schedule(
day_of_week: null == day_of_week ? _self.day_of_week : day_of_week // ignore: cast_nullable_to_non_nullable
as int,opens_at: freezed == opens_at ? _self.opens_at : opens_at // ignore: cast_nullable_to_non_nullable
as String?,closes_at: freezed == closes_at ? _self.closes_at : closes_at // ignore: cast_nullable_to_non_nullable
as String?,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,is_closed: null == is_closed ? _self.is_closed : is_closed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
