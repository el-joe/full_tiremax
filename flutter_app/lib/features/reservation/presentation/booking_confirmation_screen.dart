import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/format.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/widgets/widgets.dart';
import '../../auth/presentation/auth_sheet.dart';
import '../../auth/providers/auth_provider.dart';
import '../data/reservation_repository.dart';

/// Shown after a successful `POST /bookings`. Pushed via `Navigator.push`
/// from the reservation flow (no dedicated go_router route).
class BookingConfirmationScreen extends ConsumerWidget {
  const BookingConfirmationScreen({super.key, required this.booking});

  final BookingResult booking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final isLogged = ref.watch(isLoggedInProvider);
    final formatted = formatDateLocalized(
      'EEE, MMM d, yyyy • h:mm a',
      booking.scheduledAt.toLocal(),
    );

    void goTo(String path) {
      final router = GoRouter.of(context);
      Navigator.of(context).popUntil((route) => route.isFirst);
      router.go(path);
    }

    return AppScaffold(
      title: l.bookingConfirmation,
      bottomBar: StickyBottomBar(
        action: isLogged
            ? PrimaryButton(
                label: l.viewBooking,
                onPressed: () => goTo('/profile/reservations/${booking.id}'),
              )
            : PrimaryButton(label: l.backToHome, onPressed: () => goTo('/')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        children: [
          const SizedBox(height: AppSpacing.md),
          const Center(child: SuccessCheck()),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l.bookingSuccess,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.foregroundLight,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          if (booking.reference != null)
            CopyReference(
              label: l.bookingReference,
              reference: booking.reference!,
            ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              children: [
                InfoLine(
                  icon: Icons.build_outlined,
                  label: l.service,
                  value: booking.serviceName,
                ),
                InfoLine(
                  icon: Icons.location_on_outlined,
                  label: l.branch,
                  value: booking.branchName,
                ),
                InfoLine(
                  icon: Icons.calendar_today_outlined,
                  label: '${l.date} / ${l.time}',
                  value: formatted,
                ),
                InfoLine(
                  icon: Icons.info_outline,
                  label: l.status,
                  value: statusLabel(booking.status),
                ),
                if (booking.customerNotes != null &&
                    booking.customerNotes!.isNotEmpty)
                  InfoLine(
                    icon: Icons.notes,
                    label: l.notes,
                    value: booking.customerNotes!,
                  ),
              ],
            ),
          ),
          if (!isLogged) ...[
            const SizedBox(height: AppSpacing.md),
            AppCard(
              onTap: () => showAuthSheet(context),
              child: Row(
                children: [
                  const Icon(
                    Icons.person_add_alt_1_outlined,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.createAccountToTrackBookings,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.gray2,
                          ),
                        ),
                        Text(
                          l.createAccountCta,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (isLogged) ...[
            const SizedBox(height: AppSpacing.md),
            SecondaryButton(label: l.backToHome, onPressed: () => goTo('/')),
          ],
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
