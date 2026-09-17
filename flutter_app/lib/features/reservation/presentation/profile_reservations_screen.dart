import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../orders/presentation/orders_screen.dart' show orderStatusColor;
import '../data/reservation_repository.dart';
import '../models/reservation.dart';

/// GET /bookings list with status chips, tap -> detail. Mirrors
/// `frontend/app/[locale]/profile/reservation/**`.
class ProfileReservationsScreen extends ConsumerWidget {
  const ProfileReservationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(bookingsListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, title: const Text('My Bookings')),
      body: SafeArea(
        child: bookingsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (error, _) => Center(child: Text('$error', style: const TextStyle(color: AppColors.gray2))),
          data: (bookings) {
            if (bookings.isEmpty) {
              return const Center(child: Text('No bookings yet.', style: TextStyle(color: AppColors.gray2)));
            }
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => ref.read(bookingsListProvider.notifier).refresh(),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: bookings.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) => _BookingTile(reservation: bookings[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BookingTile extends StatelessWidget {
  const _BookingTile({required this.reservation});

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    final color = orderStatusColor(reservation.status);
    return InkWell(
      borderRadius: AppRadii.radiusXl,
      onTap: () => context.push('/profile/reservations/${reservation.id}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.gray3, borderRadius: AppRadii.radiusXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('#${reservation.reference}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.18), borderRadius: AppRadii.radiusFull),
                  child: Text(
                    reservation.status[0].toUpperCase() + reservation.status.substring(1),
                    style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(reservation.service.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(reservation.branch.name, style: const TextStyle(color: AppColors.gray2, fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              DateFormat('MMM d, yyyy • h:mm a').format(reservation.scheduled_at.toLocal()),
              style: const TextStyle(color: AppColors.gray2, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
