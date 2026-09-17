import 'package:freezed_annotation/freezed_annotation.dart';

part 'city.freezed.dart';
part 'city.g.dart';

/// Mirrors `frontend/types/city.type.ts` (`ICity`).
@freezed
abstract class City with _$City {
  const factory City({
    required int id,
    required String name_ar,
    required String name_en,
  }) = _City;

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
}
