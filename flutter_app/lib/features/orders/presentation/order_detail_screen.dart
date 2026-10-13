import '../../../l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../data/orders_repository.dart';
import '../providers/orders_provider.dart';
import 'order_widgets.dart';

/// GET /orders/{id}. Mirrors `frontend/app/[locale]/profile/orders/[orderId]/page.tsx`;
/// cancel (POST /orders/{id}/cancel) only while pending/confirmed.
class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final int orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailProvider(orderId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, title: Text(context.l10n.orderDetails)),
      body: SafeArea(
        child: orderAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (error, _) => Center(
            child: Text(context.l10n.unexpectedError, style: TextStyle(color: AppColors.gray2)),
          ),
          data: (order) {
            final basra = order.type == 'basra';
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(context.l10n.orderDetails,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Text(context.l10n.orderDetailsDescription,
                    textAlign: TextAlign.center, style: TextStyle(color: AppColors.gray2, fontSize: 15)),
                const SizedBox(height: 24),
                OrderSummaryCard(order: order),
                const SizedBox(height: 16),
                OrderInfoCard(
                  icon: basra ? Icons.storefront_outlined : Icons.local_shipping_outlined,
                  title: basra ? context.l10n.branchPickup : context.l10n.deliveryStatus,
                  lines: basra
                      ? [
                          order.branch?.name ?? '',
                          order.branch?.address ?? '',
                          order.branch?.phone ?? '',
                          context.l10n.readyForPickup,
                        ]
                      : [order.status, if ((order.tracking_number ?? '').isNotEmpty) order.tracking_number!],
                ),
                const SizedBox(height: 16),
                OrderInfoCard(
                  icon: Icons.account_balance_outlined,
                  title: context.l10n.paymentMethod,
                  lines: [order.payment_method],
                ),
                if (!basra) ...[
                  const SizedBox(height: 16),
                  OrderInfoCard(
                    icon: Icons.place_outlined,
                    title: context.l10n.deliveryAddress,
                    lines: [order.shipping_address ?? '', order.customer_phone],
                  ),
                ],
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
                      child: Text(context.l10n.cancelOrder, style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                const NeedHelpCard(),
              ],
            );
          },
        ),
      ),
    );
  }

  void _confirmCancel(BuildContext context, WidgetRef ref, int orderId) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.gray3,
        title: Text(context.l10n.cancelOrder, style: TextStyle(color: Colors.white)),
        content: Text(
          context.l10n.cancelOrderWarning,
          style: TextStyle(color: AppColors.gray2),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(context.l10n.keepOrder)),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await ref.read(ordersRepositoryProvider).cancelOrder(orderId);
                ref.invalidate(orderDetailProvider(orderId));
                ref.invalidate(ordersListProvider);
              } catch (e) {
                if (context.mounted) {
                  final message = e is ApiException ? e.message : context.l10n.couldNotCancelOrder;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                }
              }
            },
            child: Text(context.l10n.cancelOrder, style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );
  }
}
