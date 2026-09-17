import 'package:freezed_annotation/freezed_annotation.dart';

part 'review.freezed.dart';
part 'review.g.dart';

/// Mirrors `frontend/types/review.type.ts` (`IReview`).
@freezed
abstract class Review with _$Review {
  const factory Review({
    required int id,
    required String type,
    required num rating,
    required String comment,
    required DateTime created_at,
    required ReviewCustomer customer,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) =>
      _$ReviewFromJson(json);
}

/// Mirrors `Customer` nested in `review.type.ts`.
@freezed
abstract class ReviewCustomer with _$ReviewCustomer {
  const factory ReviewCustomer({
    required int id,
    required String name,
  }) = _ReviewCustomer;

  factory ReviewCustomer.fromJson(Map<String, dynamic> json) =>
      _$ReviewCustomerFromJson(json);
}
