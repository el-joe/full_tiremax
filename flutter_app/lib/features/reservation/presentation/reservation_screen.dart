import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/utils/protected_action.dart';
import '../../../core/models/branch.dart';
import '../../services/models/service.dart';
import '../data/reservation_repository.dart';
import '../providers/reservation_flow_provider.dart';
import 'booking_confirmation_screen.dart';

const _stepLabels = ['Service', 'Branch', 'Date & Time', 'Confirm'];
const _stepIcons = [Icons.build_outlined, Icons.location_on_outlined, Icons.calendar_today_outlined, Icons.check_circle_outline];

/// The multi-step "Book Reservation" flow: choose service -> choose branch
/// -> choose date/time -> confirm booking. Mirrors
/// `frontend/app/[locale]/services/reservation/page.tsx` +
/// `frontend/providers/ReservationProvider.tsx`.
///
/// Accepts optional deep-link query params `service_id` / `branch_id`
/// (mirroring `services/reservation?service_id=X&branch_id=Y`) to pre-fill
/// and skip ahead, e.g. from the Services screen's "Book now" CTA.
class ReservationScreen extends ConsumerStatefulWidget {
  const ReservationScreen({super.key, this.serviceId, this.branchId});

  final int? serviceId;
  final int? branchId;

  @override
  ConsumerState<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends ConsumerState<ReservationScreen> {
  bool _preselected = false;

  void _maybePreselect(List<Service> services, List<Branch> branches) {
    if (_preselected || widget.serviceId == null) return;
    _preselected = true;
    Service? service;
    for (final s in services) {
      if (s.id == widget.serviceId) service = s;
    }
    if (service == null) return;
    Branch? branch;
    if (widget.branchId != null) {
      for (final b in branches) {
        if (b.id == widget.branchId) branch = b;
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reservationFlowProvider.notifier).preselect(service: service, branch: branch);
    });
  }

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(reservationServicesProvider);
    final branchesAsync = ref.watch(reservationBranchesProvider);
    final flow = ref.watch(reservationFlowProvider);

    if (servicesAsync.hasValue && branchesAsync.hasValue) {
      _maybePreselect(servicesAsync.value!, branchesAsync.value!);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, title: const Text('Book Reservation')),
      body: SafeArea(
        child: Column(
          children: [
            _StepperHeader(currentStep: flow.stepIndex),
            Expanded(
              child: switch (flow.step) {
                ReservationStep.chooseService => _ChooseServiceStep(servicesAsync: servicesAsync),
                ReservationStep.chooseBranch => _ChooseBranchStep(branchesAsync: branchesAsync),
                ReservationStep.chooseAppointment => const _ChooseAppointmentStep(),
                ReservationStep.confirmBooking => const _ConfirmBookingStep(),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StepperHeader extends StatelessWidget {
  const _StepperHeader({required this.currentStep});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: List.generate(_stepLabels.length, (index) {
          final isDone = index < currentStep;
          final isActive = index == currentStep;
          final color = isDone
              ? AppColors.green
              : isActive
                  ? AppColors.primary
                  : AppColors.gray3;
          final iconColor = isActive ? AppColors.onPrimary : Colors.white;
          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    if (index != 0)
                      Expanded(
                        child: Container(height: 3, color: index <= currentStep ? AppColors.primary : AppColors.gray3),
                      ),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: isDone
                          ? const Icon(Icons.check, color: Colors.white, size: 18)
                          : Icon(_stepIcons[index], color: iconColor, size: 18),
                    ),
                    if (index != _stepLabels.length - 1)
                      Expanded(
                        child: Container(height: 3, color: index < currentStep ? AppColors.primary : AppColors.gray3),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _stepLabels[index],
                  style: TextStyle(
                    color: isActive ? Colors.white : AppColors.gray2,
                    fontSize: 11,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _ChooseServiceStep extends ConsumerWidget {
  const _ChooseServiceStep({required this.servicesAsync});

  final AsyncValue<List<Service>> servicesAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return servicesAsync.when(
      data: (services) {
        if (services.isEmpty) {
          return const Center(child: Text('No services available.', style: TextStyle(color: AppColors.gray2)));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: services.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final service = services[index];
            return _OptionCard(
              title: service.name,
              subtitle: service.description,
              trailing: '${service.price} EGP  •  ${service.duration_minutes} min',
              onTap: () => ref.read(reservationFlowProvider.notifier).setService(service),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      error: (error, _) => Center(child: Text('$error', style: const TextStyle(color: AppColors.gray2))),
    );
  }
}

class _ChooseBranchStep extends ConsumerWidget {
  const _ChooseBranchStep({required this.branchesAsync});

  final AsyncValue<List<Branch>> branchesAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BackHeader(onBack: () => ref.read(reservationFlowProvider.notifier).goBack()),
        Expanded(
          child: branchesAsync.when(
            data: (branches) {
              if (branches.isEmpty) {
                return const Center(child: Text('No branches available.', style: TextStyle(color: AppColors.gray2)));
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: branches.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final branch = branches[index];
                  return _OptionCard(
                    title: branch.name,
                    subtitle: '${branch.address}  •  ${branch.phone}',
                    onTap: () => ref.read(reservationFlowProvider.notifier).setBranch(branch),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
            error: (error, _) => Center(child: Text('$error', style: const TextStyle(color: AppColors.gray2))),
          ),
        ),
      ],
    );
  }
}

class _ChooseAppointmentStep extends ConsumerWidget {
  const _ChooseAppointmentStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flow = ref.watch(reservationFlowProvider);
    final notifier = ref.read(reservationFlowProvider.notifier);
    final now = DateTime.now();
    final maxDate = now.add(const Duration(days: 30));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BackHeader(onBack: notifier.goBack, subtitle: 'Branch: ${flow.branch?.name ?? ''}'),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Choose date', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 10),
                InkWell(
                  borderRadius: AppRadii.radiusLg,
                  onTap: () async {
                    final schedules = flow.branch?.schedules ?? const [];
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: now,
                      lastDate: maxDate,
                      initialDate: now,
                      selectableDayPredicate: schedules.isEmpty
                          ? null
                          : (date) {
                              final closed = schedules
                                  .where((s) => s.day_of_week == date.weekday % 7)
                                  .any((s) => s.is_closed);
                              return !closed;
                            },
                    );
                    if (picked != null) {
                      await notifier.setDate(DateFormat('yyyy-MM-dd').format(picked));
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.gray3,
                      borderRadius: AppRadii.radiusLg,
                      border: Border.all(color: AppColors.gray),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, color: AppColors.primary, size: 18),
                        const SizedBox(width: 10),
                        Text(
                          flow.date ?? 'Select a date',
                          style: TextStyle(color: flow.date != null ? Colors.white : AppColors.gray2),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Choose time', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 10),
                if (flow.date == null)
                  const Text('Choose a date first.', style: TextStyle(color: AppColors.gray2))
                else if (flow.isSlotsLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                  )
                else if (flow.slots.isEmpty)
                  const Text('No time slots available for this date.', style: TextStyle(color: AppColors.gray2))
                else
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: flow.slots.map((slot) {
                      final selected = flow.time == slot.time;
                      return _TimeChip(
                        label: slot.time,
                        selected: selected,
                        enabled: slot.available,
                        onTap: slot.available ? () => notifier.setTime(slot.time) : null,
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: AppRadii.radiusLg),
                    ),
                    onPressed: (flow.date != null && flow.time != null) ? notifier.goNext : null,
                    child: const Text('Continue to confirmation', style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip({required this.label, required this.selected, required this.enabled, this.onTap});

  final String label;
  final bool selected;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.radiusMd,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.gray3,
          borderRadius: AppRadii.radiusMd,
          border: Border.all(color: selected ? AppColors.primary : AppColors.gray),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: !enabled
                ? AppColors.gray2
                : selected
                    ? AppColors.onPrimary
                    : Colors.white,
            fontWeight: FontWeight.w600,
            decoration: enabled ? null : TextDecoration.lineThrough,
          ),
        ),
      ),
    );
  }
}

class _ConfirmBookingStep extends ConsumerStatefulWidget {
  const _ConfirmBookingStep();

  @override
  ConsumerState<_ConfirmBookingStep> createState() => _ConfirmBookingStepState();
}

class _ConfirmBookingStepState extends ConsumerState<_ConfirmBookingStep> {
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flow = ref.watch(reservationFlowProvider);
    final notifier = ref.read(reservationFlowProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BackHeader(onBack: notifier.goBack, subtitle: 'Review your booking details'),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: AppRadii.radiusXl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Booking summary', style: TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.w800, fontSize: 16)),
                      const SizedBox(height: 16),
                      _summaryRow('Service', flow.service?.name ?? '-'),
                      _summaryRow('Branch', flow.branch?.name ?? '-'),
                      _summaryRow('Date', flow.date ?? '-'),
                      _summaryRow('Time', flow.time ?? '-'),
                      const Divider(color: AppColors.onPrimary, height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Estimated cost', style: TextStyle(color: AppColors.onPrimary)),
                          Text(
                            '${flow.service?.price ?? 0} EGP',
                            style: const TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.w800, fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Notes (optional)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                TextField(
                  controller: _notesController,
                  onChanged: notifier.setNotes,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'e.g. Please check wheel balance too',
                    hintStyle: const TextStyle(color: AppColors.gray2),
                    filled: true,
                    fillColor: AppColors.gray3,
                    border: OutlineInputBorder(borderRadius: AppRadii.radiusLg, borderSide: BorderSide.none),
                  ),
                ),
                if (flow.submitError != null) ...[
                  const SizedBox(height: 16),
                  Text(flow.submitError!, style: const TextStyle(color: AppColors.error)),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: AppRadii.radiusLg),
                    ),
                    onPressed: flow.isSubmitting
                        ? null
                        : () => requireAuth(context, ref, () async {
                              final result = await notifier.createBooking();
                              if (result != null && context.mounted) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => BookingConfirmationScreen(booking: result)),
                                );
                              }
                            }),
                    child: flow.isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onPrimary),
                          )
                        : const Text('Confirm Booking', style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.onPrimary)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackHeader extends StatelessWidget {
  const _BackHeader({required this.onBack, this.subtitle});

  final VoidCallback onBack;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 16, 8),
      child: Row(
        children: [
          IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back, color: Colors.white)),
          if (subtitle != null)
            Expanded(
              child: Text(subtitle!, style: const TextStyle(color: AppColors.gray2, fontSize: 13)),
            ),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({required this.title, required this.subtitle, this.trailing, required this.onTap});

  final String title;
  final String subtitle;
  final String? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadii.radiusXl,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.gray3, borderRadius: AppRadii.radiusXl),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.gray2, fontSize: 12)),
                  if (trailing != null) ...[
                    const SizedBox(height: 8),
                    Text(trailing!, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12)),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.gray2),
          ],
        ),
      ),
    );
  }
}
