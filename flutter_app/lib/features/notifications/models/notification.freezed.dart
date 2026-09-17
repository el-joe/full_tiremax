// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppNotification {

 String get id; String get type;@JsonKey(fromJson: _notificationDataFromJson, toJson: _notificationDataToJson) NotificationData get data; String? get read_at; DateTime get created_at;
/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppNotificationCopyWith<AppNotification> get copyWith => _$AppNotificationCopyWithImpl<AppNotification>(this as AppNotification, _$identity);

  /// Serializes this AppNotification to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AppNotification;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppNotification&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.data, _this.data) || other.data == _this.data)&&(identical(other.read_at, _this.read_at) || other.read_at == _this.read_at)&&(identical(other.created_at, _this.created_at) || other.created_at == _this.created_at));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AppNotification;
  return Object.hash(runtimeType,_this.id,_this.type,_this.data,_this.read_at,_this.created_at);
}

@override
String toString() {
  final _this = this as AppNotification;
  return 'AppNotification(id: ${_this.id}, type: ${_this.type}, data: ${_this.data}, read_at: ${_this.read_at}, created_at: ${_this.created_at})';
}


}

/// @nodoc
abstract mixin class $AppNotificationCopyWith<$Res>  {
  factory $AppNotificationCopyWith(AppNotification value, $Res Function(AppNotification) _then) = _$AppNotificationCopyWithImpl;
@useResult
$Res call({
 String id, String type,@JsonKey(fromJson: _notificationDataFromJson, toJson: _notificationDataToJson) NotificationData data, String? read_at, DateTime created_at
});


$NotificationDataCopyWith<$Res> get data;

}
/// @nodoc
class _$AppNotificationCopyWithImpl<$Res>
    implements $AppNotificationCopyWith<$Res> {
  _$AppNotificationCopyWithImpl(this._self, this._then);

  final AppNotification _self;
  final $Res Function(AppNotification) _then;

/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? data = null,Object? read_at = freezed,Object? created_at = null,}) {
  return _then(AppNotification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as NotificationData,read_at: freezed == read_at ? _self.read_at : read_at // ignore: cast_nullable_to_non_nullable
as String?,created_at: null == created_at ? _self.created_at : created_at // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationDataCopyWith<$Res> get data {
  
  return $NotificationDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppNotification].
extension AppNotificationPatterns on AppNotification {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppNotification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppNotification value)  $default,){
final _that = this;
switch (_that) {
case _AppNotification():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppNotification value)?  $default,){
final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type, @JsonKey(fromJson: _notificationDataFromJson, toJson: _notificationDataToJson)  NotificationData data,  String? read_at,  DateTime created_at)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
return $default(_that.id,_that.type,_that.data,_that.read_at,_that.created_at);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type, @JsonKey(fromJson: _notificationDataFromJson, toJson: _notificationDataToJson)  NotificationData data,  String? read_at,  DateTime created_at)  $default,) {final _that = this;
switch (_that) {
case _AppNotification():
return $default(_that.id,_that.type,_that.data,_that.read_at,_that.created_at);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type, @JsonKey(fromJson: _notificationDataFromJson, toJson: _notificationDataToJson)  NotificationData data,  String? read_at,  DateTime created_at)?  $default,) {final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
return $default(_that.id,_that.type,_that.data,_that.read_at,_that.created_at);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppNotification extends AppNotification {
  const _AppNotification({required this.id, required this.type, @JsonKey(fromJson: _notificationDataFromJson, toJson: _notificationDataToJson) required this.data, this.read_at, required this.created_at}): super._();
  factory _AppNotification.fromJson(Map<String, dynamic> json) => _$AppNotificationFromJson(json);

@override final  String id;
@override final  String type;
@override@JsonKey(fromJson: _notificationDataFromJson, toJson: _notificationDataToJson) final  NotificationData data;
@override final  String? read_at;
@override final  DateTime created_at;

/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppNotificationCopyWith<_AppNotification> get copyWith => __$AppNotificationCopyWithImpl<_AppNotification>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppNotificationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppNotification&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.data, data) || other.data == data)&&(identical(other.read_at, read_at) || other.read_at == read_at)&&(identical(other.created_at, created_at) || other.created_at == created_at));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,type,data,read_at,created_at);
}

@override
String toString() {
    return 'AppNotification(id: $id, type: $type, data: $data, read_at: $read_at, created_at: $created_at)';
}


}

/// @nodoc
abstract mixin class _$AppNotificationCopyWith<$Res> implements $AppNotificationCopyWith<$Res> {
  factory _$AppNotificationCopyWith(_AppNotification value, $Res Function(_AppNotification) _then) = __$AppNotificationCopyWithImpl;
@override @useResult
$Res call({
 String id, String type,@JsonKey(fromJson: _notificationDataFromJson, toJson: _notificationDataToJson) NotificationData data, String? read_at, DateTime created_at
});


@override $NotificationDataCopyWith<$Res> get data;

}
/// @nodoc
class __$AppNotificationCopyWithImpl<$Res>
    implements _$AppNotificationCopyWith<$Res> {
  __$AppNotificationCopyWithImpl(this._self, this._then);

  final _AppNotification _self;
  final $Res Function(_AppNotification) _then;

/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? data = null,Object? read_at = freezed,Object? created_at = null,}) {
  return _then(_AppNotification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as NotificationData,read_at: freezed == read_at ? _self.read_at : read_at // ignore: cast_nullable_to_non_nullable
as String?,created_at: null == created_at ? _self.created_at : created_at // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationDataCopyWith<$Res> get data {
  
  return $NotificationDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

/// @nodoc
mixin _$NotificationData {

 String get title; String get body; int? get order_id; Map<String, dynamic> get extra;
/// Create a copy of NotificationData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationDataCopyWith<NotificationData> get copyWith => _$NotificationDataCopyWithImpl<NotificationData>(this as NotificationData, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as NotificationData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationData&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.order_id, _this.order_id) || other.order_id == _this.order_id)&&const DeepCollectionEquality().equals(other.extra, _this.extra));
}


@override
int get hashCode {
  final _this = this as NotificationData;
  return Object.hash(runtimeType,_this.title,_this.body,_this.order_id,const DeepCollectionEquality().hash(_this.extra));
}

@override
String toString() {
  final _this = this as NotificationData;
  return 'NotificationData(title: ${_this.title}, body: ${_this.body}, order_id: ${_this.order_id}, extra: ${_this.extra})';
}


}

/// @nodoc
abstract mixin class $NotificationDataCopyWith<$Res>  {
  factory $NotificationDataCopyWith(NotificationData value, $Res Function(NotificationData) _then) = _$NotificationDataCopyWithImpl;
@useResult
$Res call({
 String title, String body, int? order_id, Map<String, dynamic> extra
});




}
/// @nodoc
class _$NotificationDataCopyWithImpl<$Res>
    implements $NotificationDataCopyWith<$Res> {
  _$NotificationDataCopyWithImpl(this._self, this._then);

  final NotificationData _self;
  final $Res Function(NotificationData) _then;

/// Create a copy of NotificationData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? body = null,Object? order_id = freezed,Object? extra = null,}) {
  return _then(NotificationData(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,order_id: freezed == order_id ? _self.order_id : order_id // ignore: cast_nullable_to_non_nullable
as int?,extra: null == extra ? _self.extra : extra // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationData].
extension NotificationDataPatterns on NotificationData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationData value)  $default,){
final _that = this;
switch (_that) {
case _NotificationData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationData value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String body,  int? order_id,  Map<String, dynamic> extra)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationData() when $default != null:
return $default(_that.title,_that.body,_that.order_id,_that.extra);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String body,  int? order_id,  Map<String, dynamic> extra)  $default,) {final _that = this;
switch (_that) {
case _NotificationData():
return $default(_that.title,_that.body,_that.order_id,_that.extra);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String body,  int? order_id,  Map<String, dynamic> extra)?  $default,) {final _that = this;
switch (_that) {
case _NotificationData() when $default != null:
return $default(_that.title,_that.body,_that.order_id,_that.extra);case _:
  return null;

}
}

}

/// @nodoc


class _NotificationData implements NotificationData {
  const _NotificationData({required this.title, required this.body, this.order_id,  Map<String, dynamic> extra = const <String, dynamic>{}}): _extra = extra;
  

@override final  String title;
@override final  String body;
@override final  int? order_id;
 final  Map<String, dynamic> _extra;
@override@JsonKey() Map<String, dynamic> get extra {
  if (_extra is EqualUnmodifiableMapView) return _extra;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_extra);
}


/// Create a copy of NotificationData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationDataCopyWith<_NotificationData> get copyWith => __$NotificationDataCopyWithImpl<_NotificationData>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationData&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.order_id, order_id) || other.order_id == order_id)&&const DeepCollectionEquality().equals(other.extra, _extra));
}


@override
int get hashCode {
    return Object.hash(runtimeType,title,body,order_id,const DeepCollectionEquality().hash(_extra));
}

@override
String toString() {
    return 'NotificationData(title: $title, body: $body, order_id: $order_id, extra: $extra)';
}


}

/// @nodoc
abstract mixin class _$NotificationDataCopyWith<$Res> implements $NotificationDataCopyWith<$Res> {
  factory _$NotificationDataCopyWith(_NotificationData value, $Res Function(_NotificationData) _then) = __$NotificationDataCopyWithImpl;
@override @useResult
$Res call({
 String title, String body, int? order_id, Map<String, dynamic> extra
});




}
/// @nodoc
class __$NotificationDataCopyWithImpl<$Res>
    implements _$NotificationDataCopyWith<$Res> {
  __$NotificationDataCopyWithImpl(this._self, this._then);

  final _NotificationData _self;
  final $Res Function(_NotificationData) _then;

/// Create a copy of NotificationData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? body = null,Object? order_id = freezed,Object? extra = null,}) {
  return _then(_NotificationData(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,order_id: freezed == order_id ? _self.order_id : order_id // ignore: cast_nullable_to_non_nullable
as int?,extra: null == extra ? _self._extra : extra // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
