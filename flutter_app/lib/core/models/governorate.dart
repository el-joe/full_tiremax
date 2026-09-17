import 'package:freezed_annotation/freezed_annotation.dart';

part 'governorate.freezed.dart';
part 'governorate.g.dart';

/// Mirrors `frontend/types/governorate.type.ts` (`IGovernorate`).
@freezed
abstract class Governorate with _$Governorate {
  const factory Governorate({
    required int id,
    required String code,
    required String name,
    required bool is_basra,
    required num shipping_fee,
  }) = _Governorate;

  factory Governorate.fromJson(Map<String, dynamic> json) =>
      _$GovernorateFromJson(json);
}
