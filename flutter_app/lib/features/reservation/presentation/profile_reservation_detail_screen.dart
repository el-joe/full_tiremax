import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/format.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/reservation_repository.dart';
import '../models/reservation.dart';

/// GET /bookings/{id} detail. Cancel -> POST /bookings/{id}/cancel with a
/// confirm dialog. Reschedule -> a warning dialog explaining that
/// rescheduling cancels the current booking, then on confirm calls
/// POST /bookings/{id}/cancel and navigates to `/reservation?service_id=X&
/// branch_id=Y` pre-filled with the same service/branch so the user rebooks
/// (the backend has no separate reschedule endpoint; see
/// `frontend/components/dialogs/RescheduleReservationDialog.tsx`).
class ProfileReservationDetailScreen extends ConsumerWidget {
  const ProfileReservationDetailScreen({
    super.key,
    required this.reservationId,
  });

  final int reservationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final bookingAsync = ref.watch(bookingDetailProvider(reservationId));

    return AppScaffold(
      title: l.bookingDetail,
      body: bookingAsync.when(
        loading: () => const SkeletonList(itemCount: 2, itemHeight: 160),
        error: (error, _) => ErrorState(
          message: l.unexpectedError,
          onRetry: () => ref.invalidate(bookingDetailProvider(reservationId)),
        ),
        data: (reservation) {
          final cancellable = isBookingCancellable(reservation.status);
          final cancelled = reservation.status == 'cancelled';
          final done =
              reservation.status == 'completed' ||
              reservation.status == 'complete';
          final idx = done
              ? 2
              : (reservation.status == 'confirmed' ||
                        reservation.status == 'rescheduled'
                    ? 1
                    : 0);
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.gutter),
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '#${reservation.reference}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.foregroundLight,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        StatusPill(
                          label: statusLabel(reservation.status),
                          color: statusColor(reservation.status),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    StatusTimeline(
                      steps: [
                        l.statusPending,
                        l.statusConfirmed,
                        l.statusComplete,
                      ],
                      current: cancelled ? 0 : idx,
                      cancelled: cancelled,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InfoLine(
                      icon: Icons.build_outlined,
                      label: l.service,
                      value: reservation.service.name,
                    ),
                    InfoLine(
                      icon: Icons.calendar_today_outlined,
                      label: l.dateAndTime,
                      value: formatDateLocalized(
                        'MMM d, yyyy • h:mm a',
                        reservation.scheduled_at.toLocal(),
                      ),
                    ),
                    InfoLine(
                      icon: Icons.timer_outlined,
                      label: l.duration,
                      value: l.minutesCount(reservation.duration_minutes),
                    ),
                    InfoLine(
                      icon: Icons.storefront_outlined,
                      label: l.branchLabel,
                      value: reservation.branch.name,
                    ),
                    InfoLine(
                      icon: Icons.place_outlined,
                      label: l.address,
                      value: reservation.branch.address,
                    ),
                    InfoLine(
                      icon: Icons.phone_outlined,
                      label: l.phoneLabel,
                      value: reservation.branch.phone,
                    ),
                    if (reservation.customer_notes != null &&
                        reservation.customer_notes!.isNotEmpty)
                      InfoLine(
                        icon: Icons.notes_outlined,
                        label: l.notes,
                        value: reservation.customer_notes!,
                      ),
                    const Divider(color: AppColors.gray),
                    SummaryRow(
                      label: l.price,
                      value: formatIqd(reservation.service.price),
                      bold: true,
                    ),
                  ],
                ),
              ),
              if (cancellable) ...[
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                  label: l.reschedule,
                  icon: Icons.history,
                  onPressed: () => confirmReschedule(context, ref, reservation),
                ),
                const SizedBox(height: AppSpacing.md),
                SecondaryButton(
                  label: l.cancelBooking,
                  icon: Icons.close,
                  onPressed: () => confirmCancel(context, ref, reservation.id),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  static Future<void> confirmCancel(
    BuildContext context,
    WidgetRef ref,
    int id,
  ) async {
    final l = context.l10n;
    final ok = await showConfirmDialog(
      context,
      title: l.cancelBooking,
      message: l.cancelBookingWarning,
      confirmLabel: l.cancelBooking,
      cancelLabel: l.keepBooking,
    );
    if (!ok) return;
    try {
      await ref.read(reservationRepositoryProvider).cancelBooking(id);
      ref.invalidate(bookingDetailProvider(id));
      ref.invalidate(bookingsListProvider);
    } catch (e) {
      if (context.mounted) {
        final message = e is ApiException
            ? e.message
            : context.l10n.couldNotCancelBooking;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }

  static Future<void> confirmReschedule(
    BuildContext context,
    WidgetRef ref,
    Reservation reservation,
  ) async {
    final l = context.l10n;
    final ok = await showConfirmDialog(
      context,
      title: l.rescheduleBooking,
      message: l.rescheduleBookingWarning,
      confirmLabel: l.commonContinue,
      cancelLabel: l.keepBooking,
      destructive: false,
    );
    if (!ok) return;
    try {
      await ref
          .read(reservationRepositoryProvider)
          .cancelBooking(reservation.id);
      ref.invalidate(bookingDetailProvider(reservation.id));
      ref.invalidate(bookingsListProvider);
      if (context.mounted) {
        context.push(
          '/reservation?service_id=${reservation.service.id}&branch_id=${reservation.branch.id}',
        );
      }
    } catch (e) {
      if (context.mounted) {
        final message = e is ApiException
            ? e.message
            : context.l10n.couldNotRescheduleBooking;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }
}
