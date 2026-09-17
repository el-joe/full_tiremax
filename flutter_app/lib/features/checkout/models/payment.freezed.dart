// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Payment {

 int get id; int get order_id; int get payment_gateway_id; num get amount; String get currency; String get status; String? get transaction_id; String? get redirect_url; Map<String, dynamic>? get gateway_response; String? get paid_at; PaymentGateway get gateway;
/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentCopyWith<Payment> get copyWith => _$PaymentCopyWithImpl<Payment>(this as Payment, _$identity);

  /// Serializes this Payment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Payment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Payment&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.order_id, _this.order_id) || other.order_id == _this.order_id)&&(identical(other.payment_gateway_id, _this.payment_gateway_id) || other.payment_gateway_id == _this.payment_gateway_id)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.transaction_id, _this.transaction_id) || other.transaction_id == _this.transaction_id)&&(identical(other.redirect_url, _this.redirect_url) || other.redirect_url == _this.redirect_url)&&const DeepCollectionEquality().equals(other.gateway_response, _this.gateway_response)&&(identical(other.paid_at, _this.paid_at) || other.paid_at == _this.paid_at)&&(identical(other.gateway, _this.gateway) || other.gateway == _this.gateway));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Payment;
  return Object.hash(runtimeType,_this.id,_this.order_id,_this.payment_gateway_id,_this.amount,_this.currency,_this.status,_this.transaction_id,_this.redirect_url,const DeepCollectionEquality().hash(_this.gateway_response),_this.paid_at,_this.gateway);
}

@override
String toString() {
  final _this = this as Payment;
  return 'Payment(id: ${_this.id}, order_id: ${_this.order_id}, payment_gateway_id: ${_this.payment_gateway_id}, amount: ${_this.amount}, currency: ${_this.currency}, status: ${_this.status}, transaction_id: ${_this.transaction_id}, redirect_url: ${_this.redirect_url}, gateway_response: ${_this.gateway_response}, paid_at: ${_this.paid_at}, gateway: ${_this.gateway})';
}


}

/// @nodoc
abstract mixin class $PaymentCopyWith<$Res>  {
  factory $PaymentCopyWith(Payment value, $Res Function(Payment) _then) = _$PaymentCopyWithImpl;
@useResult
$Res call({
 int id, int order_id, int payment_gateway_id, num amount, String currency, String status, String? transaction_id, String? redirect_url, Map<String, dynamic>? gateway_response, String? paid_at, PaymentGateway gateway
});


$PaymentGatewayCopyWith<$Res> get gateway;

}
/// @nodoc
class _$PaymentCopyWithImpl<$Res>
    implements $PaymentCopyWith<$Res> {
  _$PaymentCopyWithImpl(this._self, this._then);

  final Payment _self;
  final $Res Function(Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? order_id = null,Object? payment_gateway_id = null,Object? amount = null,Object? currency = null,Object? status = null,Object? transaction_id = freezed,Object? redirect_url = freezed,Object? gateway_response = freezed,Object? paid_at = freezed,Object? gateway = null,}) {
  return _then(Payment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,order_id: null == order_id ? _self.order_id : order_id // ignore: cast_nullable_to_non_nullable
as int,payment_gateway_id: null == payment_gateway_id ? _self.payment_gateway_id : payment_gateway_id // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as num,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,transaction_id: freezed == transaction_id ? _self.transaction_id : transaction_id // ignore: cast_nullable_to_non_nullable
as String?,redirect_url: freezed == redirect_url ? _self.redirect_url : redirect_url // ignore: cast_nullable_to_non_nullable
as String?,gateway_response: freezed == gateway_response ? _self.gateway_response : gateway_response // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,paid_at: freezed == paid_at ? _self.paid_at : paid_at // ignore: cast_nullable_to_non_nullable
as String?,gateway: null == gateway ? _self.gateway : gateway // ignore: cast_nullable_to_non_nullable
as PaymentGateway,
  ));
}
/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentGatewayCopyWith<$Res> get gateway {
  
  return $PaymentGatewayCopyWith<$Res>(_self.gateway, (value) {
    return _then(_self.copyWith(gateway: value));
  });
}
}


/// Adds pattern-matching-related methods to [Payment].
extension PaymentPatterns on Payment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Payment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Payment value)  $default,){
final _that = this;
switch (_that) {
case _Payment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Payment value)?  $default,){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int order_id,  int payment_gateway_id,  num amount,  String currency,  String status,  String? transaction_id,  String? redirect_url,  Map<String, dynamic>? gateway_response,  String? paid_at,  PaymentGateway gateway)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.id,_that.order_id,_that.payment_gateway_id,_that.amount,_that.currency,_that.status,_that.transaction_id,_that.redirect_url,_that.gateway_response,_that.paid_at,_that.gateway);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int order_id,  int payment_gateway_id,  num amount,  String currency,  String status,  String? transaction_id,  String? redirect_url,  Map<String, dynamic>? gateway_response,  String? paid_at,  PaymentGateway gateway)  $default,) {final _that = this;
switch (_that) {
case _Payment():
return $default(_that.id,_that.order_id,_that.payment_gateway_id,_that.amount,_that.currency,_that.status,_that.transaction_id,_that.redirect_url,_that.gateway_response,_that.paid_at,_that.gateway);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int order_id,  int payment_gateway_id,  num amount,  String currency,  String status,  String? transaction_id,  String? redirect_url,  Map<String, dynamic>? gateway_response,  String? paid_at,  PaymentGateway gateway)?  $default,) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.id,_that.order_id,_that.payment_gateway_id,_that.amount,_that.currency,_that.status,_that.transaction_id,_that.redirect_url,_that.gateway_response,_that.paid_at,_that.gateway);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Payment implements Payment {
  const _Payment({required this.id, required this.order_id, required this.payment_gateway_id, required this.amount, required this.currency, required this.status, this.transaction_id, this.redirect_url,  Map<String, dynamic>? gateway_response, this.paid_at, required this.gateway}): _gateway_response = gateway_response;
  factory _Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);

@override final  int id;
@override final  int order_id;
@override final  int payment_gateway_id;
@override final  num amount;
@override final  String currency;
@override final  String status;
@override final  String? transaction_id;
@override final  String? redirect_url;
 final  Map<String, dynamic>? _gateway_response;
@override Map<String, dynamic>? get gateway_response {
  final value = _gateway_response;
  if (value == null) return null;
  if (_gateway_response is EqualUnmodifiableMapView) return _gateway_response;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? paid_at;
@override final  PaymentGateway gateway;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentCopyWith<_Payment> get copyWith => __$PaymentCopyWithImpl<_Payment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Payment&&(identical(other.id, id) || other.id == id)&&(identical(other.order_id, order_id) || other.order_id == order_id)&&(identical(other.payment_gateway_id, payment_gateway_id) || other.payment_gateway_id == payment_gateway_id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.status, status) || other.status == status)&&(identical(other.transaction_id, transaction_id) || other.transaction_id == transaction_id)&&(identical(other.redirect_url, redirect_url) || other.redirect_url == redirect_url)&&const DeepCollectionEquality().equals(other.gateway_response, _gateway_response)&&(identical(other.paid_at, paid_at) || other.paid_at == paid_at)&&(identical(other.gateway, gateway) || other.gateway == gateway));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,order_id,payment_gateway_id,amount,currency,status,transaction_id,redirect_url,const DeepCollectionEquality().hash(_gateway_response),paid_at,gateway);
}

@override
String toString() {
    return 'Payment(id: $id, order_id: $order_id, payment_gateway_id: $payment_gateway_id, amount: $amount, currency: $currency, status: $status, transaction_id: $transaction_id, redirect_url: $redirect_url, gateway_response: $gateway_response, paid_at: $paid_at, gateway: $gateway)';
}


}

/// @nodoc
abstract mixin class _$PaymentCopyWith<$Res> implements $PaymentCopyWith<$Res> {
  factory _$PaymentCopyWith(_Payment value, $Res Function(_Payment) _then) = __$PaymentCopyWithImpl;
@override @useResult
$Res call({
 int id, int order_id, int payment_gateway_id, num amount, String currency, String status, String? transaction_id, String? redirect_url, Map<String, dynamic>? gateway_response, String? paid_at, PaymentGateway gateway
});


@override $PaymentGatewayCopyWith<$Res> get gateway;

}
/// @nodoc
class __$PaymentCopyWithImpl<$Res>
    implements _$PaymentCopyWith<$Res> {
  __$PaymentCopyWithImpl(this._self, this._then);

  final _Payment _self;
  final $Res Function(_Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? order_id = null,Object? payment_gateway_id = null,Object? amount = null,Object? currency = null,Object? status = null,Object? transaction_id = freezed,Object? redirect_url = freezed,Object? gateway_response = freezed,Object? paid_at = freezed,Object? gateway = null,}) {
  return _then(_Payment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,order_id: null == order_id ? _self.order_id : order_id // ignore: cast_nullable_to_non_nullable
as int,payment_gateway_id: null == payment_gateway_id ? _self.payment_gateway_id : payment_gateway_id // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as num,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,transaction_id: freezed == transaction_id ? _self.transaction_id : transaction_id // ignore: cast_nullable_to_non_nullable
as String?,redirect_url: freezed == redirect_url ? _self.redirect_url : redirect_url // ignore: cast_nullable_to_non_nullable
as String?,gateway_response: freezed == gateway_response ? _self._gateway_response : gateway_response // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,paid_at: freezed == paid_at ? _self.paid_at : paid_at // ignore: cast_nullable_to_non_nullable
as String?,gateway: null == gateway ? _self.gateway : gateway // ignore: cast_nullable_to_non_nullable
as PaymentGateway,
  ));
}

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentGatewayCopyWith<$Res> get gateway {
  
  return $PaymentGatewayCopyWith<$Res>(_self.gateway, (value) {
    return _then(_self.copyWith(gateway: value));
  });
}
}


/// @nodoc
mixin _$PaymentGateway {

 int get id; String get name; String get display_name; String get driver;
/// Create a copy of PaymentGateway
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentGatewayCopyWith<PaymentGateway> get copyWith => _$PaymentGatewayCopyWithImpl<PaymentGateway>(this as PaymentGateway, _$identity);

  /// Serializes this PaymentGateway to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PaymentGateway;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentGateway&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.display_name, _this.display_name) || other.display_name == _this.display_name)&&(identical(other.driver, _this.driver) || other.driver == _this.driver));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PaymentGateway;
  return Object.hash(runtimeType,_this.id,_this.name,_this.display_name,_this.driver);
}

@override
String toString() {
  final _this = this as PaymentGateway;
  return 'PaymentGateway(id: ${_this.id}, name: ${_this.name}, display_name: ${_this.display_name}, driver: ${_this.driver})';
}


}

/// @nodoc
abstract mixin class $PaymentGatewayCopyWith<$Res>  {
  factory $PaymentGatewayCopyWith(PaymentGateway value, $Res Function(PaymentGateway) _then) = _$PaymentGatewayCopyWithImpl;
@useResult
$Res call({
 int id, String name, String display_name, String driver
});




}
/// @nodoc
class _$PaymentGatewayCopyWithImpl<$Res>
    implements $PaymentGatewayCopyWith<$Res> {
  _$PaymentGatewayCopyWithImpl(this._self, this._then);

  final PaymentGateway _self;
  final $Res Function(PaymentGateway) _then;

/// Create a copy of PaymentGateway
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? display_name = null,Object? driver = null,}) {
  return _then(PaymentGateway(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,display_name: null == display_name ? _self.display_name : display_name // ignore: cast_nullable_to_non_nullable
as String,driver: null == driver ? _self.driver : driver // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentGateway].
extension PaymentGatewayPatterns on PaymentGateway {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentGateway value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentGateway() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentGateway value)  $default,){
final _that = this;
switch (_that) {
case _PaymentGateway():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentGateway value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentGateway() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String display_name,  String driver)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentGateway() when $default != null:
return $default(_that.id,_that.name,_that.display_name,_that.driver);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String display_name,  String driver)  $default,) {final _that = this;
switch (_that) {
case _PaymentGateway():
return $default(_that.id,_that.name,_that.display_name,_that.driver);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String display_name,  String driver)?  $default,) {final _that = this;
switch (_that) {
case _PaymentGateway() when $default != null:
return $default(_that.id,_that.name,_that.display_name,_that.driver);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentGateway implements PaymentGateway {
  const _PaymentGateway({required this.id, required this.name, required this.display_name, required this.driver});
  factory _PaymentGateway.fromJson(Map<String, dynamic> json) => _$PaymentGatewayFromJson(json);

@override final  int id;
@override final  String name;
@override final  String display_name;
@override final  String driver;

/// Create a copy of PaymentGateway
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentGatewayCopyWith<_PaymentGateway> get copyWith => __$PaymentGatewayCopyWithImpl<_PaymentGateway>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentGatewayToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentGateway&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.display_name, display_name) || other.display_name == display_name)&&(identical(other.driver, driver) || other.driver == driver));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,display_name,driver);
}

@override
String toString() {
    return 'PaymentGateway(id: $id, name: $name, display_name: $display_name, driver: $driver)';
}


}

/// @nodoc
abstract mixin class _$PaymentGatewayCopyWith<$Res> implements $PaymentGatewayCopyWith<$Res> {
  factory _$PaymentGatewayCopyWith(_PaymentGateway value, $Res Function(_PaymentGateway) _then) = __$PaymentGatewayCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String display_name, String driver
});




}
/// @nodoc
class __$PaymentGatewayCopyWithImpl<$Res>
    implements _$PaymentGatewayCopyWith<$Res> {
  __$PaymentGatewayCopyWithImpl(this._self, this._then);

  final _PaymentGateway _self;
  final $Res Function(_PaymentGateway) _then;

/// Create a copy of PaymentGateway
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? display_name = null,Object? driver = null,}) {
  return _then(_PaymentGateway(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,display_name: null == display_name ? _self.display_name : display_name // ignore: cast_nullable_to_non_nullable
as String,driver: null == driver ? _self.driver : driver // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
