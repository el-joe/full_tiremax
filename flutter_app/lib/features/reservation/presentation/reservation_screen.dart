import '../../../l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/format.dart';
import '../../../core/theme/app_radii.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/models/branch.dart';
import '../../services/models/service.dart';
import '../data/reservation_repository.dart';
import '../providers/reservation_flow_provider.dart';
import 'booking_confirmation_screen.dart';

List<String> _stepLabels(BuildContext context) => [context.l10n.chooseService, context.l10n.chooseBranch, context.l10n.chooseAppointment, context.l10n.confirmBooking];
List<String> _stepNums(BuildContext context) => [context.l10n.step1, context.l10n.step2, context.l10n.step3, context.l10n.step4];
const _stepIcons = [Icons.build_outlined, Icons.location_on_outlined, Icons.calendar_today_outlined, Icons.check_circle_outline];

/// The multi-step "Book Reservation" flow: choose service -> choose branch
/// -> choose date/time -> confirm booking. Mirrors
/// `frontend/app/[locale]/services/reservation/page.tsx` +
/// `frontend/providers/ReservationProvider.tsx`.
///
/// Accepts optional deep-link query params `service_id` / `branch_id`
/// (mirroring `services/reservation?service_id=X&branch_id=Y`) to pre-fill
/// and skip ahead, e.g. from the Services screen's context.l10n.headerBookNow CTA.
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
      appBar: AppBar(backgroundColor: AppColors.background, title: Text(context.l10n.bookServiceAppointment)),
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

/// Web `StepIndicator`: rounded-square icon tile (complete = green, active =
/// primary with glow, incomplete = white with gray border), step name, "Step N"
/// and a 4px separator bar between items.
class _StepperHeader extends StatelessWidget {
  const _StepperHeader({required this.currentStep});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 16, 12, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(_stepLabels(context).length, (index) {
          final isDone = index < currentStep;
          final isActive = index == currentStep;
          final Color bg = isDone
              ? const Color(0xFF00C950)
              : isActive
                  ? AppColors.primary
                  : Colors.white;
          final Color fg = isDone
              ? Colors.white
              : isActive
                  ? Colors.white
                  : const Color(0xFF99A1AF);
          final tile = Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
              border: !isDone && !isActive ? Border.all(color: const Color(0xFFE5E7EB), width: 2) : null,
              boxShadow: [
                BoxShadow(
                  color: isActive ? const Color(0x80FDB604) : const Color(0x1A000000),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Icon(isDone ? Icons.check_circle_outline : _stepIcons[index], color: fg, size: 22),
          );
          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: index == 0
                          ? const SizedBox.shrink()
                          : Container(
                              height: 4,
                              decoration: BoxDecoration(
                                color: index <= currentStep ? AppColors.primary : const Color(0xFFE5E7EB),
                                borderRadius: AppRadii.radiusFull,
                              ),
                            ),
                    ),
                    tile,
                    Expanded(
                      child: index == _stepLabels(context).length - 1
                          ? const SizedBox.shrink()
                          : Container(
                              height: 4,
                              decoration: BoxDecoration(
                                color: index < currentStep ? AppColors.primary : const Color(0xFFE5E7EB),
                                borderRadius: AppRadii.radiusFull,
                              ),
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _stepLabels(context)[index],
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isActive || isDone ? Colors.white : const Color(0xFF6A7282),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(_stepNums(context)[index], style: const TextStyle(color: Color(0xFF99A1AF), fontSize: 9)),
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
          return Center(child: Text(context.l10n.noServicesAvailable, style: TextStyle(color: AppColors.gray2)));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: services.length + 1,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.chooseRequiredService,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20)),
                  SizedBox(height: 4),
                  Text(context.l10n.chooseRequiredServiceDescription,
                      style: TextStyle(color: AppColors.gray2, fontSize: 13)),
                ],
              );
            }
            final service = services[index - 1];
            return _OptionCard(
              title: service.name,
              subtitle: service.description,
              meta: [
                (context.l10n.duration, '${service.duration_minutes} ${context.l10n.minute}'),
                (context.l10n.cost, service.price < 1 ? context.l10n.free : formatIqd(service.price)),
              ],
              cta: context.l10n.chooseThisService,
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
        _BackHeader(
          onBack: () => ref.read(reservationFlowProvider.notifier).goBack(),
          title: context.l10n.chooseNearestBranch,
          subtitle: '${context.l10n.selectedService}: ${ref.watch(reservationFlowProvider).service?.name ?? ''}',
        ),
        Expanded(
          child: branchesAsync.when(
            data: (branches) {
              if (branches.isEmpty) {
                return Center(child: Text(context.l10n.noBranchesAvailable, style: TextStyle(color: AppColors.gray2)));
              }
              return ListView.separated(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
                itemCount: branches.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final branch = branches[index];
                  return _BranchCard(
                    branch: branch,
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
        _BackHeader(
          onBack: notifier.goBack,
          title: context.l10n.chooseDateAndTime,
          subtitle: '${context.l10n.selectedBranch}: ${flow.branch?.name ?? ''}',
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.chooseDate, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
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
                          flow.date ?? context.l10n.selectADate,
                          style: TextStyle(color: flow.date != null ? Colors.white : AppColors.gray2),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(context.l10n.chooseTime, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 10),
                if (flow.date == null)
                  Text(context.l10n.chooseDateFirst, style: TextStyle(color: AppColors.gray2))
                else if (flow.isSlotsLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                  )
                else if (flow.slots.isEmpty)
                  Text(context.l10n.noTimeAvailable, style: TextStyle(color: AppColors.gray2))
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
                    child: Text(context.l10n.continueToConfirmation, style: TextStyle(fontWeight: FontWeight.w800)),
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
  }

  /// Mirrors `ReservationProvider.createBooking` validation.
  Future<void> _confirm() async {
    final flow = ref.read(reservationFlowProvider);
    final isLogged = ref.read(isLoggedInProvider);
    final errs = <String, String>{};
    final scheduled = DateTime.tryParse('${flow.date}T${flow.time}');
    if (scheduled == null || !scheduled.isAfter(DateTime.now())) errs['date'] = context.l10n.bookingDateInPast;
    if (!isLogged) {
      final phone = _phoneController.text.trim();
      final email = _emailController.text.trim();
      if (_nameController.text.trim().isEmpty) errs['name'] = context.l10n.fullNameRequired;
      if (phone.isEmpty) {
        errs['phone'] = context.l10n.phoneRequired;
      } else if (!isValidIraqiPhone(phone)) {
        errs['phone'] = context.l10n.phoneInvalid;
      }
      if (email.isNotEmpty && !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
        errs['email'] = context.l10n.invalidEmail;
      }
    }
    setState(() => _errors = errs);
    if (errs.isNotEmpty) {
      if (errs['date'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errs['date']!)));
      }
      return;
    }
    final result = await ref.read(reservationFlowProvider.notifier).createBooking(
          customerName: isLogged ? null : _nameController.text,
          customerPhone: isLogged ? null : _phoneController.text,
          customerEmail: isLogged ? null : _emailController.text,
        );
    if (result != null && mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => BookingConfirmationScreen(booking: result)),
      );
    }
  }

  Widget _contactField(TextEditingController c, String hint, String? error, [TextInputType? type]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        keyboardType: type,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          errorText: error,
          hintStyle: const TextStyle(color: AppColors.gray2),
          filled: true,
          fillColor: AppColors.gray3,
          border: OutlineInputBorder(borderRadius: AppRadii.radiusLg, borderSide: BorderSide.none),
        ),
      ),
    );
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BackHeader(onBack: notifier.goBack, title: context.l10n.bookingConfirmation, subtitle: context.l10n.reviewBookingDetails),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
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
                      Text(context.l10n.bookingSummary, style: TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.w800, fontSize: 16)),
                      const SizedBox(height: 16),
                      _summaryRow(context.l10n.service, flow.service?.name ?? '-'),
                      _summaryRow(context.l10n.branch, flow.branch?.name ?? '-'),
                      _summaryRow(context.l10n.date, flow.date ?? '-'),
                      _summaryRow(context.l10n.time, flow.time ?? '-'),
                      const Divider(color: AppColors.onPrimary, height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(context.l10n.estimatedCost, style: TextStyle(color: AppColors.onPrimary)),
                          Text(
                            (flow.service?.price ?? 0) > 0 ? formatIqd(flow.service!.price) : context.l10n.free,
                            style: const TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.w800, fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _BranchInfoCard(branch: flow.branch),
                const SizedBox(height: 16),
                const _NotesCard(),
                const SizedBox(height: 20),
                if (!ref.watch(isLoggedInProvider)) ...[
                  Text(context.l10n.contactInformation, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  _contactField(_nameController, context.l10n.fullName, _errors['name']),
                  _contactField(_phoneController, context.l10n.phoneNumber, _errors['phone'], TextInputType.phone),
                  _contactField(_emailController, context.l10n.emailOptional, _errors['email'], TextInputType.emailAddress),
                ],
                const SizedBox(height: 10),
                Text(context.l10n.notes, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                TextField(
                  controller: _notesController,
                  onChanged: notifier.setNotes,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: context.l10n.bookingNotesHint,
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
                        : _confirm,
                    child: flow.isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onPrimary),
                          )
                        : Text(context.l10n.confirmBookingButton, style: TextStyle(fontWeight: FontWeight.w800)),
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
  const _BackHeader({required this.onBack, this.title, this.subtitle});

  final VoidCallback onBack;
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(title!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
                if (subtitle != null)
                  Text(subtitle!, style: const TextStyle(color: AppColors.gray2, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Web service card: name, description, duration + cost and a
/// context.l10n.chooseThisService action.
class _OptionCard extends StatelessWidget {
  const _OptionCard({required this.title, required this.subtitle, this.meta = const [], required this.cta, required this.onTap});

  final String title;
  final String? subtitle;
  final List<(String, String)> meta;
  final String cta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadii.radiusXl,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.gray3,
          borderRadius: AppRadii.radiusXl,
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
            if (subtitle != null && subtitle!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(subtitle!, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.gray2, fontSize: 12)),
            ],
            const SizedBox(height: 12),
            for (final m in meta)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(m.$1, style: const TextStyle(color: AppColors.gray2, fontSize: 13)),
                    Text(m.$2, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                  ],
                ),
              ),
            const Divider(color: Color(0x33FFFFFF), height: 20),
            Row(
              children: [
                Text(cta, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.primary,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _iconLine(IconData icon, String? text) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(text ?? '', style: const TextStyle(color: AppColors.gray2, fontSize: 13))),
        ],
      ),
    );

String? _branchHours(Branch? b) {
  final sch = b?.schedules ?? const [];
  if (sch.isEmpty) return null;
  return formatTimeRange(sch.first.opens_at, sch.first.closes_at);
}

/// Web `BranchCard` (ChooseBranch): name, 4.8 rating, address, phone, hours
/// and a context.l10n.chooseThisBranch action.
class _BranchCard extends StatelessWidget {
  const _BranchCard({required this.branch, required this.onTap});

  final Branch branch;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadii.radiusXl,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.gray3,
          borderRadius: AppRadii.radiusXl,
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(branch.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.star, color: AppColors.primary, size: 16),
                SizedBox(width: 4),
                Text('4.8', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                SizedBox(width: 4),
                Text('(288${context.l10n.rate})', style: TextStyle(color: AppColors.gray2, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 12),
            _iconLine(Icons.location_on_outlined, branch.address),
            _iconLine(Icons.phone_outlined, branch.phone),
            _iconLine(Icons.access_time, _branchHours(branch)),
            const Divider(color: Color(0x33FFFFFF), height: 20),
            Row(
              children: [
                Text(context.l10n.chooseThisBranch, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.primary,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Web `BranchInfoCard` (ConfirmBooking).
class _BranchInfoCard extends StatelessWidget {
  const _BranchInfoCard({required this.branch});

  final Branch? branch;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.gray3,
        borderRadius: AppRadii.radiusXl,
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.branchInformation, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
          const SizedBox(height: 12),
          _iconLine(Icons.location_on_outlined, branch?.address),
          _iconLine(Icons.phone_outlined, branch?.phone),
          _iconLine(Icons.access_time, _branchHours(branch)),
          const Divider(color: Color(0x33FFFFFF), height: 20),
          Row(
            children: [
              Icon(Icons.star, color: AppColors.primary, size: 18),
              SizedBox(width: 8),
              Text('4.8', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              SizedBox(width: 6),
              Text('(288${context.l10n.rate})', style: TextStyle(color: AppColors.gray2)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Web `NotesCard`: blue info box with the three important notes.
class _NotesCard extends StatelessWidget {
  const _NotesCard();

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF1447E6);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: AppRadii.radiusXl,
        border: Border.all(color: Color(0xFFBEDBFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.importantNotes, style: TextStyle(color: blue, fontWeight: FontWeight.w800, fontSize: 18)),
          SizedBox(height: 8),
          for (final n in [context.l10n.arriveEarlyNote, context.l10n.lateArrivalNote, context.l10n.modifyBookingNote])
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('•  ', style: TextStyle(color: blue)),
                  Expanded(child: Text(n, style: const TextStyle(color: blue, fontSize: 13))),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
