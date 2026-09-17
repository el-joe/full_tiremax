import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../orders/presentation/orders_screen.dart' show StatusChip;
import '../data/reservation_repository.dart';
import '../models/reservation.dart';

/// GET /bookings/{id} detail. "Cancel" -> POST /bookings/{id}/cancel with a
/// confirm dialog. "Reschedule" -> a warning dialog explaining that
/// rescheduling cancels the current booking, then on confirm calls
/// POST /bookings/{id}/cancel and navigates to `/reservation?service_id=X&
/// branch_id=Y` pre-filled with the same service/branch so the user rebooks
/// (confirmed intentional: the backend has no separate reschedule endpoint;
/// see `frontend/components/dialogs/RescheduleReservationDialog.tsx`).
class ProfileReservationDetailScreen extends ConsumerWidget {
  const ProfileReservationDetailScreen({super.key, required this.reservationId});

  final int reservationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingAsync = ref.watch(bookingDetailProvider(reservationId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, title: const Text('Booking Detail')),
      body: SafeArea(
        child: bookingAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (error, _) => Center(child: Text('$error', style: const TextStyle(color: AppColors.gray2))),
          data: (reservation) {
            final cancellable = isBookingCancellable(reservation.status);
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('#${reservation.reference}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
                    ),
                    StatusChip(status: reservation.status),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppColors.gray3, borderRadius: AppRadii.radiusXl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _row('Service', reservation.service.name),
                      _row('Branch', reservation.branch.name),
                      _row('Address', reservation.branch.address),
                      _row('Phone', reservation.branch.phone),
                      _row('Date & Time',
                          DateFormat('MMM d, yyyy • h:mm a').format(reservation.scheduled_at.toLocal())),
                      _row('Duration', '${reservation.duration_minutes} min'),
                      _row('Price', '${reservation.service.price} EGP'),
                      if (reservation.customer_notes != null && reservation.customer_notes!.isNotEmpty)
                        _row('Notes', reservation.customer_notes!),
                    ],
                  ),
                ),
                if (cancellable) ...[
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: AppRadii.radiusLg),
                      ),
                      onPressed: () => _confirmReschedule(context, ref, reservation),
                      child: const Text('Reschedule', style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.red,
                        side: const BorderSide(color: AppColors.red),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: AppRadii.radiusLg),
                      ),
                      onPressed: () => _confirmCancel(context, ref, reservation.id),
                      child: const Text('Cancel Booking', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.gray2)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.end, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _confirmCancel(BuildContext context, WidgetRef ref, int id) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.gray3,
        title: const Text('Cancel Booking', style: TextStyle(color: Colors.white)),
        content: const Text(
          "You won't be able to restore the booking once it has been canceled.",
          style: TextStyle(color: AppColors.gray2),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Keep Booking')),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await ref.read(reservationRepositoryProvider).cancelBooking(id);
                ref.invalidate(bookingDetailProvider(id));
                ref.invalidate(bookingsListProvider);
              } catch (e) {
                if (context.mounted) {
                  final message = e is ApiException ? e.message : 'Could not cancel the booking.';
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                }
              }
            },
            child: const Text('Cancel Booking', style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmReschedule(BuildContext context, WidgetRef ref, Reservation reservation) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.gray3,
        title: const Text('Reschedule Booking', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Rescheduling will cancel your current booking. Are you sure?',
          style: TextStyle(color: AppColors.gray2),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Keep Booking')),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await ref.read(reservationRepositoryProvider).cancelBooking(reservation.id);
                ref.invalidate(bookingDetailProvider(reservation.id));
                ref.invalidate(bookingsListProvider);
                if (context.mounted) {
                  context.push(
                    '/reservation?service_id=${reservation.service.id}&branch_id=${reservation.branch.id}',
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  final message = e is ApiException ? e.message : 'Could not reschedule the booking.';
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                }
              }
            },
            child: const Text('Continue', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
