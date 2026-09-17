import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../data/orders_repository.dart';
import '../providers/orders_provider.dart';
import 'orders_screen.dart';

/// GET /orders/{id} detail: items/totals/shipping/tracking, "Cancel order"
/// (POST /orders/{id}/cancel) shown only while `isOrderCancellable(status)`.
class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final int orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailProvider(orderId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, title: const Text('Order Detail')),
      body: SafeArea(
        child: orderAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (error, _) => Center(child: Text('$error', style: const TextStyle(color: AppColors.gray2))),
          data: (order) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('#${order.reference}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
                    ),
                    StatusChip(status: order.status),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Placed ${order.placed_at}', style: const TextStyle(color: AppColors.gray2, fontSize: 12)),
                const SizedBox(height: 20),
                _SectionCard(
                  title: 'Items',
                  child: Column(
                    children: [
                      for (final item in order.items)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.product_name,
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                    Text('SKU ${item.product_sku} × ${item.quantity}',
                                        style: const TextStyle(color: AppColors.gray2, fontSize: 12)),
                                  ],
                                ),
                              ),
                              Text('${item.total.toStringAsFixed(0)} EGP',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Totals',
                  child: Column(
                    children: [
                      _row('Subtotal', order.subtotal),
                      _row('Discount', -order.discount),
                      _row('Shipping', order.shipping_fee),
                      if (order.installation_fee > 0) _row('Installation', order.installation_fee),
                      const Divider(color: AppColors.gray),
                      _row('Total', order.total, bold: true),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Shipping & Payment',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.customer_name, style: const TextStyle(color: Colors.white)),
                      Text(order.customer_phone, style: const TextStyle(color: AppColors.gray2, fontSize: 13)),
                      Text(order.customer_email, style: const TextStyle(color: AppColors.gray2, fontSize: 13)),
                      const SizedBox(height: 8),
                      Text(order.shipping_address, style: const TextStyle(color: AppColors.gray2, fontSize: 13)),
                      if (order.governorate != null)
                        Text(order.governorate!.name, style: const TextStyle(color: AppColors.gray2, fontSize: 13)),
                      const SizedBox(height: 8),
                      Text('Payment: ${order.payment_method} (${order.payment_status})',
                          style: const TextStyle(color: AppColors.gray2, fontSize: 13)),
                      if (order.tracking_number.isNotEmpty)
                        Text('Tracking: ${order.tracking_number}',
                            style: const TextStyle(color: AppColors.gray2, fontSize: 13)),
                    ],
                  ),
                ),
                if (isOrderCancellable(order.status)) ...[
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.red,
                        side: const BorderSide(color: AppColors.red),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: AppRadii.radiusLg),
                      ),
                      onPressed: () => _confirmCancel(context, ref, order.id),
                      child: const Text('Cancel Order', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _row(String label, num value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: bold ? Colors.white : AppColors.gray2, fontWeight: bold ? FontWeight.w700 : FontWeight.w400)),
          Text('${value.toStringAsFixed(0)} EGP',
              style: TextStyle(
                color: bold ? AppColors.primary : Colors.white,
                fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
              )),
        ],
      ),
    );
  }

  void _confirmCancel(BuildContext context, WidgetRef ref, int orderId) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.gray3,
        title: const Text('Cancel Order', style: TextStyle(color: Colors.white)),
        content: const Text(
          "You won't be able to restore the order once it has been cancelled.",
          style: TextStyle(color: AppColors.gray2),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Keep Order')),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await ref.read(ordersRepositoryProvider).cancelOrder(orderId);
                ref.invalidate(orderDetailProvider(orderId));
                ref.invalidate(ordersListProvider);
              } catch (e) {
                if (context.mounted) {
                  final message = e is ApiException ? e.message : 'Could not cancel the order.';
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                }
              }
            },
            child: const Text('Cancel Order', style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.gray3, borderRadius: AppRadii.radiusXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
