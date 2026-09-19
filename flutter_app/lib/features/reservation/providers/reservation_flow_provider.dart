import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/branch.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/providers/locale_provider.dart';
import '../../services/models/service.dart';
import '../data/reservation_repository.dart';

/// The 4 steps of the reservation flow, mirroring
/// `frontend/providers/ReservationProvider.tsx`'s `steps`.
enum ReservationStep { chooseService, chooseBranch, chooseAppointment, confirmBooking }

class ReservationFlowState {
  const ReservationFlowState({
    this.step = ReservationStep.chooseService,
    this.service,
    this.branch,
    this.date,
    this.time,
    this.notes = '',
    this.slots = const [],
    this.isSlotsLoading = false,
    this.isSubmitting = false,
    this.submitError,
    this.result,
  });

  final ReservationStep step;
  final Service? service;
  final Branch? branch;
  /// ISO `yyyy-MM-dd` date string.
  final String? date;
  /// `HH:mm` time string.
  final String? time;
  final String notes;
  final List<TimeSlot> slots;
  final bool isSlotsLoading;
  final bool isSubmitting;
  final String? submitError;
  final BookingResult? result;

  int get stepIndex => step.index;

  ReservationFlowState copyWith({
    ReservationStep? step,
    Service? service,
    bool clearService = false,
    Branch? branch,
    bool clearBranch = false,
    String? date,
    bool clearDate = false,
    String? time,
    bool clearTime = false,
    String? notes,
    List<TimeSlot>? slots,
    bool? isSlotsLoading,
    bool? isSubmitting,
    String? submitError,
    bool clearSubmitError = false,
    BookingResult? result,
  }) {
    return ReservationFlowState(
      step: step ?? this.step,
      service: clearService ? null : (service ?? this.service),
      branch: clearBranch ? null : (branch ?? this.branch),
      date: clearDate ? null : (date ?? this.date),
      time: clearTime ? null : (time ?? this.time),
      notes: notes ?? this.notes,
      slots: slots ?? this.slots,
      isSlotsLoading: isSlotsLoading ?? this.isSlotsLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: clearSubmitError ? null : (submitError ?? this.submitError),
      result: result ?? this.result,
    );
  }
}

/// Drives the multi-step reservation flow: service -> branch -> date/time ->
/// confirm, backed by [ReservationRepository]. Mirrors the state machine in
/// `ReservationProvider.tsx` (`reservationData`, `setService`, `setBrach`,
/// `setDate`, `setTime`, `createBooking`).
class ReservationFlowNotifier extends Notifier<ReservationFlowState> {
  @override
  ReservationFlowState build() => const ReservationFlowState();

  /// Pre-fills service/branch from deep-link query params (e.g. from the
  /// Services screen's "Book now" CTA, or a reschedule flow), skipping ahead
  /// to the appropriate step.
  void preselect({Service? service, Branch? branch}) {
    if (service == null) return;
    state = state.copyWith(
      service: service,
      branch: branch,
      step: branch != null ? ReservationStep.chooseAppointment : ReservationStep.chooseBranch,
    );
  }

  void setService(Service service) {
    state = ReservationFlowState(service: service, step: ReservationStep.chooseBranch);
  }

  void setBranch(Branch branch) {
    state = state.copyWith(
      branch: branch,
      clearDate: true,
      clearTime: true,
      slots: const [],
      step: ReservationStep.chooseAppointment,
    );
  }

  Future<void> setDate(String date) async {
    state = state.copyWith(date: date, clearTime: true);
    final branch = state.branch;
    if (branch == null) return;
    state = state.copyWith(isSlotsLoading: true, slots: const []);
    try {
      final repository = ref.read(reservationRepositoryProvider);
      final slots = await repository.fetchAvailableSlots(branchId: branch.id, date: date);
      state = state.copyWith(slots: slots, isSlotsLoading: false);
    } catch (_) {
      state = state.copyWith(isSlotsLoading: false, slots: const []);
    }
  }

  void setTime(String time) {
    state = state.copyWith(time: time);
  }

  void setNotes(String notes) {
    state = state.copyWith(notes: notes);
  }

  void goToStep(ReservationStep step) {
    state = state.copyWith(step: step);
  }

  void goBack() {
    final index = state.stepIndex;
    if (index == 0) return;
    state = state.copyWith(step: ReservationStep.values[index - 1]);
  }

  void goNext() {
    final index = state.stepIndex;
    if (index == ReservationStep.values.length - 1) return;
    state = state.copyWith(step: ReservationStep.values[index + 1]);
  }

  /// Submits the booking. Returns the created [BookingResult] on success, or
  /// null if a required field is missing or the request failed (in which
  /// case [ReservationFlowState.submitError] is set).
  Future<BookingResult?> createBooking({
    String? customerName,
    String? customerPhone,
    String? customerEmail,
  }) async {
    final service = state.service;
    final branch = state.branch;
    final date = state.date;
    final time = state.time;
    if (service == null || branch == null || date == null || time == null) return null;

    state = state.copyWith(isSubmitting: true, clearSubmitError: true);
    try {
      final repository = ref.read(reservationRepositoryProvider);
      final result = await repository.createBooking(
        serviceId: service.id,
        branchId: branch.id,
        scheduledAt: '${date}T$time:00',
        customerNotes: state.notes,
        customerName: customerName,
        customerPhone: customerPhone,
        customerEmail: customerEmail,
        locale: ref.read(localeProvider).languageCode,
      );
      state = state.copyWith(isSubmitting: false, result: result);
      return result;
    } on DioException catch (e) {
      final error = e.error;
      final message = error is ApiException ? error.message : e.message ?? 'Booking failed.';
      state = state.copyWith(isSubmitting: false, submitError: message);
      return null;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, submitError: e.toString());
      return null;
    }
  }
}

final reservationFlowProvider =
    NotifierProvider<ReservationFlowNotifier, ReservationFlowState>(
  ReservationFlowNotifier.new,
);
