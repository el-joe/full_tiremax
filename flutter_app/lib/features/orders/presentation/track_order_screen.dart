import '../../../l10n/l10n.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/format.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/widgets.dart';
import '../../reservation/data/reservation_repository.dart';
import '../../reservation/models/reservation.dart';
import '../data/orders_repository.dart';
import '../models/order.dart';

/// Mirrors `frontend/components/pages/trackOrder/TrackForm.tsx`: guest lookup
/// of an order (or booking) by reference + phone. Tries `orders/{ref}` then
/// `bookings/{ref}` (reversed when `type == 'booking'`), skipping 404s.
class TrackOrderScreen extends ConsumerStatefulWidget {
  const TrackOrderScreen({this.reference, this.phone, this.type, super.key});

  final String? reference;
  final String? phone;
  final String? type;

  @override
  ConsumerState<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends ConsumerState<TrackOrderScreen> {
  late final _reference = TextEditingController(text: widget.reference ?? '');
  late final _phone = TextEditingController(text: widget.phone ?? '');
  Order? _order;
  Reservation? _booking;
  String? _error;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if ((widget.reference ?? '').isNotEmpty &&
        (widget.phone ?? '').isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _search());
    }
  }

  @override
  void dispose() {
    _reference.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final reference = _reference.text.trim();
    final phone = _phone.text.trim();
    setState(() {
      _error = null;
      _order = null;
      _booking = null;
    });
    if (reference.isEmpty || phone.isEmpty) {
      setState(() => _error = context.l10n.required);
      return;
    }
    setState(() => _loading = true);
    final kinds = widget.type == 'booking'
        ? ['booking', 'order']
        : ['order', 'booking'];
    try {
      for (final kind in kinds) {
        try {
          if (kind == 'order') {
            final o = await ref
                .read(ordersRepositoryProvider)
                .trackOrder(reference, phone);
            if (mounted) setState(() => _order = o);
          } else {
            final b = await ref
                .read(reservationRepositoryProvider)
                .trackBooking(reference, phone);
            if (mounted) setState(() => _booking = b);
          }
          return;
        } on DioException catch (e) {
          if (e.response?.statusCode != 404) rethrow;
        }
      }
      if (mounted) setState(() => _error = context.l10n.notFound);
    } catch (_) {
      if (mounted) setState(() => _error = context.l10n.error);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AppScaffold(
      title: l.trackOrder,
      bottomBar: StickyBottomBar(
        action: PrimaryButton(
          label: l.track,
          icon: Icons.search,
          loading: _loading,
          onPressed: _loading ? null : _search,
        ),
      ),
      body: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.all(AppSpacing.gutter),
        children: [
          Text(
            l.description,
            style: const TextStyle(fontSize: 14, color: AppColors.gray2),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Column(
              children: [
                AppTextField(
                  label: l.reference,
                  controller: _reference,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.confirmation_number_outlined),
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: l.authPhoneNumber,
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.search,
                  onFieldSubmitted: (_) => _search(),
                  prefixIcon: const Icon(Icons.phone_outlined),
                ),
              ],
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 18,
                  color: AppColors.error,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    _error!,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (_loading) ...[
            const SizedBox(height: AppSpacing.lg),
            const ShimmerBox(height: 140),
          ],
          if (_order != null)
            _ResultCard(
              reference: _order!.reference,
              status: _order!.status,
              kind: StatusBadgeKind.orderDetail,
              children: [
                for (final i in _order!.items)
                  SummaryRow(
                    label: '${i.product_name} x${i.quantity}',
                    value: formatIqd(i.total),
                  ),
                const Divider(color: AppColors.gray),
                SummaryRow(
                  label: l.cartTotal,
                  value: formatIqd(_order!.total),
                  bold: true,
                ),
              ],
            ),
          if (_booking != null)
            _ResultCard(
              reference: _booking!.reference,
              status: _booking!.status,
              kind: StatusBadgeKind.bookingDetail,
              children: [
                InfoLine(
                  icon: Icons.build_outlined,
                  label: l.service,
                  value: _booking!.service.name,
                ),
                InfoLine(
                  icon: Icons.location_on_outlined,
                  label: l.branch,
                  value: _booking!.branch.name,
                ),
                InfoLine(
                  icon: Icons.calendar_today_outlined,
                  label: '${l.date} / ${l.time}',
                  value: formatDateLocalized(
                    'EEE, MMM d, yyyy • h:mm a',
                    _booking!.scheduled_at.toLocal(),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.reference,
    required this.status,
    required this.kind,
    required this.children,
  });

  final String reference;
  final String status;
  final StatusBadgeKind kind;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final (fg, _) = statusBadgeColors(kind, status);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    reference,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.foregroundLight,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                StatusPill(label: statusLabel(status), color: fg),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ...children,
          ],
        ),
      ),
    );
  }
}
