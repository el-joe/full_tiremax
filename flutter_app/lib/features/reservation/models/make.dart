import 'package:freezed_annotation/freezed_annotation.dart';

part 'make.freezed.dart';
part 'make.g.dart';

/// Mirrors `frontend/types/make.type.ts` (`IMake`) — a vehicle manufacturer.
@freezed
abstract class Make with _$Make {
  const factory Make({
    required int id,
    required String slug,
    required String name,
    String? logo,
  }) = _Make;

  factory Make.fromJson(Map<String, dynamic> json) => _$MakeFromJson(json);
}
