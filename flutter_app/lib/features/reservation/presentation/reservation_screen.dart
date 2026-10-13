import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../core/models/branch.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/format.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/widgets/widgets.dart';
import '../../auth/providers/auth_provider.dart';
import '../../services/models/service.dart';
import '../data/reservation_repository.dart';
import '../providers/reservation_flow_provider.dart';
import 'booking_confirmation_screen.dart';

List<String> _stepLabels(BuildContext context) => [
  context.l10n.chooseService,
  context.l10n.chooseBranch,
  context.l10n.chooseAppointment,
  context.l10n.confirmBooking,
];

/// The multi-step "Book Reservation" flow: choose service -> choose branch
/// -> choose date/time -> confirm booking. Mirrors
/// `frontend/app/[locale]/services/reservation/page.tsx` +
/// `frontend/providers/ReservationProvider.tsx`.
///
/// Accepts optional deep-link query params `service_id` / `branch_id`
/// to pre-fill and skip ahead.
class ReservationScreen extends ConsumerStatefulWidget {
  const ReservationScreen({super.key, this.serviceId, this.branchId});

  final int? serviceId;
  final int? branchId;

  @override
  ConsumerState<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends ConsumerState<ReservationScreen> {
  bool _preselected = false;
  final _confirmKey = GlobalKey<_ConfirmBookingStepState>();

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
      ref
          .read(reservationFlowProvider.notifier)
          .preselect(service: service, branch: branch);
    });
  }

  Widget? _bottomBar(ReservationFlowState flow) {
    final notifier = ref.read(reservationFlowProvider.notifier);
    final l = context.l10n;
    final String label;
    final VoidCallback? onPressed;
    var loading = false;
    switch (flow.step) {
      case ReservationStep.chooseService:
        if (flow.service == null) return null;
        label = l.next;
        onPressed = notifier.goNext;
      case ReservationStep.chooseBranch:
        label = l.next;
        onPressed = flow.branch == null ? null : notifier.goNext;
      case ReservationStep.chooseAppointment:
        label = l.next;
        onPressed = (flow.date != null && flow.time != null)
            ? notifier.goNext
            : null;
      case ReservationStep.confirmBooking:
        label = l.confirmBookingButton;
        loading = flow.isSubmitting;
        onPressed = flow.isSubmitting
            ? null
            : () => _confirmKey.currentState?.confirm();
    }
    final price = flow.service?.price;
    return StickyBottomBar(
      label: flow.step == ReservationStep.confirmBooking
          ? l.estimatedCost
          : null,
      value: flow.step == ReservationStep.confirmBooking
          ? Text(
              (price ?? 0) > 0 ? formatIqd(price!) : l.free,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.foregroundLight,
              ),
            )
          : null,
      action: Row(
        children: [
          if (flow.stepIndex > 0) ...[
            SizedBox(
              width: AppSpacing.buttonHeight,
              height: AppSpacing.buttonHeight,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: notifier.goBack,
                child: const Icon(Icons.arrow_back),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Expanded(
            child: PrimaryButton(
              label: label,
              loading: loading,
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(reservationServicesProvider);
    final branchesAsync = ref.watch(reservationBranchesProvider);
    final flow = ref.watch(reservationFlowProvider);

    if (servicesAsync.hasValue && branchesAsync.hasValue) {
      _maybePreselect(servicesAsync.value!, branchesAsync.value!);
    }

    return PopScope(
      canPop: flow.stepIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) ref.read(reservationFlowProvider.notifier).goBack();
      },
      child: AppScaffold(
        title: context.l10n.bookServiceAppointment,
        bottomBar: _bottomBar(flow),
        body: Column(
          children: [
            _ProgressHeader(currentStep: flow.stepIndex),
            Expanded(
              child: switch (flow.step) {
                ReservationStep.chooseService => _ChooseServiceStep(
                  servicesAsync: servicesAsync,
                ),
                ReservationStep.chooseBranch => _ChooseBranchStep(
                  branchesAsync: branchesAsync,
                ),
                ReservationStep.chooseAppointment =>
                  const _ChooseAppointmentStep(),
                ReservationStep.confirmBooking => _ConfirmBookingStep(
                  key: _confirmKey,
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact progress header: segmented bar + "Step N of 4" + step name.
class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.currentStep});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final labels = _stepLabels(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.md,
        AppSpacing.gutter,
        AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (var i = 0; i < labels.length; i++)
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 4,
                    margin: EdgeInsetsDirectional.only(
                      end: i == labels.length - 1 ? 0 : AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: i <= currentStep
                          ? AppColors.primary
                          : AppColors.gray,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Text(
                  labels[currentStep],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.foregroundLight,
                  ),
                ),
              ),
              Text(
                context.l10n.stepProgress(currentStep + 1, labels.length),
                style: const TextStyle(fontSize: 12, color: AppColors.gray2),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChooseServiceStep extends ConsumerWidget {
  const _ChooseServiceStep({required this.servicesAsync});

  final AsyncValue<List<Service>> servicesAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(
      reservationFlowProvider.select((f) => f.service?.id),
    );
    return servicesAsync.when(
      data: (services) {
        if (services.isEmpty) {
          return EmptyState(
            icon: Icons.build_outlined,
            title: context.l10n.noServicesAvailable,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          itemCount: services.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) {
            final service = services[index];
            return SelectableCard(
              selected: selected == service.id,
              onTap: () {
                HapticFeedback.selectionClick();
                ref.read(reservationFlowProvider.notifier).setService(service);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.foregroundLight,
                    ),
                  ),
                  if (service.description != null &&
                      service.description!.isNotEmpty)
                    Text(
                      service.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.gray2,
                      ),
                    ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule,
                        size: 16,
                        color: AppColors.gray2,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '${service.duration_minutes} ${context.l10n.minute}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.gray2,
                        ),
                      ),
                      const Spacer(),
                      Flexible(
                        child: Text(
                          service.price < 1
                              ? context.l10n.free
                              : formatIqd(service.price),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.foregroundLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const SkeletonList(itemHeight: 110),
      error: (error, _) => ErrorState(
        message: context.l10n.unexpectedError,
        onRetry: () => ref.invalidate(reservationServicesProvider),
      ),
    );
  }
}

String? _branchHours(Branch? b) {
  final sch = b?.schedules ?? const [];
  if (sch.isEmpty) return null;
  return formatTimeRange(sch.first.opens_at, sch.first.closes_at);
}

class _ChooseBranchStep extends ConsumerWidget {
  const _ChooseBranchStep({required this.branchesAsync});

  final AsyncValue<List<Branch>> branchesAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(
      reservationFlowProvider.select((f) => f.branch?.id),
    );
    return branchesAsync.when(
      data: (branches) {
        if (branches.isEmpty) {
          return EmptyState(
            icon: Icons.location_off_outlined,
            title: context.l10n.noBranchesAvailable,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          itemCount: branches.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) {
            final branch = branches[index];
            final hours = _branchHours(branch);
            return SelectableCard(
              selected: selected == branch.id,
              onTap: () {
                HapticFeedback.selectionClick();
                ref.read(reservationFlowProvider.notifier).setBranch(branch);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    branch.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.foregroundLight,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _line(Icons.location_on_outlined, branch.address),
                  _line(Icons.phone_outlined, branch.phone),
                  _line(Icons.access_time, hours),
                ],
              ),
            );
          },
        );
      },
      loading: () => const SkeletonList(itemHeight: 110),
      error: (error, _) => ErrorState(
        message: context.l10n.unexpectedError,
        onRetry: () => ref.invalidate(reservationBranchesProvider),
      ),
    );
  }

  Widget _line(IconData icon, String? text) => (text == null || text.isEmpty)
      ? const SizedBox.shrink()
      : Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 12, color: AppColors.gray2),
                ),
              ),
            ],
          ),
        );
}

class _ChooseAppointmentStep extends ConsumerWidget {
  const _ChooseAppointmentStep();

  static const _days = 30;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flow = ref.watch(reservationFlowProvider);
    final notifier = ref.read(reservationFlowProvider.notifier);
    final l = context.l10n;
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final schedules = flow.branch?.schedules ?? const [];

    bool closed(DateTime d) =>
        schedules.isNotEmpty &&
        schedules
            .where((s) => s.day_of_week == d.weekday % 7)
            .any((s) => s.is_closed);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
          child: Text(
            l.chooseDate,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.foregroundLight,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 84,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
            itemCount: _days,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, i) {
              final d = start.add(Duration(days: i));
              final iso = DateFormat('yyyy-MM-dd').format(d);
              return _DateTile(
                weekday: formatDateLocalized('EEE', d),
                day: formatDateLocalized('d', d),
                month: formatDateLocalized('MMM', d),
                selected: flow.date == iso,
                enabled: !closed(d),
                onTap: () => notifier.setDate(iso),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
          child: Text(
            l.chooseTime,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.foregroundLight,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
          child: flow.date == null
              ? Text(
                  l.chooseDateFirst,
                  style: const TextStyle(color: AppColors.gray2, fontSize: 13),
                )
              : flow.isSlotsLoading
              ? Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (var i = 0; i < 8; i++)
                      const ShimmerBox(width: 80, height: 44),
                  ],
                )
              : flow.slots.isEmpty
              ? Text(
                  l.noTimeAvailable,
                  style: const TextStyle(color: AppColors.gray2, fontSize: 13),
                )
              : Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final slot in flow.slots)
                      _TimeChip(
                        label: slot.time,
                        selected: flow.time == slot.time,
                        enabled: slot.available,
                        onTap: slot.available
                            ? () => notifier.setTime(slot.time)
                            : null,
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _DateTile extends StatelessWidget {
  const _DateTile({
    required this.weekday,
    required this.day,
    required this.month,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final String weekday;
  final String day;
  final String month;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = !enabled
        ? AppColors.gray
        : selected
        ? AppColors.onPrimary
        : AppColors.foregroundLight;
    return Material(
      color: selected ? AppColors.primary : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: enabled ? onTap : null,
        child: SizedBox(
          width: 60,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(weekday, style: TextStyle(fontSize: 11, color: fg)),
                Text(
                  day,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: fg,
                  ),
                ),
                Text(month, style: TextStyle(fontSize: 11, color: fg)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip({
    required this.label,
    required this.selected,
    required this.enabled,
    this.onTap,
  });

  final String label;
  final bool selected;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 72,
            minHeight: AppSpacing.minTap,
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.gray,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: !enabled
                  ? AppColors.gray2
                  : selected
                  ? AppColors.onPrimary
                  : AppColors.foregroundLight,
              decoration: enabled ? null : TextDecoration.lineThrough,
            ),
          ),
        ),
      ),
    );
  }
}

class _ConfirmBookingStep extends ConsumerStatefulWidget {
  const _ConfirmBookingStep({super.key});

  @override
  ConsumerState<_ConfirmBookingStep> createState() =>
      _ConfirmBookingStepState();
}

class _ConfirmBookingStepState extends ConsumerState<_ConfirmBookingStep> {
  final _notesController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  Map<String, String> _errors = {};

  @override
  void initState() {
    super.initState();
    final customer = ref.read(customerProvider);
    if (customer != null) {
      _nameController.text = customer.name;
      _phoneController.text = customer.phone;
      _emailController.text = customer.email ?? '';
    }
    _notesController.text = ref.read(reservationFlowProvider).notes;
  }

  /// Mirrors `ReservationProvider.createBooking` validation.
  Future<void> confirm() async {
    final flow = ref.read(reservationFlowProvider);
    final isLogged = ref.read(isLoggedInProvider);
    final errs = <String, String>{};
    final scheduled = DateTime.tryParse('${flow.date}T${flow.time}');
    if (scheduled == null || !scheduled.isAfter(DateTime.now()))
      errs['date'] = context.l10n.bookingDateInPast;
    if (!isLogged) {
      final phone = _phoneController.text.trim();
      final email = _emailController.text.trim();
      if (_nameController.text.trim().isEmpty)
        errs['name'] = context.l10n.fullNameRequired;
      if (phone.isEmpty) {
        errs['phone'] = context.l10n.phoneRequired;
      } else if (!isValidIraqiPhone(phone)) {
        errs['phone'] = context.l10n.phoneInvalid;
      }
      if (email.isNotEmpty &&
          !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
        errs['email'] = context.l10n.invalidEmail;
      }
    }
    setState(() => _errors = errs);
    if (errs.isNotEmpty) {
      if (errs['date'] != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errs['date']!)));
      }
      return;
    }
    final result = await ref
        .read(reservationFlowProvider.notifier)
        .createBooking(
          customerName: isLogged ? null : _nameController.text,
          customerPhone: isLogged ? null : _phoneController.text,
          customerEmail: isLogged ? null : _emailController.text,
        );
    if (result != null && mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BookingConfirmationScreen(booking: result),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flow = ref.watch(reservationFlowProvider);
    final notifier = ref.read(reservationFlowProvider.notifier);
    final l = context.l10n;
    final branch = flow.branch;
    final hours = _branchHours(branch);

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.all(AppSpacing.gutter),
      children: [
        AppCard(
          child: Column(
            children: [
              InfoLine(
                icon: Icons.build_outlined,
                label: l.service,
                value: flow.service?.name ?? '-',
              ),
              InfoLine(
                icon: Icons.location_on_outlined,
                label: l.branch,
                value: [
                  branch?.name ?? '-',
                  if (branch?.address.isNotEmpty ?? false) branch!.address,
                ].join('\n'),
              ),
              InfoLine(
                icon: Icons.calendar_today_outlined,
                label: '${l.date} / ${l.time}',
                value: '${flow.date ?? '-'}  ${flow.time ?? ''}',
              ),
              if (hours != null)
                InfoLine(
                  icon: Icons.access_time,
                  label: l.branchInformation,
                  value: hours,
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (!ref.watch(isLoggedInProvider)) ...[
          Text(
            l.contactInformation,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.foregroundLight,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            label: l.fullName,
            controller: _nameController,
            errorText: _errors['name'],
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: l.phoneNumber,
            controller: _phoneController,
            errorText: _errors['phone'],
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: l.emailOptional,
            controller: _emailController,
            errorText: _errors['email'],
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        AppTextField(
          label: l.bookingNotesHint,
          controller: _notesController,
          maxLines: 3,
          onChanged: notifier.setNotes,
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          padding: EdgeInsets.zero,
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
              ),
              childrenPadding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              leading: const Icon(Icons.info_outline, color: AppColors.blue),
              title: Text(
                l.importantNotes,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.foregroundLight,
                ),
              ),
              children: [
                for (final n in [
                  l.arriveEarlyNote,
                  l.lateArrivalNote,
                  l.modifyBookingNote,
                ])
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '•  ',
                          style: TextStyle(color: AppColors.gray2),
                        ),
                        Expanded(
                          child: Text(
                            n,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.gray2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (flow.submitError != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            flow.submitError!,
            style: const TextStyle(color: AppColors.error, fontSize: 13),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
