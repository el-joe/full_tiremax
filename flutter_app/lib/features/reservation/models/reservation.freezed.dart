// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reservation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Reservation {

 int get id; String get reference; DateTime get scheduled_at; int get duration_minutes; String get status; String? get customer_notes; ReservationBranch get branch; ReservationService get service;
/// Create a copy of Reservation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReservationCopyWith<Reservation> get copyWith => _$ReservationCopyWithImpl<Reservation>(this as Reservation, _$identity);

  /// Serializes this Reservation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Reservation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Reservation&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.reference, _this.reference) || other.reference == _this.reference)&&(identical(other.scheduled_at, _this.scheduled_at) || other.scheduled_at == _this.scheduled_at)&&(identical(other.duration_minutes, _this.duration_minutes) || other.duration_minutes == _this.duration_minutes)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.customer_notes, _this.customer_notes) || other.customer_notes == _this.customer_notes)&&(identical(other.branch, _this.branch) || other.branch == _this.branch)&&(identical(other.service, _this.service) || other.service == _this.service));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Reservation;
  return Object.hash(runtimeType,_this.id,_this.reference,_this.scheduled_at,_this.duration_minutes,_this.status,_this.customer_notes,_this.branch,_this.service);
}

@override
String toString() {
  final _this = this as Reservation;
  return 'Reservation(id: ${_this.id}, reference: ${_this.reference}, scheduled_at: ${_this.scheduled_at}, duration_minutes: ${_this.duration_minutes}, status: ${_this.status}, customer_notes: ${_this.customer_notes}, branch: ${_this.branch}, service: ${_this.service})';
}


}

/// @nodoc
abstract mixin class $ReservationCopyWith<$Res>  {
  factory $ReservationCopyWith(Reservation value, $Res Function(Reservation) _then) = _$ReservationCopyWithImpl;
@useResult
$Res call({
 int id, String reference, DateTime scheduled_at, int duration_minutes, String status, String? customer_notes, ReservationBranch branch, ReservationService service
});


$ReservationBranchCopyWith<$Res> get branch;$ReservationServiceCopyWith<$Res> get service;

}
/// @nodoc
class _$ReservationCopyWithImpl<$Res>
    implements $ReservationCopyWith<$Res> {
  _$ReservationCopyWithImpl(this._self, this._then);

  final Reservation _self;
  final $Res Function(Reservation) _then;

/// Create a copy of Reservation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? reference = null,Object? scheduled_at = null,Object? duration_minutes = null,Object? status = null,Object? customer_notes = freezed,Object? branch = null,Object? service = null,}) {
  return _then(Reservation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,reference: null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String,scheduled_at: null == scheduled_at ? _self.scheduled_at : scheduled_at // ignore: cast_nullable_to_non_nullable
as DateTime,duration_minutes: null == duration_minutes ? _self.duration_minutes : duration_minutes // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,customer_notes: freezed == customer_notes ? _self.customer_notes : customer_notes // ignore: cast_nullable_to_non_nullable
as String?,branch: null == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as ReservationBranch,service: null == service ? _self.service : service // ignore: cast_nullable_to_non_nullable
as ReservationService,
  ));
}
/// Create a copy of Reservation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReservationBranchCopyWith<$Res> get branch {
  
  return $ReservationBranchCopyWith<$Res>(_self.branch, (value) {
    return _then(_self.copyWith(branch: value));
  });
}/// Create a copy of Reservation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReservationServiceCopyWith<$Res> get service {
  
  return $ReservationServiceCopyWith<$Res>(_self.service, (value) {
    return _then(_self.copyWith(service: value));
  });
}
}


/// Adds pattern-matching-related methods to [Reservation].
extension ReservationPatterns on Reservation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Reservation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Reservation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Reservation value)  $default,){
final _that = this;
switch (_that) {
case _Reservation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Reservation value)?  $default,){
final _that = this;
switch (_that) {
case _Reservation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String reference,  DateTime scheduled_at,  int duration_minutes,  String status,  String? customer_notes,  ReservationBranch branch,  ReservationService service)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Reservation() when $default != null:
return $default(_that.id,_that.reference,_that.scheduled_at,_that.duration_minutes,_that.status,_that.customer_notes,_that.branch,_that.service);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String reference,  DateTime scheduled_at,  int duration_minutes,  String status,  String? customer_notes,  ReservationBranch branch,  ReservationService service)  $default,) {final _that = this;
switch (_that) {
case _Reservation():
return $default(_that.id,_that.reference,_that.scheduled_at,_that.duration_minutes,_that.status,_that.customer_notes,_that.branch,_that.service);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String reference,  DateTime scheduled_at,  int duration_minutes,  String status,  String? customer_notes,  ReservationBranch branch,  ReservationService service)?  $default,) {final _that = this;
switch (_that) {
case _Reservation() when $default != null:
return $default(_that.id,_that.reference,_that.scheduled_at,_that.duration_minutes,_that.status,_that.customer_notes,_that.branch,_that.service);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Reservation implements Reservation {
  const _Reservation({required this.id, required this.reference, required this.scheduled_at, required this.duration_minutes, required this.status, this.customer_notes, required this.branch, required this.service});
  factory _Reservation.fromJson(Map<String, dynamic> json) => _$ReservationFromJson(json);

@override final  int id;
@override final  String reference;
@override final  DateTime scheduled_at;
@override final  int duration_minutes;
@override final  String status;
@override final  String? customer_notes;
@override final  ReservationBranch branch;
@override final  ReservationService service;

/// Create a copy of Reservation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReservationCopyWith<_Reservation> get copyWith => __$ReservationCopyWithImpl<_Reservation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReservationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Reservation&&(identical(other.id, id) || other.id == id)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.scheduled_at, scheduled_at) || other.scheduled_at == scheduled_at)&&(identical(other.duration_minutes, duration_minutes) || other.duration_minutes == duration_minutes)&&(identical(other.status, status) || other.status == status)&&(identical(other.customer_notes, customer_notes) || other.customer_notes == customer_notes)&&(identical(other.branch, branch) || other.branch == branch)&&(identical(other.service, service) || other.service == service));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,reference,scheduled_at,duration_minutes,status,customer_notes,branch,service);
}

@override
String toString() {
    return 'Reservation(id: $id, reference: $reference, scheduled_at: $scheduled_at, duration_minutes: $duration_minutes, status: $status, customer_notes: $customer_notes, branch: $branch, service: $service)';
}


}

/// @nodoc
abstract mixin class _$ReservationCopyWith<$Res> implements $ReservationCopyWith<$Res> {
  factory _$ReservationCopyWith(_Reservation value, $Res Function(_Reservation) _then) = __$ReservationCopyWithImpl;
@override @useResult
$Res call({
 int id, String reference, DateTime scheduled_at, int duration_minutes, String status, String? customer_notes, ReservationBranch branch, ReservationService service
});


@override $ReservationBranchCopyWith<$Res> get branch;@override $ReservationServiceCopyWith<$Res> get service;

}
/// @nodoc
class __$ReservationCopyWithImpl<$Res>
    implements _$ReservationCopyWith<$Res> {
  __$ReservationCopyWithImpl(this._self, this._then);

  final _Reservation _self;
  final $Res Function(_Reservation) _then;

/// Create a copy of Reservation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? reference = null,Object? scheduled_at = null,Object? duration_minutes = null,Object? status = null,Object? customer_notes = freezed,Object? branch = null,Object? service = null,}) {
  return _then(_Reservation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,reference: null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String,scheduled_at: null == scheduled_at ? _self.scheduled_at : scheduled_at // ignore: cast_nullable_to_non_nullable
as DateTime,duration_minutes: null == duration_minutes ? _self.duration_minutes : duration_minutes // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,customer_notes: freezed == customer_notes ? _self.customer_notes : customer_notes // ignore: cast_nullable_to_non_nullable
as String?,branch: null == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as ReservationBranch,service: null == service ? _self.service : service // ignore: cast_nullable_to_non_nullable
as ReservationService,
  ));
}

/// Create a copy of Reservation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReservationBranchCopyWith<$Res> get branch {
  
  return $ReservationBranchCopyWith<$Res>(_self.branch, (value) {
    return _then(_self.copyWith(branch: value));
  });
}/// Create a copy of Reservation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReservationServiceCopyWith<$Res> get service {
  
  return $ReservationServiceCopyWith<$Res>(_self.service, (value) {
    return _then(_self.copyWith(service: value));
  });
}
}


/// @nodoc
mixin _$ReservationBranch {

 int get id; String get code; String get name; String get address; String get phone; num get latitude; num get longitude;
/// Create a copy of ReservationBranch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReservationBranchCopyWith<ReservationBranch> get copyWith => _$ReservationBranchCopyWithImpl<ReservationBranch>(this as ReservationBranch, _$identity);

  /// Serializes this ReservationBranch to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReservationBranch;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReservationBranch&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReservationBranch;
  return Object.hash(runtimeType,_this.id,_this.code,_this.name,_this.address,_this.phone,_this.latitude,_this.longitude);
}

@override
String toString() {
  final _this = this as ReservationBranch;
  return 'ReservationBranch(id: ${_this.id}, code: ${_this.code}, name: ${_this.name}, address: ${_this.address}, phone: ${_this.phone}, latitude: ${_this.latitude}, longitude: ${_this.longitude})';
}


}

/// @nodoc
abstract mixin class $ReservationBranchCopyWith<$Res>  {
  factory $ReservationBranchCopyWith(ReservationBranch value, $Res Function(ReservationBranch) _then) = _$ReservationBranchCopyWithImpl;
@useResult
$Res call({
 int id, String code, String name, String address, String phone, num latitude, num longitude
});




}
/// @nodoc
class _$ReservationBranchCopyWithImpl<$Res>
    implements $ReservationBranchCopyWith<$Res> {
  _$ReservationBranchCopyWithImpl(this._self, this._then);

  final ReservationBranch _self;
  final $Res Function(ReservationBranch) _then;

/// Create a copy of ReservationBranch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? address = null,Object? phone = null,Object? latitude = null,Object? longitude = null,}) {
  return _then(ReservationBranch(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as num,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [ReservationBranch].
extension ReservationBranchPatterns on ReservationBranch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReservationBranch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReservationBranch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReservationBranch value)  $default,){
final _that = this;
switch (_that) {
case _ReservationBranch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReservationBranch value)?  $default,){
final _that = this;
switch (_that) {
case _ReservationBranch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String code,  String name,  String address,  String phone,  num latitude,  num longitude)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReservationBranch() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.address,_that.phone,_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String code,  String name,  String address,  String phone,  num latitude,  num longitude)  $default,) {final _that = this;
switch (_that) {
case _ReservationBranch():
return $default(_that.id,_that.code,_that.name,_that.address,_that.phone,_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String code,  String name,  String address,  String phone,  num latitude,  num longitude)?  $default,) {final _that = this;
switch (_that) {
case _ReservationBranch() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.address,_that.phone,_that.latitude,_that.longitude);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReservationBranch implements ReservationBranch {
  const _ReservationBranch({required this.id, required this.code, required this.name, required this.address, required this.phone, required this.latitude, required this.longitude});
  factory _ReservationBranch.fromJson(Map<String, dynamic> json) => _$ReservationBranchFromJson(json);

@override final  int id;
@override final  String code;
@override final  String name;
@override final  String address;
@override final  String phone;
@override final  num latitude;
@override final  num longitude;

/// Create a copy of ReservationBranch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReservationBranchCopyWith<_ReservationBranch> get copyWith => __$ReservationBranchCopyWithImpl<_ReservationBranch>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReservationBranchToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReservationBranch&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,name,address,phone,latitude,longitude);
}

@override
String toString() {
    return 'ReservationBranch(id: $id, code: $code, name: $name, address: $address, phone: $phone, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$ReservationBranchCopyWith<$Res> implements $ReservationBranchCopyWith<$Res> {
  factory _$ReservationBranchCopyWith(_ReservationBranch value, $Res Function(_ReservationBranch) _then) = __$ReservationBranchCopyWithImpl;
@override @useResult
$Res call({
 int id, String code, String name, String address, String phone, num latitude, num longitude
});




}
/// @nodoc
class __$ReservationBranchCopyWithImpl<$Res>
    implements _$ReservationBranchCopyWith<$Res> {
  __$ReservationBranchCopyWithImpl(this._self, this._then);

  final _ReservationBranch _self;
  final $Res Function(_ReservationBranch) _then;

/// Create a copy of ReservationBranch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? address = null,Object? phone = null,Object? latitude = null,Object? longitude = null,}) {
  return _then(_ReservationBranch(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as num,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}


/// @nodoc
mixin _$ReservationService {

 int get id; String get slug; String get name; String get description; int get duration_minutes; num get price;
/// Create a copy of ReservationService
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReservationServiceCopyWith<ReservationService> get copyWith => _$ReservationServiceCopyWithImpl<ReservationService>(this as ReservationService, _$identity);

  /// Serializes this ReservationService to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReservationService;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReservationService&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.duration_minutes, _this.duration_minutes) || other.duration_minutes == _this.duration_minutes)&&(identical(other.price, _this.price) || other.price == _this.price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReservationService;
  return Object.hash(runtimeType,_this.id,_this.slug,_this.name,_this.description,_this.duration_minutes,_this.price);
}

@override
String toString() {
  final _this = this as ReservationService;
  return 'ReservationService(id: ${_this.id}, slug: ${_this.slug}, name: ${_this.name}, description: ${_this.description}, duration_minutes: ${_this.duration_minutes}, price: ${_this.price})';
}


}

/// @nodoc
abstract mixin class $ReservationServiceCopyWith<$Res>  {
  factory $ReservationServiceCopyWith(ReservationService value, $Res Function(ReservationService) _then) = _$ReservationServiceCopyWithImpl;
@useResult
$Res call({
 int id, String slug, String name, String description, int duration_minutes, num price
});




}
/// @nodoc
class _$ReservationServiceCopyWithImpl<$Res>
    implements $ReservationServiceCopyWith<$Res> {
  _$ReservationServiceCopyWithImpl(this._self, this._then);

  final ReservationService _self;
  final $Res Function(ReservationService) _then;

/// Create a copy of ReservationService
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? description = null,Object? duration_minutes = null,Object? price = null,}) {
  return _then(ReservationService(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,duration_minutes: null == duration_minutes ? _self.duration_minutes : duration_minutes // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [ReservationService].
extension ReservationServicePatterns on ReservationService {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReservationService value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReservationService() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReservationService value)  $default,){
final _that = this;
switch (_that) {
case _ReservationService():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReservationService value)?  $default,){
final _that = this;
switch (_that) {
case _ReservationService() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String slug,  String name,  String description,  int duration_minutes,  num price)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReservationService() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.description,_that.duration_minutes,_that.price);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String slug,  String name,  String description,  int duration_minutes,  num price)  $default,) {final _that = this;
switch (_that) {
case _ReservationService():
return $default(_that.id,_that.slug,_that.name,_that.description,_that.duration_minutes,_that.price);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String slug,  String name,  String description,  int duration_minutes,  num price)?  $default,) {final _that = this;
switch (_that) {
case _ReservationService() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.description,_that.duration_minutes,_that.price);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReservationService implements ReservationService {
  const _ReservationService({required this.id, required this.slug, required this.name, required this.description, required this.duration_minutes, required this.price});
  factory _ReservationService.fromJson(Map<String, dynamic> json) => _$ReservationServiceFromJson(json);

@override final  int id;
@override final  String slug;
@override final  String name;
@override final  String description;
@override final  int duration_minutes;
@override final  num price;

/// Create a copy of ReservationService
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReservationServiceCopyWith<_ReservationService> get copyWith => __$ReservationServiceCopyWithImpl<_ReservationService>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReservationServiceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReservationService&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.duration_minutes, duration_minutes) || other.duration_minutes == duration_minutes)&&(identical(other.price, price) || other.price == price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,slug,name,description,duration_minutes,price);
}

@override
String toString() {
    return 'ReservationService(id: $id, slug: $slug, name: $name, description: $description, duration_minutes: $duration_minutes, price: $price)';
}


}

/// @nodoc
abstract mixin class _$ReservationServiceCopyWith<$Res> implements $ReservationServiceCopyWith<$Res> {
  factory _$ReservationServiceCopyWith(_ReservationService value, $Res Function(_ReservationService) _then) = __$ReservationServiceCopyWithImpl;
@override @useResult
$Res call({
 int id, String slug, String name, String description, int duration_minutes, num price
});




}
/// @nodoc
class __$ReservationServiceCopyWithImpl<$Res>
    implements _$ReservationServiceCopyWith<$Res> {
  __$ReservationServiceCopyWithImpl(this._self, this._then);

  final _ReservationService _self;
  final $Res Function(_ReservationService) _then;

/// Create a copy of ReservationService
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? description = null,Object? duration_minutes = null,Object? price = null,}) {
  return _then(_ReservationService(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,duration_minutes: null == duration_minutes ? _self.duration_minutes : duration_minutes // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

// dart format on
