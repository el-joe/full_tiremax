import '../../../l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/format.dart';
import '../../../core/theme/app_radii.dart';
import '../../../shared/widgets/status_badge.dart';
import '../data/reservation_repository.dart';
import '../models/reservation.dart';

/// GET /bookings/{id} detail. context.l10n.commonCancel -> POST /bookings/{id}/cancel with a
/// confirm dialog. context.l10n.reschedule -> a warning dialog explaining that
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
      appBar: AppBar(backgroundColor: AppColors.background, title: Text(context.l10n.bookingDetail)),
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
                    StatusBadge(status: reservation.status, kind: StatusBadgeKind.bookingDetail),
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
                      _row(context.l10n.service, reservation.service.name),
                      _row(context.l10n.branchLabel, reservation.branch.name),
                      _row(context.l10n.address, reservation.branch.address),
                      _row(context.l10n.phoneLabel, reservation.branch.phone),
                      _row(context.l10n.dateAndTime,
                          formatDateLocalized('MMM d, yyyy • h:mm a', reservation.scheduled_at.toLocal())),
                      _row(context.l10n.duration, context.l10n.minutesCount(reservation.duration_minutes)),
                      _row(context.l10n.price, formatIqd(reservation.service.price)),
                      if (reservation.customer_notes != null && reservation.customer_notes!.isNotEmpty)
                        _row(context.l10n.notes, reservation.customer_notes!),
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
                      onPressed: () => confirmReschedule(context, ref, reservation),
                      child: Text(context.l10n.reschedule, style: TextStyle(fontWeight: FontWeight.w800)),
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
                      onPressed: () => confirmCancel(context, ref, reservation.id),
                      child: Text(context.l10n.cancelBooking, style: TextStyle(fontWeight: FontWeight.w700)),
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

  static void confirmCancel(BuildContext context, WidgetRef ref, int id) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.gray3,
        title: Text(context.l10n.cancelBooking, style: TextStyle(color: Colors.white)),
        content: Text(
          context.l10n.cancelBookingWarning,
          style: TextStyle(color: AppColors.gray2),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(context.l10n.keepBooking)),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await ref.read(reservationRepositoryProvider).cancelBooking(id);
                ref.invalidate(bookingDetailProvider(id));
                ref.invalidate(bookingsListProvider);
              } catch (e) {
                if (context.mounted) {
                  final message = e is ApiException ? e.message : context.l10n.couldNotCancelBooking;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                }
              }
            },
            child: Text(context.l10n.cancelBooking, style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );
  }

  static void confirmReschedule(BuildContext context, WidgetRef ref, Reservation reservation) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.gray3,
        title: Text(context.l10n.rescheduleBooking, style: TextStyle(color: Colors.white)),
        content: Text(
          context.l10n.rescheduleBookingWarning,
          style: TextStyle(color: AppColors.gray2),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(context.l10n.keepBooking)),
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
                  final message = e is ApiException ? e.message : context.l10n.couldNotRescheduleBooking;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                }
              }
            },
            child: Text(context.l10n.commonContinue, style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
