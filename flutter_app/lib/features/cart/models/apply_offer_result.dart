import 'package:freezed_annotation/freezed_annotation.dart';

part 'apply_offer_result.freezed.dart';
part 'apply_offer_result.g.dart';

/// Mirrors `frontend/types/customerCart.type.ts` (`IApplyOfferResult`).
@freezed
abstract class ApplyOfferResult with _$ApplyOfferResult {
  const factory ApplyOfferResult({
    required num discount,
    required num subtotal,
    required num total,
    required AppliedOffer offer,
  }) = _ApplyOfferResult;

  factory ApplyOfferResult.fromJson(Map<String, dynamic> json) =>
      _$ApplyOfferResultFromJson(json);
}

/// Mirrors the inline `offer` object in `IApplyOfferResult`.
@freezed
abstract class AppliedOffer with _$AppliedOffer {
  const factory AppliedOffer({
    required String code,
    required String title,
  }) = _AppliedOffer;

  factory AppliedOffer.fromJson(Map<String, dynamic> json) =>
      _$AppliedOfferFromJson(json);
}
