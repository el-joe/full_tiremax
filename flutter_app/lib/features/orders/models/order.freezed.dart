// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Order {

 int get id; String get reference; String get type; String get status; String get payment_method; String get payment_status; num get subtotal; num get discount; num get shipping_fee; num get installation_fee; num get total; String get customer_name; String get customer_phone; String get customer_email; String get shipping_address; String get tracking_number; String get placed_at; Governorate? get governorate; Branch? get branch; List<OrderItem> get items;
/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderCopyWith<Order> get copyWith => _$OrderCopyWithImpl<Order>(this as Order, _$identity);

  /// Serializes this Order to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Order;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Order&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.reference, _this.reference) || other.reference == _this.reference)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.payment_method, _this.payment_method) || other.payment_method == _this.payment_method)&&(identical(other.payment_status, _this.payment_status) || other.payment_status == _this.payment_status)&&(identical(other.subtotal, _this.subtotal) || other.subtotal == _this.subtotal)&&(identical(other.discount, _this.discount) || other.discount == _this.discount)&&(identical(other.shipping_fee, _this.shipping_fee) || other.shipping_fee == _this.shipping_fee)&&(identical(other.installation_fee, _this.installation_fee) || other.installation_fee == _this.installation_fee)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.customer_name, _this.customer_name) || other.customer_name == _this.customer_name)&&(identical(other.customer_phone, _this.customer_phone) || other.customer_phone == _this.customer_phone)&&(identical(other.customer_email, _this.customer_email) || other.customer_email == _this.customer_email)&&(identical(other.shipping_address, _this.shipping_address) || other.shipping_address == _this.shipping_address)&&(identical(other.tracking_number, _this.tracking_number) || other.tracking_number == _this.tracking_number)&&(identical(other.placed_at, _this.placed_at) || other.placed_at == _this.placed_at)&&(identical(other.governorate, _this.governorate) || other.governorate == _this.governorate)&&(identical(other.branch, _this.branch) || other.branch == _this.branch)&&const DeepCollectionEquality().equals(other.items, _this.items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Order;
  return Object.hashAll([runtimeType,_this.id,_this.reference,_this.type,_this.status,_this.payment_method,_this.payment_status,_this.subtotal,_this.discount,_this.shipping_fee,_this.installation_fee,_this.total,_this.customer_name,_this.customer_phone,_this.customer_email,_this.shipping_address,_this.tracking_number,_this.placed_at,_this.governorate,_this.branch,const DeepCollectionEquality().hash(_this.items)]);
}

@override
String toString() {
  final _this = this as Order;
  return 'Order(id: ${_this.id}, reference: ${_this.reference}, type: ${_this.type}, status: ${_this.status}, payment_method: ${_this.payment_method}, payment_status: ${_this.payment_status}, subtotal: ${_this.subtotal}, discount: ${_this.discount}, shipping_fee: ${_this.shipping_fee}, installation_fee: ${_this.installation_fee}, total: ${_this.total}, customer_name: ${_this.customer_name}, customer_phone: ${_this.customer_phone}, customer_email: ${_this.customer_email}, shipping_address: ${_this.shipping_address}, tracking_number: ${_this.tracking_number}, placed_at: ${_this.placed_at}, governorate: ${_this.governorate}, branch: ${_this.branch}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $OrderCopyWith<$Res>  {
  factory $OrderCopyWith(Order value, $Res Function(Order) _then) = _$OrderCopyWithImpl;
@useResult
$Res call({
 int id, String reference, String type, String status, String payment_method, String payment_status, num subtotal, num discount, num shipping_fee, num installation_fee, num total, String customer_name, String customer_phone, String customer_email, String shipping_address, String tracking_number, String placed_at, Governorate? governorate, Branch? branch, List<OrderItem> items
});


$GovernorateCopyWith<$Res>? get governorate;$BranchCopyWith<$Res>? get branch;

}
/// @nodoc
class _$OrderCopyWithImpl<$Res>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._self, this._then);

  final Order _self;
  final $Res Function(Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? reference = null,Object? type = null,Object? status = null,Object? payment_method = null,Object? payment_status = null,Object? subtotal = null,Object? discount = null,Object? shipping_fee = null,Object? installation_fee = null,Object? total = null,Object? customer_name = null,Object? customer_phone = null,Object? customer_email = null,Object? shipping_address = null,Object? tracking_number = null,Object? placed_at = null,Object? governorate = freezed,Object? branch = freezed,Object? items = null,}) {
  return _then(Order(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,reference: null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,payment_method: null == payment_method ? _self.payment_method : payment_method // ignore: cast_nullable_to_non_nullable
as String,payment_status: null == payment_status ? _self.payment_status : payment_status // ignore: cast_nullable_to_non_nullable
as String,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as num,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as num,shipping_fee: null == shipping_fee ? _self.shipping_fee : shipping_fee // ignore: cast_nullable_to_non_nullable
as num,installation_fee: null == installation_fee ? _self.installation_fee : installation_fee // ignore: cast_nullable_to_non_nullable
as num,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as num,customer_name: null == customer_name ? _self.customer_name : customer_name // ignore: cast_nullable_to_non_nullable
as String,customer_phone: null == customer_phone ? _self.customer_phone : customer_phone // ignore: cast_nullable_to_non_nullable
as String,customer_email: null == customer_email ? _self.customer_email : customer_email // ignore: cast_nullable_to_non_nullable
as String,shipping_address: null == shipping_address ? _self.shipping_address : shipping_address // ignore: cast_nullable_to_non_nullable
as String,tracking_number: null == tracking_number ? _self.tracking_number : tracking_number // ignore: cast_nullable_to_non_nullable
as String,placed_at: null == placed_at ? _self.placed_at : placed_at // ignore: cast_nullable_to_non_nullable
as String,governorate: freezed == governorate ? _self.governorate : governorate // ignore: cast_nullable_to_non_nullable
as Governorate?,branch: freezed == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as Branch?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItem>,
  ));
}
/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GovernorateCopyWith<$Res>? get governorate {
    if (_self.governorate == null) {
    return null;
  }

  return $GovernorateCopyWith<$Res>(_self.governorate!, (value) {
    return _then(_self.copyWith(governorate: value));
  });
}/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BranchCopyWith<$Res>? get branch {
    if (_self.branch == null) {
    return null;
  }

  return $BranchCopyWith<$Res>(_self.branch!, (value) {
    return _then(_self.copyWith(branch: value));
  });
}
}


/// Adds pattern-matching-related methods to [Order].
extension OrderPatterns on Order {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Order value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Order() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Order value)  $default,){
final _that = this;
switch (_that) {
case _Order():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Order value)?  $default,){
final _that = this;
switch (_that) {
case _Order() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String reference,  String type,  String status,  String payment_method,  String payment_status,  num subtotal,  num discount,  num shipping_fee,  num installation_fee,  num total,  String customer_name,  String customer_phone,  String customer_email,  String shipping_address,  String tracking_number,  String placed_at,  Governorate? governorate,  Branch? branch,  List<OrderItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.reference,_that.type,_that.status,_that.payment_method,_that.payment_status,_that.subtotal,_that.discount,_that.shipping_fee,_that.installation_fee,_that.total,_that.customer_name,_that.customer_phone,_that.customer_email,_that.shipping_address,_that.tracking_number,_that.placed_at,_that.governorate,_that.branch,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String reference,  String type,  String status,  String payment_method,  String payment_status,  num subtotal,  num discount,  num shipping_fee,  num installation_fee,  num total,  String customer_name,  String customer_phone,  String customer_email,  String shipping_address,  String tracking_number,  String placed_at,  Governorate? governorate,  Branch? branch,  List<OrderItem> items)  $default,) {final _that = this;
switch (_that) {
case _Order():
return $default(_that.id,_that.reference,_that.type,_that.status,_that.payment_method,_that.payment_status,_that.subtotal,_that.discount,_that.shipping_fee,_that.installation_fee,_that.total,_that.customer_name,_that.customer_phone,_that.customer_email,_that.shipping_address,_that.tracking_number,_that.placed_at,_that.governorate,_that.branch,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String reference,  String type,  String status,  String payment_method,  String payment_status,  num subtotal,  num discount,  num shipping_fee,  num installation_fee,  num total,  String customer_name,  String customer_phone,  String customer_email,  String shipping_address,  String tracking_number,  String placed_at,  Governorate? governorate,  Branch? branch,  List<OrderItem> items)?  $default,) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.reference,_that.type,_that.status,_that.payment_method,_that.payment_status,_that.subtotal,_that.discount,_that.shipping_fee,_that.installation_fee,_that.total,_that.customer_name,_that.customer_phone,_that.customer_email,_that.shipping_address,_that.tracking_number,_that.placed_at,_that.governorate,_that.branch,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Order implements Order {
  const _Order({required this.id, required this.reference, required this.type, required this.status, required this.payment_method, required this.payment_status, required this.subtotal, required this.discount, required this.shipping_fee, required this.installation_fee, required this.total, required this.customer_name, required this.customer_phone, required this.customer_email, required this.shipping_address, required this.tracking_number, required this.placed_at, this.governorate, this.branch,  List<OrderItem> items = const <OrderItem>[]}): _items = items;
  factory _Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

@override final  int id;
@override final  String reference;
@override final  String type;
@override final  String status;
@override final  String payment_method;
@override final  String payment_status;
@override final  num subtotal;
@override final  num discount;
@override final  num shipping_fee;
@override final  num installation_fee;
@override final  num total;
@override final  String customer_name;
@override final  String customer_phone;
@override final  String customer_email;
@override final  String shipping_address;
@override final  String tracking_number;
@override final  String placed_at;
@override final  Governorate? governorate;
@override final  Branch? branch;
 final  List<OrderItem> _items;
@override@JsonKey() List<OrderItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderCopyWith<_Order> get copyWith => __$OrderCopyWithImpl<_Order>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Order&&(identical(other.id, id) || other.id == id)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.payment_method, payment_method) || other.payment_method == payment_method)&&(identical(other.payment_status, payment_status) || other.payment_status == payment_status)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.shipping_fee, shipping_fee) || other.shipping_fee == shipping_fee)&&(identical(other.installation_fee, installation_fee) || other.installation_fee == installation_fee)&&(identical(other.total, total) || other.total == total)&&(identical(other.customer_name, customer_name) || other.customer_name == customer_name)&&(identical(other.customer_phone, customer_phone) || other.customer_phone == customer_phone)&&(identical(other.customer_email, customer_email) || other.customer_email == customer_email)&&(identical(other.shipping_address, shipping_address) || other.shipping_address == shipping_address)&&(identical(other.tracking_number, tracking_number) || other.tracking_number == tracking_number)&&(identical(other.placed_at, placed_at) || other.placed_at == placed_at)&&(identical(other.governorate, governorate) || other.governorate == governorate)&&(identical(other.branch, branch) || other.branch == branch)&&const DeepCollectionEquality().equals(other.items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,reference,type,status,payment_method,payment_status,subtotal,discount,shipping_fee,installation_fee,total,customer_name,customer_phone,customer_email,shipping_address,tracking_number,placed_at,governorate,branch,const DeepCollectionEquality().hash(_items)]);
}

@override
String toString() {
    return 'Order(id: $id, reference: $reference, type: $type, status: $status, payment_method: $payment_method, payment_status: $payment_status, subtotal: $subtotal, discount: $discount, shipping_fee: $shipping_fee, installation_fee: $installation_fee, total: $total, customer_name: $customer_name, customer_phone: $customer_phone, customer_email: $customer_email, shipping_address: $shipping_address, tracking_number: $tracking_number, placed_at: $placed_at, governorate: $governorate, branch: $branch, items: $items)';
}


}

/// @nodoc
abstract mixin class _$OrderCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$OrderCopyWith(_Order value, $Res Function(_Order) _then) = __$OrderCopyWithImpl;
@override @useResult
$Res call({
 int id, String reference, String type, String status, String payment_method, String payment_status, num subtotal, num discount, num shipping_fee, num installation_fee, num total, String customer_name, String customer_phone, String customer_email, String shipping_address, String tracking_number, String placed_at, Governorate? governorate, Branch? branch, List<OrderItem> items
});


@override $GovernorateCopyWith<$Res>? get governorate;@override $BranchCopyWith<$Res>? get branch;

}
/// @nodoc
class __$OrderCopyWithImpl<$Res>
    implements _$OrderCopyWith<$Res> {
  __$OrderCopyWithImpl(this._self, this._then);

  final _Order _self;
  final $Res Function(_Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? reference = null,Object? type = null,Object? status = null,Object? payment_method = null,Object? payment_status = null,Object? subtotal = null,Object? discount = null,Object? shipping_fee = null,Object? installation_fee = null,Object? total = null,Object? customer_name = null,Object? customer_phone = null,Object? customer_email = null,Object? shipping_address = null,Object? tracking_number = null,Object? placed_at = null,Object? governorate = freezed,Object? branch = freezed,Object? items = null,}) {
  return _then(_Order(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,reference: null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,payment_method: null == payment_method ? _self.payment_method : payment_method // ignore: cast_nullable_to_non_nullable
as String,payment_status: null == payment_status ? _self.payment_status : payment_status // ignore: cast_nullable_to_non_nullable
as String,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as num,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as num,shipping_fee: null == shipping_fee ? _self.shipping_fee : shipping_fee // ignore: cast_nullable_to_non_nullable
as num,installation_fee: null == installation_fee ? _self.installation_fee : installation_fee // ignore: cast_nullable_to_non_nullable
as num,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as num,customer_name: null == customer_name ? _self.customer_name : customer_name // ignore: cast_nullable_to_non_nullable
as String,customer_phone: null == customer_phone ? _self.customer_phone : customer_phone // ignore: cast_nullable_to_non_nullable
as String,customer_email: null == customer_email ? _self.customer_email : customer_email // ignore: cast_nullable_to_non_nullable
as String,shipping_address: null == shipping_address ? _self.shipping_address : shipping_address // ignore: cast_nullable_to_non_nullable
as String,tracking_number: null == tracking_number ? _self.tracking_number : tracking_number // ignore: cast_nullable_to_non_nullable
as String,placed_at: null == placed_at ? _self.placed_at : placed_at // ignore: cast_nullable_to_non_nullable
as String,governorate: freezed == governorate ? _self.governorate : governorate // ignore: cast_nullable_to_non_nullable
as Governorate?,branch: freezed == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as Branch?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItem>,
  ));
}

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GovernorateCopyWith<$Res>? get governorate {
    if (_self.governorate == null) {
    return null;
  }

  return $GovernorateCopyWith<$Res>(_self.governorate!, (value) {
    return _then(_self.copyWith(governorate: value));
  });
}/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BranchCopyWith<$Res>? get branch {
    if (_self.branch == null) {
    return null;
  }

  return $BranchCopyWith<$Res>(_self.branch!, (value) {
    return _then(_self.copyWith(branch: value));
  });
}
}


/// @nodoc
mixin _$OrderItem {

 int get id; int get product_id; String get product_name; String get product_sku; int get quantity; num get unit_price; num get total;
/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderItemCopyWith<OrderItem> get copyWith => _$OrderItemCopyWithImpl<OrderItem>(this as OrderItem, _$identity);

  /// Serializes this OrderItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OrderItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.product_id, _this.product_id) || other.product_id == _this.product_id)&&(identical(other.product_name, _this.product_name) || other.product_name == _this.product_name)&&(identical(other.product_sku, _this.product_sku) || other.product_sku == _this.product_sku)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.unit_price, _this.unit_price) || other.unit_price == _this.unit_price)&&(identical(other.total, _this.total) || other.total == _this.total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OrderItem;
  return Object.hash(runtimeType,_this.id,_this.product_id,_this.product_name,_this.product_sku,_this.quantity,_this.unit_price,_this.total);
}

@override
String toString() {
  final _this = this as OrderItem;
  return 'OrderItem(id: ${_this.id}, product_id: ${_this.product_id}, product_name: ${_this.product_name}, product_sku: ${_this.product_sku}, quantity: ${_this.quantity}, unit_price: ${_this.unit_price}, total: ${_this.total})';
}


}

/// @nodoc
abstract mixin class $OrderItemCopyWith<$Res>  {
  factory $OrderItemCopyWith(OrderItem value, $Res Function(OrderItem) _then) = _$OrderItemCopyWithImpl;
@useResult
$Res call({
 int id, int product_id, String product_name, String product_sku, int quantity, num unit_price, num total
});




}
/// @nodoc
class _$OrderItemCopyWithImpl<$Res>
    implements $OrderItemCopyWith<$Res> {
  _$OrderItemCopyWithImpl(this._self, this._then);

  final OrderItem _self;
  final $Res Function(OrderItem) _then;

/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? product_id = null,Object? product_name = null,Object? product_sku = null,Object? quantity = null,Object? unit_price = null,Object? total = null,}) {
  return _then(OrderItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,product_id: null == product_id ? _self.product_id : product_id // ignore: cast_nullable_to_non_nullable
as int,product_name: null == product_name ? _self.product_name : product_name // ignore: cast_nullable_to_non_nullable
as String,product_sku: null == product_sku ? _self.product_sku : product_sku // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unit_price: null == unit_price ? _self.unit_price : unit_price // ignore: cast_nullable_to_non_nullable
as num,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderItem].
extension OrderItemPatterns on OrderItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderItem value)  $default,){
final _that = this;
switch (_that) {
case _OrderItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderItem value)?  $default,){
final _that = this;
switch (_that) {
case _OrderItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int product_id,  String product_name,  String product_sku,  int quantity,  num unit_price,  num total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderItem() when $default != null:
return $default(_that.id,_that.product_id,_that.product_name,_that.product_sku,_that.quantity,_that.unit_price,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int product_id,  String product_name,  String product_sku,  int quantity,  num unit_price,  num total)  $default,) {final _that = this;
switch (_that) {
case _OrderItem():
return $default(_that.id,_that.product_id,_that.product_name,_that.product_sku,_that.quantity,_that.unit_price,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int product_id,  String product_name,  String product_sku,  int quantity,  num unit_price,  num total)?  $default,) {final _that = this;
switch (_that) {
case _OrderItem() when $default != null:
return $default(_that.id,_that.product_id,_that.product_name,_that.product_sku,_that.quantity,_that.unit_price,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderItem implements OrderItem {
  const _OrderItem({required this.id, required this.product_id, required this.product_name, required this.product_sku, required this.quantity, required this.unit_price, required this.total});
  factory _OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);

@override final  int id;
@override final  int product_id;
@override final  String product_name;
@override final  String product_sku;
@override final  int quantity;
@override final  num unit_price;
@override final  num total;

/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderItemCopyWith<_OrderItem> get copyWith => __$OrderItemCopyWithImpl<_OrderItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderItem&&(identical(other.id, id) || other.id == id)&&(identical(other.product_id, product_id) || other.product_id == product_id)&&(identical(other.product_name, product_name) || other.product_name == product_name)&&(identical(other.product_sku, product_sku) || other.product_sku == product_sku)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit_price, unit_price) || other.unit_price == unit_price)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,product_id,product_name,product_sku,quantity,unit_price,total);
}

@override
String toString() {
    return 'OrderItem(id: $id, product_id: $product_id, product_name: $product_name, product_sku: $product_sku, quantity: $quantity, unit_price: $unit_price, total: $total)';
}


}

/// @nodoc
abstract mixin class _$OrderItemCopyWith<$Res> implements $OrderItemCopyWith<$Res> {
  factory _$OrderItemCopyWith(_OrderItem value, $Res Function(_OrderItem) _then) = __$OrderItemCopyWithImpl;
@override @useResult
$Res call({
 int id, int product_id, String product_name, String product_sku, int quantity, num unit_price, num total
});




}
/// @nodoc
class __$OrderItemCopyWithImpl<$Res>
    implements _$OrderItemCopyWith<$Res> {
  __$OrderItemCopyWithImpl(this._self, this._then);

  final _OrderItem _self;
  final $Res Function(_OrderItem) _then;

/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? product_id = null,Object? product_name = null,Object? product_sku = null,Object? quantity = null,Object? unit_price = null,Object? total = null,}) {
  return _then(_OrderItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,product_id: null == product_id ? _self.product_id : product_id // ignore: cast_nullable_to_non_nullable
as int,product_name: null == product_name ? _self.product_name : product_name // ignore: cast_nullable_to_non_nullable
as String,product_sku: null == product_sku ? _self.product_sku : product_sku // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unit_price: null == unit_price ? _self.unit_price : unit_price // ignore: cast_nullable_to_non_nullable
as num,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

// dart format on
