// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'apply_offer_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApplyOfferResult {

 num get discount; num get subtotal; num get total; AppliedOffer get offer;
/// Create a copy of ApplyOfferResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplyOfferResultCopyWith<ApplyOfferResult> get copyWith => _$ApplyOfferResultCopyWithImpl<ApplyOfferResult>(this as ApplyOfferResult, _$identity);

  /// Serializes this ApplyOfferResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ApplyOfferResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApplyOfferResult&&(identical(other.discount, _this.discount) || other.discount == _this.discount)&&(identical(other.subtotal, _this.subtotal) || other.subtotal == _this.subtotal)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.offer, _this.offer) || other.offer == _this.offer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ApplyOfferResult;
  return Object.hash(runtimeType,_this.discount,_this.subtotal,_this.total,_this.offer);
}

@override
String toString() {
  final _this = this as ApplyOfferResult;
  return 'ApplyOfferResult(discount: ${_this.discount}, subtotal: ${_this.subtotal}, total: ${_this.total}, offer: ${_this.offer})';
}


}

/// @nodoc
abstract mixin class $ApplyOfferResultCopyWith<$Res>  {
  factory $ApplyOfferResultCopyWith(ApplyOfferResult value, $Res Function(ApplyOfferResult) _then) = _$ApplyOfferResultCopyWithImpl;
@useResult
$Res call({
 num discount, num subtotal, num total, AppliedOffer offer
});


$AppliedOfferCopyWith<$Res> get offer;

}
/// @nodoc
class _$ApplyOfferResultCopyWithImpl<$Res>
    implements $ApplyOfferResultCopyWith<$Res> {
  _$ApplyOfferResultCopyWithImpl(this._self, this._then);

  final ApplyOfferResult _self;
  final $Res Function(ApplyOfferResult) _then;

/// Create a copy of ApplyOfferResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? discount = null,Object? subtotal = null,Object? total = null,Object? offer = null,}) {
  return _then(ApplyOfferResult(
discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as num,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as num,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as num,offer: null == offer ? _self.offer : offer // ignore: cast_nullable_to_non_nullable
as AppliedOffer,
  ));
}
/// Create a copy of ApplyOfferResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppliedOfferCopyWith<$Res> get offer {
  
  return $AppliedOfferCopyWith<$Res>(_self.offer, (value) {
    return _then(_self.copyWith(offer: value));
  });
}
}


/// Adds pattern-matching-related methods to [ApplyOfferResult].
extension ApplyOfferResultPatterns on ApplyOfferResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApplyOfferResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApplyOfferResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApplyOfferResult value)  $default,){
final _that = this;
switch (_that) {
case _ApplyOfferResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApplyOfferResult value)?  $default,){
final _that = this;
switch (_that) {
case _ApplyOfferResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( num discount,  num subtotal,  num total,  AppliedOffer offer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApplyOfferResult() when $default != null:
return $default(_that.discount,_that.subtotal,_that.total,_that.offer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( num discount,  num subtotal,  num total,  AppliedOffer offer)  $default,) {final _that = this;
switch (_that) {
case _ApplyOfferResult():
return $default(_that.discount,_that.subtotal,_that.total,_that.offer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( num discount,  num subtotal,  num total,  AppliedOffer offer)?  $default,) {final _that = this;
switch (_that) {
case _ApplyOfferResult() when $default != null:
return $default(_that.discount,_that.subtotal,_that.total,_that.offer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApplyOfferResult implements ApplyOfferResult {
  const _ApplyOfferResult({required this.discount, required this.subtotal, required this.total, required this.offer});
  factory _ApplyOfferResult.fromJson(Map<String, dynamic> json) => _$ApplyOfferResultFromJson(json);

@override final  num discount;
@override final  num subtotal;
@override final  num total;
@override final  AppliedOffer offer;

/// Create a copy of ApplyOfferResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApplyOfferResultCopyWith<_ApplyOfferResult> get copyWith => __$ApplyOfferResultCopyWithImpl<_ApplyOfferResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApplyOfferResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApplyOfferResult&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.total, total) || other.total == total)&&(identical(other.offer, offer) || other.offer == offer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,discount,subtotal,total,offer);
}

@override
String toString() {
    return 'ApplyOfferResult(discount: $discount, subtotal: $subtotal, total: $total, offer: $offer)';
}


}

/// @nodoc
abstract mixin class _$ApplyOfferResultCopyWith<$Res> implements $ApplyOfferResultCopyWith<$Res> {
  factory _$ApplyOfferResultCopyWith(_ApplyOfferResult value, $Res Function(_ApplyOfferResult) _then) = __$ApplyOfferResultCopyWithImpl;
@override @useResult
$Res call({
 num discount, num subtotal, num total, AppliedOffer offer
});


@override $AppliedOfferCopyWith<$Res> get offer;

}
/// @nodoc
class __$ApplyOfferResultCopyWithImpl<$Res>
    implements _$ApplyOfferResultCopyWith<$Res> {
  __$ApplyOfferResultCopyWithImpl(this._self, this._then);

  final _ApplyOfferResult _self;
  final $Res Function(_ApplyOfferResult) _then;

/// Create a copy of ApplyOfferResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? discount = null,Object? subtotal = null,Object? total = null,Object? offer = null,}) {
  return _then(_ApplyOfferResult(
discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as num,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as num,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as num,offer: null == offer ? _self.offer : offer // ignore: cast_nullable_to_non_nullable
as AppliedOffer,
  ));
}

/// Create a copy of ApplyOfferResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppliedOfferCopyWith<$Res> get offer {
  
  return $AppliedOfferCopyWith<$Res>(_self.offer, (value) {
    return _then(_self.copyWith(offer: value));
  });
}
}


/// @nodoc
mixin _$AppliedOffer {

 String get code; String get title;
/// Create a copy of AppliedOffer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppliedOfferCopyWith<AppliedOffer> get copyWith => _$AppliedOfferCopyWithImpl<AppliedOffer>(this as AppliedOffer, _$identity);

  /// Serializes this AppliedOffer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AppliedOffer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppliedOffer&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.title, _this.title) || other.title == _this.title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AppliedOffer;
  return Object.hash(runtimeType,_this.code,_this.title);
}

@override
String toString() {
  final _this = this as AppliedOffer;
  return 'AppliedOffer(code: ${_this.code}, title: ${_this.title})';
}


}

/// @nodoc
abstract mixin class $AppliedOfferCopyWith<$Res>  {
  factory $AppliedOfferCopyWith(AppliedOffer value, $Res Function(AppliedOffer) _then) = _$AppliedOfferCopyWithImpl;
@useResult
$Res call({
 String code, String title
});




}
/// @nodoc
class _$AppliedOfferCopyWithImpl<$Res>
    implements $AppliedOfferCopyWith<$Res> {
  _$AppliedOfferCopyWithImpl(this._self, this._then);

  final AppliedOffer _self;
  final $Res Function(AppliedOffer) _then;

/// Create a copy of AppliedOffer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? title = null,}) {
  return _then(AppliedOffer(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppliedOffer].
extension AppliedOfferPatterns on AppliedOffer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppliedOffer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppliedOffer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppliedOffer value)  $default,){
final _that = this;
switch (_that) {
case _AppliedOffer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppliedOffer value)?  $default,){
final _that = this;
switch (_that) {
case _AppliedOffer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String title)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppliedOffer() when $default != null:
return $default(_that.code,_that.title);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String title)  $default,) {final _that = this;
switch (_that) {
case _AppliedOffer():
return $default(_that.code,_that.title);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String title)?  $default,) {final _that = this;
switch (_that) {
case _AppliedOffer() when $default != null:
return $default(_that.code,_that.title);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppliedOffer implements AppliedOffer {
  const _AppliedOffer({required this.code, required this.title});
  factory _AppliedOffer.fromJson(Map<String, dynamic> json) => _$AppliedOfferFromJson(json);

@override final  String code;
@override final  String title;

/// Create a copy of AppliedOffer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppliedOfferCopyWith<_AppliedOffer> get copyWith => __$AppliedOfferCopyWithImpl<_AppliedOffer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppliedOfferToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppliedOffer&&(identical(other.code, code) || other.code == code)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,code,title);
}

@override
String toString() {
    return 'AppliedOffer(code: $code, title: $title)';
}


}

/// @nodoc
abstract mixin class _$AppliedOfferCopyWith<$Res> implements $AppliedOfferCopyWith<$Res> {
  factory _$AppliedOfferCopyWith(_AppliedOffer value, $Res Function(_AppliedOffer) _then) = __$AppliedOfferCopyWithImpl;
@override @useResult
$Res call({
 String code, String title
});




}
/// @nodoc
class __$AppliedOfferCopyWithImpl<$Res>
    implements _$AppliedOfferCopyWith<$Res> {
  __$AppliedOfferCopyWithImpl(this._self, this._then);

  final _AppliedOffer _self;
  final $Res Function(_AppliedOffer) _then;

/// Create a copy of AppliedOffer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? title = null,}) {
  return _then(_AppliedOffer(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
