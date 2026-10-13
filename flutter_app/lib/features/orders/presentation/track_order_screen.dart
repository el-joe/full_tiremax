import '../../../l10n/l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
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
    if ((widget.reference ?? '').isNotEmpty && (widget.phone ?? '').isNotEmpty) {
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
    final kinds = widget.type == 'booking' ? ['booking', 'order'] : ['order', 'booking'];
    try {
      for (final kind in kinds) {
        try {
          if (kind == 'order') {
            final o = await ref.read(ordersRepositoryProvider).trackOrder(reference, phone);
            if (mounted) setState(() => _order = o);
          } else {
            final b = await ref.read(reservationRepositoryProvider).trackBooking(reference, phone);
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, title: Text(context.l10n.trackOrder)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(context.l10n.title,
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(context.l10n.description,
                style: TextStyle(color: AppColors.gray2)),
            const SizedBox(height: 16),
            TextField(
              controller: _reference,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: context.l10n.reference),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              onSubmitted: (_) => _search(),
              decoration: InputDecoration(labelText: context.l10n.authPhoneNumber),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: AppRadii.radiusFull),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _loading ? null : _search,
              child: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onPrimary),
                    )
                  : Text(context.l10n.track, style: TextStyle(fontWeight: FontWeight.w700)),
            ),
            if (_error != null) ...[
              const SizedBox(height: 14),
              Text(_error!, style: const TextStyle(color: AppColors.error)),
            ],
            if (_order != null) _ResultCard(reference: _order!.reference, status: _order!.status, children: [
              for (final i in _order!.items)
                _Row('${i.product_name} x${i.quantity}', '${i.total}'),
              _Row(context.l10n.cartTotal, '${_order!.total}', bold: true),
            ]),
            if (_booking != null) _ResultCard(reference: _booking!.reference, status: _booking!.status, children: [
              _Row(_booking!.service.name, ''),
              _Row(_booking!.branch.name, ''),
              _Row(_booking!.scheduled_at.toLocal().toString().split('.').first, ''),
            ]),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.reference, required this.status, required this.children});

  final String reference;
  final String status;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.gray3, borderRadius: AppRadii.radiusXxl),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(reference,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2), borderRadius: AppRadii.radiusFull),
                child: Text(status,
                    style: const TextStyle(
                        color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.left, this.right, {this.bold = false});

  final String left;
  final String right;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
        color: Colors.white, fontWeight: bold ? FontWeight.w800 : FontWeight.w400);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Expanded(child: Text(left, style: style)), Text(right, style: style)],
      ),
    );
  }
}
