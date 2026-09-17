// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_cart.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomerCart {

 int get id; List<CartItem> get items; num get subtotal; int get items_count; int? get governorate_id; Governorate? get governorate;
/// Create a copy of CustomerCart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerCartCopyWith<CustomerCart> get copyWith => _$CustomerCartCopyWithImpl<CustomerCart>(this as CustomerCart, _$identity);

  /// Serializes this CustomerCart to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CustomerCart;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerCart&&(identical(other.id, _this.id) || other.id == _this.id)&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.subtotal, _this.subtotal) || other.subtotal == _this.subtotal)&&(identical(other.items_count, _this.items_count) || other.items_count == _this.items_count)&&(identical(other.governorate_id, _this.governorate_id) || other.governorate_id == _this.governorate_id)&&(identical(other.governorate, _this.governorate) || other.governorate == _this.governorate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CustomerCart;
  return Object.hash(runtimeType,_this.id,const DeepCollectionEquality().hash(_this.items),_this.subtotal,_this.items_count,_this.governorate_id,_this.governorate);
}

@override
String toString() {
  final _this = this as CustomerCart;
  return 'CustomerCart(id: ${_this.id}, items: ${_this.items}, subtotal: ${_this.subtotal}, items_count: ${_this.items_count}, governorate_id: ${_this.governorate_id}, governorate: ${_this.governorate})';
}


}

/// @nodoc
abstract mixin class $CustomerCartCopyWith<$Res>  {
  factory $CustomerCartCopyWith(CustomerCart value, $Res Function(CustomerCart) _then) = _$CustomerCartCopyWithImpl;
@useResult
$Res call({
 int id, List<CartItem> items, num subtotal, int items_count, int? governorate_id, Governorate? governorate
});


$GovernorateCopyWith<$Res>? get governorate;

}
/// @nodoc
class _$CustomerCartCopyWithImpl<$Res>
    implements $CustomerCartCopyWith<$Res> {
  _$CustomerCartCopyWithImpl(this._self, this._then);

  final CustomerCart _self;
  final $Res Function(CustomerCart) _then;

/// Create a copy of CustomerCart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? items = null,Object? subtotal = null,Object? items_count = null,Object? governorate_id = freezed,Object? governorate = freezed,}) {
  return _then(CustomerCart(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CartItem>,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as num,items_count: null == items_count ? _self.items_count : items_count // ignore: cast_nullable_to_non_nullable
as int,governorate_id: freezed == governorate_id ? _self.governorate_id : governorate_id // ignore: cast_nullable_to_non_nullable
as int?,governorate: freezed == governorate ? _self.governorate : governorate // ignore: cast_nullable_to_non_nullable
as Governorate?,
  ));
}
/// Create a copy of CustomerCart
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
}
}


/// Adds pattern-matching-related methods to [CustomerCart].
extension CustomerCartPatterns on CustomerCart {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerCart value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerCart() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerCart value)  $default,){
final _that = this;
switch (_that) {
case _CustomerCart():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerCart value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerCart() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  List<CartItem> items,  num subtotal,  int items_count,  int? governorate_id,  Governorate? governorate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerCart() when $default != null:
return $default(_that.id,_that.items,_that.subtotal,_that.items_count,_that.governorate_id,_that.governorate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  List<CartItem> items,  num subtotal,  int items_count,  int? governorate_id,  Governorate? governorate)  $default,) {final _that = this;
switch (_that) {
case _CustomerCart():
return $default(_that.id,_that.items,_that.subtotal,_that.items_count,_that.governorate_id,_that.governorate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  List<CartItem> items,  num subtotal,  int items_count,  int? governorate_id,  Governorate? governorate)?  $default,) {final _that = this;
switch (_that) {
case _CustomerCart() when $default != null:
return $default(_that.id,_that.items,_that.subtotal,_that.items_count,_that.governorate_id,_that.governorate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomerCart implements CustomerCart {
  const _CustomerCart({required this.id,  List<CartItem> items = const <CartItem>[], required this.subtotal, required this.items_count, this.governorate_id, this.governorate}): _items = items;
  factory _CustomerCart.fromJson(Map<String, dynamic> json) => _$CustomerCartFromJson(json);

@override final  int id;
 final  List<CartItem> _items;
@override@JsonKey() List<CartItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  num subtotal;
@override final  int items_count;
@override final  int? governorate_id;
@override final  Governorate? governorate;

/// Create a copy of CustomerCart
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerCartCopyWith<_CustomerCart> get copyWith => __$CustomerCartCopyWithImpl<_CustomerCart>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerCartToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerCart&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.items_count, items_count) || other.items_count == items_count)&&(identical(other.governorate_id, governorate_id) || other.governorate_id == governorate_id)&&(identical(other.governorate, governorate) || other.governorate == governorate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_items),subtotal,items_count,governorate_id,governorate);
}

@override
String toString() {
    return 'CustomerCart(id: $id, items: $items, subtotal: $subtotal, items_count: $items_count, governorate_id: $governorate_id, governorate: $governorate)';
}


}

/// @nodoc
abstract mixin class _$CustomerCartCopyWith<$Res> implements $CustomerCartCopyWith<$Res> {
  factory _$CustomerCartCopyWith(_CustomerCart value, $Res Function(_CustomerCart) _then) = __$CustomerCartCopyWithImpl;
@override @useResult
$Res call({
 int id, List<CartItem> items, num subtotal, int items_count, int? governorate_id, Governorate? governorate
});


@override $GovernorateCopyWith<$Res>? get governorate;

}
/// @nodoc
class __$CustomerCartCopyWithImpl<$Res>
    implements _$CustomerCartCopyWith<$Res> {
  __$CustomerCartCopyWithImpl(this._self, this._then);

  final _CustomerCart _self;
  final $Res Function(_CustomerCart) _then;

/// Create a copy of CustomerCart
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? items = null,Object? subtotal = null,Object? items_count = null,Object? governorate_id = freezed,Object? governorate = freezed,}) {
  return _then(_CustomerCart(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CartItem>,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as num,items_count: null == items_count ? _self.items_count : items_count // ignore: cast_nullable_to_non_nullable
as int,governorate_id: freezed == governorate_id ? _self.governorate_id : governorate_id // ignore: cast_nullable_to_non_nullable
as int?,governorate: freezed == governorate ? _self.governorate : governorate // ignore: cast_nullable_to_non_nullable
as Governorate?,
  ));
}

/// Create a copy of CustomerCart
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
}
}

// dart format on
