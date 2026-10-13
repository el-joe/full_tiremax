import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/format.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/reservation_repository.dart';
import '../models/reservation.dart';

enum _BookingFilter { all, upcoming, completed, cancelled }

/// GET /bookings list (paginated) with status chips. Mirrors
/// `frontend/app/[locale]/profile/reservation/page.tsx`. Chips filter the
/// loaded page client-side (the endpoint has no status filter).
class ProfileReservationsScreen extends ConsumerStatefulWidget {
  const ProfileReservationsScreen({super.key});

  @override
  ConsumerState<ProfileReservationsScreen> createState() =>
      _ProfileReservationsScreenState();
}

class _ProfileReservationsScreenState
    extends ConsumerState<ProfileReservationsScreen> {
  int _page = 1;
  _BookingFilter _filter = _BookingFilter.all;

  bool _matches(Reservation r) => switch (_filter) {
    _BookingFilter.all => true,
    _BookingFilter.upcoming =>
      r.status != 'completed' &&
          r.status != 'complete' &&
          r.status != 'cancelled',
    _BookingFilter.completed =>
      r.status == 'completed' || r.status == 'complete',
    _BookingFilter.cancelled => r.status == 'cancelled',
  };

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final bookingsAsync = ref.watch(bookingsListProvider(_page));
    final labels = {
      _BookingFilter.all: l.all,
      _BookingFilter.upcoming: l.filterUpcoming,
      _BookingFilter.completed: l.statusComplete,
      _BookingFilter.cancelled: l.cancelled,
    };

    return AppScaffold(
      title: l.myBookings,
      body: Column(
        children: [
          const SizedBox(height: AppSpacing.sm),
          ChipRow(
            children: [
              for (final f in _BookingFilter.values)
                AppChip(
                  label: labels[f]!,
                  selected: _filter == f,
                  onTap: () => setState(() => _filter = f),
                ),
            ],
          ),
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                ref.invalidate(bookingsListProvider(_page));
                await ref.read(bookingsListProvider(_page).future);
              },
              child: bookingsAsync.when(
                loading: () => const SkeletonList(itemHeight: 112),
                error: (error, _) => ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: 360,
                      child: ErrorState(
                        message: l.unexpectedError,
                        onRetry: () =>
                            ref.invalidate(bookingsListProvider(_page)),
                      ),
                    ),
                  ],
                ),
                data: (page) {
                  final items = page.items.where(_matches).toList();
                  if (items.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: 360,
                          child: EmptyState(
                            icon: Icons.event_busy_outlined,
                            title: l.noBookingYet,
                            actionLabel: l.bookNewService,
                            onAction: () => context.push('/reservation'),
                          ),
                        ),
                      ],
                    );
                  }
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(AppSpacing.gutter),
                    children: [
                      for (final r in items) ...[
                        _BookingCard(reservation: r),
                        const SizedBox(height: AppSpacing.md),
                      ],
                      if (page.lastPage > 1)
                        PagerBar(
                          current: page.currentPage,
                          last: page.lastPage,
                          onPage: (p) => setState(() => _page = p),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.reservation});

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final when = reservation.scheduled_at.toLocal();
    final done =
        reservation.status == 'completed' || reservation.status == 'cancelled';
    return AppCard(
      onTap: () => context.push('/profile/reservations/${reservation.id}'),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: done ? AppColors.gray4 : AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${when.day}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.chrome,
                  ),
                ),
                Text(
                  formatDateLocalized('MMM', when),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.chrome,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        reservation.service.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
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
                const SizedBox(height: 2),
                Text(
                  '${l.bookingNumber}: ${reservation.reference}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: AppColors.gray2),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${formatDateLocalized('hh:mm a', when)} • ${reservation.branch.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: AppColors.gray2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
