import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../data/orders_repository.dart';
import '../models/order.dart';

/// Shown after a successful checkout: order reference, items, totals and
/// payment status. Pushed via `Navigator.push` (no dedicated go_router
/// route), mirroring the reservation flow's `BookingConfirmationScreen` and
/// `frontend/app/[locale]/checkout/confirm/[orderId]/page.tsx`.
class OrderConfirmationScreen extends ConsumerWidget {
  const OrderConfirmationScreen({super.key, required this.orderId});

  final int orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(_orderProvider(orderId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, title: const Text('Order Confirmed')),
      body: SafeArea(
        child: orderAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (err, _) => Center(
            child: Text('Could not load order details.', style: TextStyle(color: AppColors.gray2)),
          ),
          data: (order) => _OrderConfirmationBody(order: order),
        ),
      ),
    );
  }
}

final _orderProvider = FutureProvider.family<Order, int>((ref, id) {
  return ref.watch(ordersRepositoryProvider).fetchOrder(id);
});

class _OrderConfirmationBody extends StatelessWidget {
  const _OrderConfirmationBody({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
          child: const Icon(Icons.check, color: Colors.white, size: 48),
        ),
        const SizedBox(height: 20),
        const Text(
          'Your order has been placed!',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            '#${order.reference}',
            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 16),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.gray3, borderRadius: AppRadii.radiusXl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Items', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              for (final item in order.items) ...[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${item.product_name} x${item.quantity}',
                        style: const TextStyle(color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(item.total.toStringAsFixed(2), style: const TextStyle(color: AppColors.gray2)),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.gray3, borderRadius: AppRadii.radiusXl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _row('Subtotal', order.subtotal.toStringAsFixed(2)),
              if (order.discount > 0) _row('Discount', '-${order.discount.toStringAsFixed(2)}'),
              if (order.shipping_fee > 0) _row('Shipping', order.shipping_fee.toStringAsFixed(2)),
              if (order.installation_fee > 0) _row('Installation', order.installation_fee.toStringAsFixed(2)),
              const Divider(color: AppColors.background),
              _row('Total', order.total.toStringAsFixed(2), bold: true),
              const SizedBox(height: 8),
              _row('Payment method', order.payment_method),
              _row('Payment status', order.payment_status),
              _row('Order status', order.status),
              if (order.type == 'delivery') _row('Delivery address', order.shipping_address),
              if (order.branch != null) _row('Branch', order.branch!.name),
            ],
          ),
        ),
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
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: const Text('Back to Home', style: TextStyle(fontWeight: FontWeight.w800)),
          ),
        ),
      ],
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.gray2)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: bold ? AppColors.primary : Colors.white,
                fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
