import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/format.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/widgets.dart';
import '../../auth/presentation/auth_sheet.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/order.dart';
import '../providers/orders_provider.dart';

/// Shown after a successful checkout. Mirrors
/// `frontend/app/[locale]/checkout/confirm/[orderId]/page.tsx`.
class OrderConfirmationScreen extends ConsumerWidget {
  const OrderConfirmationScreen({super.key, required this.orderId});

  final int orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailProvider(orderId));
    final order = orderAsync.value;
    final isLogged = ref.watch(isLoggedInProvider);

    void goTo(String path) {
      final router = GoRouter.of(context);
      Navigator.of(context).popUntil((route) => route.isFirst);
      router.go(path);
    }

    return AppScaffold(
      title: context.l10n.orderConfirmedSuccessfully,
      bottomBar: order == null
          ? null
          : StickyBottomBar(
              action: PrimaryButton(
                label: isLogged
                    ? context.l10n.viewOrder
                    : context.l10n.trackOrder,
                onPressed: () => goTo(
                  isLogged
                      ? '/profile/orders/${order.id}'
                      : '/track-order?reference=${Uri.encodeQueryComponent(order.reference)}&phone=${Uri.encodeQueryComponent(order.customer_phone)}&type=order',
                ),
              ),
            ),
      body: orderAsync.when(
        loading: () => const SkeletonList(itemCount: 3, itemHeight: 120),
        error: (err, _) => ErrorState(
          message: context.l10n.unexpectedError,
          onRetry: () => ref.invalidate(orderDetailProvider(orderId)),
        ),
        data: (order) =>
            _OrderConfirmationBody(order: order, onHome: () => goTo('/')),
      ),
    );
  }
}

class _OrderConfirmationBody extends StatelessWidget {
  const _OrderConfirmationBody({required this.order, required this.onHome});

  final Order order;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final basra = order.type == 'basra';
    final (fg, _) = statusBadgeColors(
      StatusBadgeKind.orderDetail,
      order.status,
    );
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.gutter),
      children: [
        const SizedBox(height: AppSpacing.md),
        const Center(child: SuccessCheck()),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l.orderConfirmedSuccessfully,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.foregroundLight,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l.orderConfirmationMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: AppColors.gray2),
        ),
        const SizedBox(height: AppSpacing.xl),
        CopyReference(label: l.orderReference, reference: order.reference),
        if (order.is_guest) ...[
          const SizedBox(height: AppSpacing.md),
          AppCard(
            onTap: () => showAuthSheet(context),
            child: Row(
              children: [
                const Icon(
                  Icons.person_add_alt_1_outlined,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.createAccountToTrack,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.gray2,
                        ),
                      ),
                      Text(
                        l.createAccountCta,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l.orderSummary,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.foregroundLight,
                      ),
                    ),
                  ),
                  StatusPill(label: statusLabel(order.status), color: fg),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              for (final item in order.items)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          '${item.quantity} x ${item.product_name}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.foregroundLight,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        formatIqd(item.total),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.foregroundLight,
                        ),
                      ),
                    ],
                  ),
                ),
              const Divider(color: AppColors.gray),
              PriceSummary(
                subtotal: order.subtotal,
                discount: order.discount,
                shippingFee: order.shipping_fee,
                total: order.total,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          child: Column(
            children: [
              if (basra) ...[
                InfoLine(
                  icon: Icons.storefront_outlined,
                  label: l.branchPickup,
                  value: [
                    order.branch?.name ?? '',
                    order.branch?.address ?? '',
                    order.branch?.phone ?? '',
                  ].where((e) => e.isNotEmpty).join('\n'),
                ),
              ] else ...[
                InfoLine(
                  icon: Icons.local_shipping_outlined,
                  label: l.estimatedDeliveryDate,
                  value: '3 ${l.businessDays}',
                ),
                InfoLine(
                  icon: Icons.place_outlined,
                  label: l.deliveryAddress,
                  value: [
                    order.shipping_address ?? '',
                    order.customer_phone,
                  ].where((e) => e.isNotEmpty).join('\n'),
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
        const SizedBox(height: AppSpacing.md),
        SecondaryButton(label: l.backToHome, onPressed: onHome),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
