import 'package:freezed_annotation/freezed_annotation.dart';

part 'service.freezed.dart';
part 'service.g.dart';

/// Mirrors `frontend/types/service.type.ts` (`IService`).
@freezed
abstract class Service with _$Service {
  const factory Service({
    required int id,
    required String slug,
    required String name,
    String? description,
    String? icon,
    String? image_url,
    required int duration_minutes,
    required num price,
  }) = _Service;

  factory Service.fromJson(Map<String, dynamic> json) =>
      _$ServiceFromJson(json);
}
