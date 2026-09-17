import 'package:freezed_annotation/freezed_annotation.dart';

part 'reservation.freezed.dart';
part 'reservation.g.dart';

/// Mirrors `frontend/types/reservation.type.ts` (`IReservation`), i.e. a
/// service booking.
@freezed
abstract class Reservation with _$Reservation {
  const factory Reservation({
    required int id,
    required String reference,
    required DateTime scheduled_at,
    required int duration_minutes,
    required String status,
    String? customer_notes,
    required ReservationBranch branch,
    required ReservationService service,
  }) = _Reservation;

  factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);
}

/// Mirrors the reservation-scoped `Branch` in `reservation.type.ts` (a
/// narrower shape than `core/models/branch.dart`'s `Branch`).
@freezed
abstract class ReservationBranch with _$ReservationBranch {
  const factory ReservationBranch({
    required int id,
    required String code,
    required String name,
    required String address,
    required String phone,
    required num latitude,
    required num longitude,
  }) = _ReservationBranch;

  factory ReservationBranch.fromJson(Map<String, dynamic> json) =>
      _$ReservationBranchFromJson(json);
}

/// Mirrors the reservation-scoped `Service` in `reservation.type.ts`.
@freezed
abstract class ReservationService with _$ReservationService {
  const factory ReservationService({
    required int id,
    required String slug,
    required String name,
    required String description,
    required int duration_minutes,
    required num price,
  }) = _ReservationService;

  factory ReservationService.fromJson(Map<String, dynamic> json) =>
      _$ReservationServiceFromJson(json);
}
