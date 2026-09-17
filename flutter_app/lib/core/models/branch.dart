import 'package:freezed_annotation/freezed_annotation.dart';

part 'branch.freezed.dart';
part 'branch.g.dart';

/// Mirrors `frontend/types/branch.type.ts` (`IBranch`).
@freezed
abstract class Branch with _$Branch {
  const factory Branch({
    required int id,
    required String code,
    required String name,
    required String address,
    String? description,
    required String phone,
    String? email,
    required num latitude,
    required num longitude,
    required bool is_main,
    required bool is_active,
    @Default(<Schedule>[]) List<Schedule> schedules,
  }) = _Branch;

  factory Branch.fromJson(Map<String, dynamic> json) =>
      _$BranchFromJson(json);
}

/// Mirrors `Schedule` nested in `branch.type.ts`.
@freezed
abstract class Schedule with _$Schedule {
  const factory Schedule({
    required int day_of_week,
    String? opens_at,
    String? closes_at,
    required int capacity,
    required bool is_closed,
  }) = _Schedule;

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);
}
