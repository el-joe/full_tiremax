// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Review _$ReviewFromJson(Map<String, dynamic> json) => _Review(
  id: (json['id'] as num).toInt(),
  type: json['type'] as String,
  rating: json['rating'] as num,
  comment: json['comment'] as String,
  created_at: DateTime.parse(json['created_at'] as String),
  customer: ReviewCustomer.fromJson(json['customer'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ReviewToJson(_Review instance) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'rating': instance.rating,
  'comment': instance.comment,
  'created_at': instance.created_at.toIso8601String(),
  'customer': instance.customer,
};

_ReviewCustomer _$ReviewCustomerFromJson(Map<String, dynamic> json) =>
    _ReviewCustomer(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$ReviewCustomerToJson(_ReviewCustomer instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
