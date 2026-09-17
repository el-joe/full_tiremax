// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Address {

 int get id; String get full_name; String get phone; Governorate get governorate; City get city; String get address; bool get is_default;
/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressCopyWith<Address> get copyWith => _$AddressCopyWithImpl<Address>(this as Address, _$identity);

  /// Serializes this Address to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Address;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Address&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.full_name, _this.full_name) || other.full_name == _this.full_name)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.governorate, _this.governorate) || other.governorate == _this.governorate)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.is_default, _this.is_default) || other.is_default == _this.is_default));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Address;
  return Object.hash(runtimeType,_this.id,_this.full_name,_this.phone,_this.governorate,_this.city,_this.address,_this.is_default);
}

@override
String toString() {
  final _this = this as Address;
  return 'Address(id: ${_this.id}, full_name: ${_this.full_name}, phone: ${_this.phone}, governorate: ${_this.governorate}, city: ${_this.city}, address: ${_this.address}, is_default: ${_this.is_default})';
}


}

/// @nodoc
abstract mixin class $AddressCopyWith<$Res>  {
  factory $AddressCopyWith(Address value, $Res Function(Address) _then) = _$AddressCopyWithImpl;
@useResult
$Res call({
 int id, String full_name, String phone, Governorate governorate, City city, String address, bool is_default
});


$GovernorateCopyWith<$Res> get governorate;$CityCopyWith<$Res> get city;

}
/// @nodoc
class _$AddressCopyWithImpl<$Res>
    implements $AddressCopyWith<$Res> {
  _$AddressCopyWithImpl(this._self, this._then);

  final Address _self;
  final $Res Function(Address) _then;

/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? full_name = null,Object? phone = null,Object? governorate = null,Object? city = null,Object? address = null,Object? is_default = null,}) {
  return _then(Address(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,full_name: null == full_name ? _self.full_name : full_name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,governorate: null == governorate ? _self.governorate : governorate // ignore: cast_nullable_to_non_nullable
as Governorate,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as City,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,is_default: null == is_default ? _self.is_default : is_default // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GovernorateCopyWith<$Res> get governorate {
  
  return $GovernorateCopyWith<$Res>(_self.governorate, (value) {
    return _then(_self.copyWith(governorate: value));
  });
}/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CityCopyWith<$Res> get city {
  
  return $CityCopyWith<$Res>(_self.city, (value) {
    return _then(_self.copyWith(city: value));
  });
}
}


/// Adds pattern-matching-related methods to [Address].
extension AddressPatterns on Address {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Address value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Address() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Address value)  $default,){
final _that = this;
switch (_that) {
case _Address():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Address value)?  $default,){
final _that = this;
switch (_that) {
case _Address() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String full_name,  String phone,  Governorate governorate,  City city,  String address,  bool is_default)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Address() when $default != null:
return $default(_that.id,_that.full_name,_that.phone,_that.governorate,_that.city,_that.address,_that.is_default);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String full_name,  String phone,  Governorate governorate,  City city,  String address,  bool is_default)  $default,) {final _that = this;
switch (_that) {
case _Address():
return $default(_that.id,_that.full_name,_that.phone,_that.governorate,_that.city,_that.address,_that.is_default);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String full_name,  String phone,  Governorate governorate,  City city,  String address,  bool is_default)?  $default,) {final _that = this;
switch (_that) {
case _Address() when $default != null:
return $default(_that.id,_that.full_name,_that.phone,_that.governorate,_that.city,_that.address,_that.is_default);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Address implements Address {
  const _Address({required this.id, required this.full_name, required this.phone, required this.governorate, required this.city, required this.address, required this.is_default});
  factory _Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);

@override final  int id;
@override final  String full_name;
@override final  String phone;
@override final  Governorate governorate;
@override final  City city;
@override final  String address;
@override final  bool is_default;

/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddressCopyWith<_Address> get copyWith => __$AddressCopyWithImpl<_Address>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddressToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Address&&(identical(other.id, id) || other.id == id)&&(identical(other.full_name, full_name) || other.full_name == full_name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.governorate, governorate) || other.governorate == governorate)&&(identical(other.city, city) || other.city == city)&&(identical(other.address, address) || other.address == address)&&(identical(other.is_default, is_default) || other.is_default == is_default));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,full_name,phone,governorate,city,address,is_default);
}

@override
String toString() {
    return 'Address(id: $id, full_name: $full_name, phone: $phone, governorate: $governorate, city: $city, address: $address, is_default: $is_default)';
}


}

/// @nodoc
abstract mixin class _$AddressCopyWith<$Res> implements $AddressCopyWith<$Res> {
  factory _$AddressCopyWith(_Address value, $Res Function(_Address) _then) = __$AddressCopyWithImpl;
@override @useResult
$Res call({
 int id, String full_name, String phone, Governorate governorate, City city, String address, bool is_default
});


@override $GovernorateCopyWith<$Res> get governorate;@override $CityCopyWith<$Res> get city;

}
/// @nodoc
class __$AddressCopyWithImpl<$Res>
    implements _$AddressCopyWith<$Res> {
  __$AddressCopyWithImpl(this._self, this._then);

  final _Address _self;
  final $Res Function(_Address) _then;

/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? full_name = null,Object? phone = null,Object? governorate = null,Object? city = null,Object? address = null,Object? is_default = null,}) {
  return _then(_Address(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,full_name: null == full_name ? _self.full_name : full_name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,governorate: null == governorate ? _self.governorate : governorate // ignore: cast_nullable_to_non_nullable
as Governorate,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as City,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,is_default: null == is_default ? _self.is_default : is_default // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GovernorateCopyWith<$Res> get governorate {
  
  return $GovernorateCopyWith<$Res>(_self.governorate, (value) {
    return _then(_self.copyWith(governorate: value));
  });
}/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CityCopyWith<$Res> get city {
  
  return $CityCopyWith<$Res>(_self.city, (value) {
    return _then(_self.copyWith(city: value));
  });
}
}

// dart format on
