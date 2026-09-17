import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_profile.freezed.dart';
part 'customer_profile.g.dart';

/// Mirrors `frontend/types/customerProfile.type.ts` (`ICustomerProfile`).
@freezed
abstract class CustomerProfile with _$CustomerProfile {
  const factory CustomerProfile({
    required int id,
    required String name,
    required String email,
    required String phone,
    required String address,
    required String locale,
  }) = _CustomerProfile;

  factory CustomerProfile.fromJson(Map<String, dynamic> json) =>
      _$CustomerProfileFromJson(json);
}
