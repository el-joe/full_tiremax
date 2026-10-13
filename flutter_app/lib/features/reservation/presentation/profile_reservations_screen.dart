import '../../../l10n/l10n.dart';
import '../../../core/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../shared/widgets/web_pagination.dart';
import '../../../shared/widgets/status_badge.dart';
import '../data/reservation_repository.dart';
import '../models/reservation.dart';
import 'profile_reservation_detail_screen.dart';

/// GET /bookings list (paginated) with reschedule / cancel / details actions.
/// Mirrors `frontend/app/[locale]/profile/reservation/page.tsx` +
/// `components/pages/profile/reservation/ReservationList.tsx`.
class ProfileReservationsScreen extends ConsumerStatefulWidget {
  const ProfileReservationsScreen({super.key});

  @override
  ConsumerState<ProfileReservationsScreen> createState() => _ProfileReservationsScreenState();
}

class _ProfileReservationsScreenState extends ConsumerState<ProfileReservationsScreen> {
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(bookingsListProvider(_page));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, title: Text(context.l10n.myBookings)),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            ref.invalidate(bookingsListProvider(_page));
            await ref.read(bookingsListProvider(_page).future);
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.gray3, borderRadius: AppRadii.radiusXl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l10n.myBookings,
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                    SizedBox(height: 6),
                    Text(context.l10n.manageBookingsDescription, style: TextStyle(color: AppColors.gray2, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              bookingsAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                ),
                error: (error, _) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: Text(context.l10n.unexpectedError, style: TextStyle(color: AppColors.gray2))),
                ),
                data: (page) {
                  if (page.items.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(context.l10n.noBookingYet,
                            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      for (final r in page.items) ...[_BookingTile(reservation: r), const SizedBox(height: 16)],
                      if (page.lastPage > 1)
                        WebPagination(
                          current: page.currentPage,
                          last: page.lastPage,
                          onPage: (p) => setState(() => _page = p),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookingTile extends ConsumerWidget {
  const _BookingTile({required this.reservation});

  final Reservation reservation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final done = reservation.status == 'completed' || reservation.status == 'cancelled';
    final when = reservation.scheduled_at.toLocal();
    Widget meta(IconData icon, String text) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.primary),
            const SizedBox(width: 6),
            Flexible(child: Text(text, style: const TextStyle(color: AppColors.gray2, fontSize: 12))),
          ],
        );
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.gray3,
        borderRadius: AppRadii.radiusXl,
        border: Border(top: BorderSide(color: done ? Colors.transparent : AppColors.primary, width: 5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: done ? AppColors.gray4 : AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.build_outlined, color: Colors.black),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(reservation.service.name,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                          Text('${context.l10n.bookingNumber}: ${reservation.reference}',
                              style: const TextStyle(color: AppColors.gray2, fontSize: 12)),
                        ],
                      ),
                    ),
                    StatusBadge(status: reservation.status, kind: StatusBadgeKind.bookingList),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 16,
                  runSpacing: 6,
                  children: [
                    meta(Icons.calendar_today_outlined, formatDateLocalized('EEE MMM dd yyyy', when)),
                    meta(Icons.access_time, formatDateLocalized('hh:mm a', when)),
                    meta(Icons.place_outlined, reservation.branch.address),
                  ],
                ),
                if (!done) ...[
                  const Divider(height: 24, color: Color(0x22FFFFFF)),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _btn(Icons.history, context.l10n.reschedule, AppColors.gray2, AppColors.gray4, null,
                          () => ProfileReservationDetailScreen.confirmReschedule(context, ref, reservation)),
                      _btn(Icons.close, context.l10n.cancelBooking, const Color(0xFFE7000B), Colors.transparent,
                          const Color(0xFFFFC9C9), () => ProfileReservationDetailScreen.confirmCancel(context, ref, reservation.id)),
                      _btn(null, context.l10n.viewDetails, Colors.black, AppColors.primary, null,
                          () => context.push('/profile/reservations/${reservation.id}')),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _btn(IconData? icon, String label, Color fg, Color bg, Color? border, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: border == null ? null : Border.all(color: border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[Icon(icon, size: 16, color: fg), const SizedBox(width: 6)],
            Text(label, style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
