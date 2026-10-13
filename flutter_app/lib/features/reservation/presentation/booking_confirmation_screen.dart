import '../../../l10n/l10n.dart';
import '../../../core/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../auth/presentation/auth_sheet.dart';
import '../../auth/providers/auth_provider.dart';
import '../data/reservation_repository.dart';

/// Shown after a successful `POST /bookings`. Pushed via `Navigator.push`
/// from the reservation flow, mirroring how Step 4's flash-sale detail
/// screen is pushed (no dedicated go_router route).
class BookingConfirmationScreen extends ConsumerWidget {
  const BookingConfirmationScreen({super.key, required this.booking});

  final BookingResult booking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLogged = ref.watch(isLoggedInProvider);
    final formatted = formatDateLocalized('EEE, MMM d, yyyy • h:mm a', booking.scheduledAt.toLocal());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, title: Text(context.l10n.bookingConfirmation)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
                child: const Icon(Icons.check, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 20),
              Text(
                context.l10n.bookingSuccess,
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              if (booking.reference != null)
                Text(
                  '${context.l10n.bookingReference}: ${booking.reference}',
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
                ),
              const SizedBox(height: 12),
              if (isLogged)
                TextButton(
                  onPressed: () => context.go('/profile/reservations/${booking.id}'),
                  child: Text(context.l10n.viewBooking, style: TextStyle(color: AppColors.primary)),
                )
              else ...[
                Text(context.l10n.createAccountToTrackBookings,
                    textAlign: TextAlign.center, style: TextStyle(color: AppColors.gray2, fontSize: 13)),
                TextButton(
                  onPressed: () => showAuthSheet(context),
                  child: Text(context.l10n.createAccountCta, style: TextStyle(color: AppColors.primary)),
                ),
              ],
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: AppColors.gray3, borderRadius: AppRadii.radiusXl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _row(Icons.build, context.l10n.service, booking.serviceName),
                    const SizedBox(height: 14),
                    _row(Icons.location_on_outlined, context.l10n.branch, booking.branchName),
                    const SizedBox(height: 14),
                    _row(Icons.calendar_today_outlined, '${context.l10n.date} / ${context.l10n.time}', formatted),
                    const SizedBox(height: 14),
                    _row(Icons.info_outline, context.l10n.status, statusLabel(booking.status)),
                    if (booking.customerNotes != null && booking.customerNotes!.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      _row(Icons.notes, context.l10n.notes, booking.customerNotes!),
                    ],
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: AppRadii.radiusLg),
                  ),
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  child: Text(context.l10n.backToHome, style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: AppColors.gray2, fontSize: 12)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ],
    );
  }
}
