// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apply_offer_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApplyOfferResult _$ApplyOfferResultFromJson(Map<String, dynamic> json) =>
    _ApplyOfferResult(
      discount: json['discount'] as num,
      subtotal: json['subtotal'] as num,
      total: json['total'] as num,
      offer: AppliedOffer.fromJson(json['offer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApplyOfferResultToJson(_ApplyOfferResult instance) =>
    <String, dynamic>{
      'discount': instance.discount,
      'subtotal': instance.subtotal,
      'total': instance.total,
      'offer': instance.offer,
    };

_AppliedOffer _$AppliedOfferFromJson(Map<String, dynamic> json) =>
    _AppliedOffer(code: json['code'] as String, title: json['title'] as String);

Map<String, dynamic> _$AppliedOfferToJson(_AppliedOffer instance) =>
    <String, dynamic>{'code': instance.code, 'title': instance.title};
