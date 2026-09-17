import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/city.dart';
import '../../../core/models/governorate.dart';

part 'address.freezed.dart';
part 'address.g.dart';

/// Mirrors `frontend/types/address.type.ts` (`IAddress`).
@freezed
abstract class Address with _$Address {
  const factory Address({
    required int id,
    required String full_name,
    required String phone,
    required Governorate governorate,
    required City city,
    required String address,
    required bool is_default,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}
