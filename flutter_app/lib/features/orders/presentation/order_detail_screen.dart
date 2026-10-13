import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/format.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/orders_repository.dart';
import '../models/order.dart';
import '../providers/orders_provider.dart';

/// GET /orders/{id}. Mirrors `frontend/app/[locale]/profile/orders/[orderId]/page.tsx`;
/// cancel (POST /orders/{id}/cancel) only while pending/confirmed.
class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final int orderId;

  static const _flow = ['pending', 'processing', 'on_the_way', 'delivered'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final orderAsync = ref.watch(orderDetailProvider(orderId));

    return AppScaffold(
      title: l.orderDetails,
      body: orderAsync.when(
        loading: () => const SkeletonList(itemCount: 3, itemHeight: 140),
        error: (error, _) => ErrorState(
          message: l.unexpectedError,
          onRetry: () => ref.invalidate(orderDetailProvider(orderId)),
        ),
        data: (order) {
          final basra = order.type == 'basra';
          final cancelled =
              order.status == 'cancelled' || order.status == 'canceled';
          final steps = basra ? ['pending', 'processing', 'delivered'] : _flow;
          final idx = steps.indexOf(
            order.status == 'confirmed' ? 'processing' : order.status,
          );
          final labels = [
            for (final s in steps)
              s == 'pending'
                  ? l.orderStepPlaced
                  : (basra && s == 'delivered'
                        ? l.readyForPickup
                        : statusLabel(s)),
          ];
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              ref.invalidate(orderDetailProvider(orderId));
              await ref.read(orderDetailProvider(orderId).future);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.gutter),
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${l.orderNumber} ${order.reference}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.foregroundLight,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          StatusPill(
                            label: statusLabel(order.status),
                            color: statusColor(order.status),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      StatusTimeline(
                        steps: labels,
                        current: cancelled ? 0 : idx,
                        cancelled: cancelled,
                      ),
                      if ((order.tracking_number ?? '').isNotEmpty)
                        InfoLine(
                          icon: Icons.local_shipping_outlined,
                          label: l.deliveryStatus,
                          value: order.tracking_number!,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l.orderSummary,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.foregroundLight,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      for (final item in order.items) _ItemRow(item: item),
                      const Divider(color: AppColors.gray),
                      PriceSummary(
                        subtotal: order.subtotal,
                        discount: order.discount,
                        discountPercent: order.subtotal > 0
                            ? order.discount / order.subtotal * 100
                            : null,
                        shippingFee:
                            order.shipping_fee + order.installation_fee,
                        total: order.total,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (basra) ...[
                        InfoLine(
                          icon: Icons.storefront_outlined,
                          label: l.branchPickup,
                          value: order.branch?.name ?? '',
                        ),
                        if ((order.branch?.address ?? '').isNotEmpty)
                          InfoLine(
                            icon: Icons.place_outlined,
                            label: l.address,
                            value: order.branch!.address,
                          ),
                        if ((order.branch?.phone ?? '').isNotEmpty)
                          InfoLine(
                            icon: Icons.phone_outlined,
                            label: l.phoneLabel,
                            value: order.branch!.phone,
                          ),
                      ] else ...[
                        InfoLine(
                          icon: Icons.place_outlined,
                          label: l.deliveryAddress,
                          value: order.shipping_address ?? '',
                        ),
                        InfoLine(
                          icon: Icons.phone_outlined,
                          label: l.phoneLabel,
                          value: order.customer_phone,
                        ),
                      ],
                      InfoLine(
                        icon: Icons.payments_outlined,
                        label: l.paymentMethod,
                        value: order.payment_method,
                      ),
                    ],
                  ),
                ),
                if (isOrderCancellable(order.status)) ...[
                  const SizedBox(height: AppSpacing.xl),
                  SecondaryButton(
                    label: l.cancelOrder,
                    icon: Icons.close,
                    onPressed: () => _confirmCancel(context, ref, order.id),
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                TextButton.icon(
                  onPressed: () => context.push('/contact'),
                  icon: const Icon(
                    Icons.support_agent_outlined,
                    color: AppColors.gray2,
                  ),
                  label: Text(
                    l.needHelp,
                    style: const TextStyle(
                      color: AppColors.gray2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmCancel(
    BuildContext context,
    WidgetRef ref,
    int orderId,
  ) async {
    final l = context.l10n;
    final ok = await showConfirmDialog(
      context,
      title: l.cancelOrder,
      message: l.cancelOrderWarning,
      confirmLabel: l.cancelOrder,
      cancelLabel: l.keepOrder,
    );
    if (!ok) return;
    try {
      await ref.read(ordersRepositoryProvider).cancelOrder(orderId);
      ref.invalidate(orderDetailProvider(orderId));
      ref.invalidate(ordersListProvider);
    } catch (e) {
      if (context.mounted) {
        final message = e is ApiException
            ? e.message
            : context.l10n.couldNotCancelOrder;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});

  final OrderItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: () => context.push('/product/${item.product_id}'),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 56,
              height: 56,
              child: AppNetworkImage(
                url: item.image,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product_name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.foregroundLight,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item.quantity} × ${formatNumber(item.unit_price)} = ${formatIqd(item.total)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.gray2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
