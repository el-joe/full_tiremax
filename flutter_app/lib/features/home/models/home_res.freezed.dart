// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_res.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomeRes {

 List<Product> get featured; List<Product> get best_sellers; List<Product> get new_arrivals; List<Product> get offers; List<Brand> get brands; List<Governorate> get governorates;
/// Create a copy of HomeRes
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeResCopyWith<HomeRes> get copyWith => _$HomeResCopyWithImpl<HomeRes>(this as HomeRes, _$identity);

  /// Serializes this HomeRes to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HomeRes;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeRes&&const DeepCollectionEquality().equals(other.featured, _this.featured)&&const DeepCollectionEquality().equals(other.best_sellers, _this.best_sellers)&&const DeepCollectionEquality().equals(other.new_arrivals, _this.new_arrivals)&&const DeepCollectionEquality().equals(other.offers, _this.offers)&&const DeepCollectionEquality().equals(other.brands, _this.brands)&&const DeepCollectionEquality().equals(other.governorates, _this.governorates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HomeRes;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.featured),const DeepCollectionEquality().hash(_this.best_sellers),const DeepCollectionEquality().hash(_this.new_arrivals),const DeepCollectionEquality().hash(_this.offers),const DeepCollectionEquality().hash(_this.brands),const DeepCollectionEquality().hash(_this.governorates));
}

@override
String toString() {
  final _this = this as HomeRes;
  return 'HomeRes(featured: ${_this.featured}, best_sellers: ${_this.best_sellers}, new_arrivals: ${_this.new_arrivals}, offers: ${_this.offers}, brands: ${_this.brands}, governorates: ${_this.governorates})';
}


}

/// @nodoc
abstract mixin class $HomeResCopyWith<$Res>  {
  factory $HomeResCopyWith(HomeRes value, $Res Function(HomeRes) _then) = _$HomeResCopyWithImpl;
@useResult
$Res call({
 List<Product> featured, List<Product> best_sellers, List<Product> new_arrivals, List<Product> offers, List<Brand> brands, List<Governorate> governorates
});




}
/// @nodoc
class _$HomeResCopyWithImpl<$Res>
    implements $HomeResCopyWith<$Res> {
  _$HomeResCopyWithImpl(this._self, this._then);

  final HomeRes _self;
  final $Res Function(HomeRes) _then;

/// Create a copy of HomeRes
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? featured = null,Object? best_sellers = null,Object? new_arrivals = null,Object? offers = null,Object? brands = null,Object? governorates = null,}) {
  return _then(HomeRes(
featured: null == featured ? _self.featured : featured // ignore: cast_nullable_to_non_nullable
as List<Product>,best_sellers: null == best_sellers ? _self.best_sellers : best_sellers // ignore: cast_nullable_to_non_nullable
as List<Product>,new_arrivals: null == new_arrivals ? _self.new_arrivals : new_arrivals // ignore: cast_nullable_to_non_nullable
as List<Product>,offers: null == offers ? _self.offers : offers // ignore: cast_nullable_to_non_nullable
as List<Product>,brands: null == brands ? _self.brands : brands // ignore: cast_nullable_to_non_nullable
as List<Brand>,governorates: null == governorates ? _self.governorates : governorates // ignore: cast_nullable_to_non_nullable
as List<Governorate>,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeRes].
extension HomeResPatterns on HomeRes {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeRes value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeRes() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeRes value)  $default,){
final _that = this;
switch (_that) {
case _HomeRes():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeRes value)?  $default,){
final _that = this;
switch (_that) {
case _HomeRes() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Product> featured,  List<Product> best_sellers,  List<Product> new_arrivals,  List<Product> offers,  List<Brand> brands,  List<Governorate> governorates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeRes() when $default != null:
return $default(_that.featured,_that.best_sellers,_that.new_arrivals,_that.offers,_that.brands,_that.governorates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Product> featured,  List<Product> best_sellers,  List<Product> new_arrivals,  List<Product> offers,  List<Brand> brands,  List<Governorate> governorates)  $default,) {final _that = this;
switch (_that) {
case _HomeRes():
return $default(_that.featured,_that.best_sellers,_that.new_arrivals,_that.offers,_that.brands,_that.governorates);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Product> featured,  List<Product> best_sellers,  List<Product> new_arrivals,  List<Product> offers,  List<Brand> brands,  List<Governorate> governorates)?  $default,) {final _that = this;
switch (_that) {
case _HomeRes() when $default != null:
return $default(_that.featured,_that.best_sellers,_that.new_arrivals,_that.offers,_that.brands,_that.governorates);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HomeRes implements HomeRes {
  const _HomeRes({ List<Product> featured = const <Product>[],  List<Product> best_sellers = const <Product>[],  List<Product> new_arrivals = const <Product>[],  List<Product> offers = const <Product>[],  List<Brand> brands = const <Brand>[],  List<Governorate> governorates = const <Governorate>[]}): _featured = featured,_best_sellers = best_sellers,_new_arrivals = new_arrivals,_offers = offers,_brands = brands,_governorates = governorates;
  factory _HomeRes.fromJson(Map<String, dynamic> json) => _$HomeResFromJson(json);

 final  List<Product> _featured;
@override@JsonKey() List<Product> get featured {
  if (_featured is EqualUnmodifiableListView) return _featured;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_featured);
}

 final  List<Product> _best_sellers;
@override@JsonKey() List<Product> get best_sellers {
  if (_best_sellers is EqualUnmodifiableListView) return _best_sellers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_best_sellers);
}

 final  List<Product> _new_arrivals;
@override@JsonKey() List<Product> get new_arrivals {
  if (_new_arrivals is EqualUnmodifiableListView) return _new_arrivals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_new_arrivals);
}

 final  List<Product> _offers;
@override@JsonKey() List<Product> get offers {
  if (_offers is EqualUnmodifiableListView) return _offers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_offers);
}

 final  List<Brand> _brands;
@override@JsonKey() List<Brand> get brands {
  if (_brands is EqualUnmodifiableListView) return _brands;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_brands);
}

 final  List<Governorate> _governorates;
@override@JsonKey() List<Governorate> get governorates {
  if (_governorates is EqualUnmodifiableListView) return _governorates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_governorates);
}


/// Create a copy of HomeRes
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeResCopyWith<_HomeRes> get copyWith => __$HomeResCopyWithImpl<_HomeRes>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HomeResToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeRes&&const DeepCollectionEquality().equals(other.featured, _featured)&&const DeepCollectionEquality().equals(other.best_sellers, _best_sellers)&&const DeepCollectionEquality().equals(other.new_arrivals, _new_arrivals)&&const DeepCollectionEquality().equals(other.offers, _offers)&&const DeepCollectionEquality().equals(other.brands, _brands)&&const DeepCollectionEquality().equals(other.governorates, _governorates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_featured),const DeepCollectionEquality().hash(_best_sellers),const DeepCollectionEquality().hash(_new_arrivals),const DeepCollectionEquality().hash(_offers),const DeepCollectionEquality().hash(_brands),const DeepCollectionEquality().hash(_governorates));
}

@override
String toString() {
    return 'HomeRes(featured: $featured, best_sellers: $best_sellers, new_arrivals: $new_arrivals, offers: $offers, brands: $brands, governorates: $governorates)';
}


}

/// @nodoc
abstract mixin class _$HomeResCopyWith<$Res> implements $HomeResCopyWith<$Res> {
  factory _$HomeResCopyWith(_HomeRes value, $Res Function(_HomeRes) _then) = __$HomeResCopyWithImpl;
@override @useResult
$Res call({
 List<Product> featured, List<Product> best_sellers, List<Product> new_arrivals, List<Product> offers, List<Brand> brands, List<Governorate> governorates
});




}
/// @nodoc
class __$HomeResCopyWithImpl<$Res>
    implements _$HomeResCopyWith<$Res> {
  __$HomeResCopyWithImpl(this._self, this._then);

  final _HomeRes _self;
  final $Res Function(_HomeRes) _then;

/// Create a copy of HomeRes
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? featured = null,Object? best_sellers = null,Object? new_arrivals = null,Object? offers = null,Object? brands = null,Object? governorates = null,}) {
  return _then(_HomeRes(
featured: null == featured ? _self._featured : featured // ignore: cast_nullable_to_non_nullable
as List<Product>,best_sellers: null == best_sellers ? _self._best_sellers : best_sellers // ignore: cast_nullable_to_non_nullable
as List<Product>,new_arrivals: null == new_arrivals ? _self._new_arrivals : new_arrivals // ignore: cast_nullable_to_non_nullable
as List<Product>,offers: null == offers ? _self._offers : offers // ignore: cast_nullable_to_non_nullable
as List<Product>,brands: null == brands ? _self._brands : brands // ignore: cast_nullable_to_non_nullable
as List<Brand>,governorates: null == governorates ? _self._governorates : governorates // ignore: cast_nullable_to_non_nullable
as List<Governorate>,
  ));
}


}

// dart format on
