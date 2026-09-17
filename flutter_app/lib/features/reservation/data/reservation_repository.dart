import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/branch.dart';
import '../../../core/network/api_client.dart';
import '../../services/models/service.dart';
import '../models/reservation.dart';

/// A single bookable time slot, as returned by
/// `GET /bookings/branch/{branch}/slots`.
class TimeSlot {
  const TimeSlot({required this.time, required this.available});

  factory TimeSlot.fromJson(Map<String, dynamic> json) => TimeSlot(
        time: json['time'] as String,
        available: json['available'] as bool? ?? false,
      );

  final String time;
  final bool available;
}

/// The created booking, as returned by `POST /bookings`.
class BookingResult {
  const BookingResult({
    required this.id,
    required this.status,
    required this.scheduledAt,
    required this.branchName,
    required this.serviceName,
    this.reference,
    this.customerNotes,
  });

  factory BookingResult.fromJson(Map<String, dynamic> json) => BookingResult(
        id: json['id'] as int,
        status: json['status'] as String? ?? 'pending',
        scheduledAt: DateTime.parse(json['scheduled_at'] as String),
        branchName: (json['branch'] as Map<String, dynamic>?)?['name'] as String? ?? '',
        serviceName: (json['service'] as Map<String, dynamic>?)?['name'] as String? ?? '',
        reference: json['reference'] as String?,
        customerNotes: json['customer_notes'] as String?,
      );

  final int id;
  final String status;
  final DateTime scheduledAt;
  final String branchName;
  final String serviceName;
  final String? reference;
  final String? customerNotes;
}

/// Handles the `services`, `branches` and `bookings` endpoints backing the
/// reservation flow. Mirrors `frontend/providers/ReservationProvider.tsx`.
class ReservationRepository {
  ReservationRepository(this._dio);

  final Dio _dio;

  Future<List<Service>> fetchServices() async {
    final response = await _dio.get('services');
    final data = (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
    return data.map((e) => Service.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Branch>> fetchBranches() async {
    final response = await _dio.get('branches');
    final data = (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
    return data.map((e) => Branch.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<TimeSlot>> fetchAvailableSlots({
    required int branchId,
    required String date,
  }) async {
    final response = await _dio.get(
      'bookings/branch/$branchId/slots',
      queryParameters: {'date': date},
    );
    final data = (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
    return data.map((e) => TimeSlot.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<BookingResult> createBooking({
    required int serviceId,
    required int branchId,
    required String scheduledAt,
    String? customerNotes,
  }) async {
    final response = await _dio.post(
      'bookings',
      data: {
        'service_id': serviceId,
        'branch_id': branchId,
        'scheduled_at': scheduledAt,
        if (customerNotes != null && customerNotes.trim().isNotEmpty)
          'customer_notes': customerNotes.trim(),
      },
    );
    final body = response.data as Map<String, dynamic>;
    return BookingResult.fromJson(body['data'] as Map<String, dynamic>);
  }

  Future<List<Reservation>> fetchBookings() async {
    final response = await _dio.get('bookings');
    final data = (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
    return data.map((e) => Reservation.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Reservation> fetchBooking(int id) async {
    final response = await _dio.get('bookings/$id');
    final body = response.data as Map<String, dynamic>;
    return Reservation.fromJson(body['data'] as Map<String, dynamic>);
  }

  /// Cancels a booking. Backend rejects this once `status` is `completed`
  /// or `cancelled` (`backend/app/Services/BookingService.php::cancel`) —
  /// also used, per the web's `RescheduleReservationDialog.tsx`, as the
  /// first step of "reschedule" (there is no separate reschedule endpoint).
  Future<Reservation> cancelBooking(int id) async {
    final response = await _dio.post('bookings/$id/cancel');
    final body = response.data as Map<String, dynamic>;
    return Reservation.fromJson(body['data'] as Map<String, dynamic>);
  }
}

/// Mirrors `BookingService::cancel`'s disallowed source statuses.
bool isBookingCancellable(String status) => status != 'completed' && status != 'cancelled';

final reservationRepositoryProvider = Provider<ReservationRepository>((ref) {
  return ReservationRepository(ref.watch(apiClientProvider));
});

final reservationServicesProvider = FutureProvider<List<Service>>((ref) {
  return ref.watch(reservationRepositoryProvider).fetchServices();
});

final reservationBranchesProvider = FutureProvider<List<Branch>>((ref) {
  return ref.watch(reservationRepositoryProvider).fetchBranches();
});

/// GET /bookings — the customer's reservation history, used by the
/// Profile > Reservations screen.
class BookingsListNotifier extends AsyncNotifier<List<Reservation>> {
  @override
  Future<List<Reservation>> build() async {
    return ref.read(reservationRepositoryProvider).fetchBookings();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(reservationRepositoryProvider).fetchBookings());
  }
}

final bookingsListProvider = AsyncNotifierProvider<BookingsListNotifier, List<Reservation>>(
  BookingsListNotifier.new,
);

final bookingDetailProvider = FutureProvider.autoDispose.family<Reservation, int>((ref, id) {
  return ref.watch(reservationRepositoryProvider).fetchBooking(id);
});
