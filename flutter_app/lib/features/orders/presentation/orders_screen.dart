import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../models/order.dart';
import '../providers/orders_provider.dart';

Color orderStatusColor(String status) {
  switch (status) {
    case 'pending':
      return AppColors.gray2;
    case 'confirmed':
    case 'processing':
    case 'shipped':
      return AppColors.blue;
    case 'delivered':
    case 'completed':
      return AppColors.green;
    case 'cancelled':
    case 'refunded':
      return AppColors.red;
    default:
      return AppColors.gray2;
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = orderStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.18), borderRadius: AppRadii.radiusFull),
      child: Text(
        status[0].toUpperCase() + status.substring(1),
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}

/// GET /orders list with status chips, tap -> detail. Mirrors
/// `frontend/app/[locale]/profile/orders/**`.
class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, title: const Text('My Orders')),
      body: SafeArea(
        child: ordersAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (error, _) => Center(child: Text('$error', style: const TextStyle(color: AppColors.gray2))),
          data: (orders) {
            if (orders.isEmpty) {
              return const Center(child: Text('No orders yet.', style: TextStyle(color: AppColors.gray2)));
            }
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => ref.read(ordersListProvider.notifier).refresh(),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) => _OrderTile(order: orders[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  const _OrderTile({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadii.radiusXl,
      onTap: () => context.push('/profile/orders/${order.id}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.gray3, borderRadius: AppRadii.radiusXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('#${order.reference}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                ),
                StatusChip(status: order.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(order.placed_at, style: const TextStyle(color: AppColors.gray2, fontSize: 12)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${order.items.length} item(s)', style: const TextStyle(color: AppColors.gray2, fontSize: 13)),
                Text('${order.total.toStringAsFixed(0)} EGP',
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
