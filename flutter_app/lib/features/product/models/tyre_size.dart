import 'package:freezed_annotation/freezed_annotation.dart';

part 'tyre_size.freezed.dart';
part 'tyre_size.g.dart';

/// Mirrors `frontend/types/tyreSize.type.tsx` (`ITyreSize`).
@freezed
abstract class TyreSize with _$TyreSize {
  const factory TyreSize({
    required num width,
    required num aspect_ratio,
    required num rim_diameter,
  }) = _TyreSize;

  factory TyreSize.fromJson(Map<String, dynamic> json) =>
      _$TyreSizeFromJson(json);
}
