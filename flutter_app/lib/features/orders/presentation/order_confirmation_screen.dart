import '../../../l10n/l10n.dart';
import '../../../core/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../auth/presentation/auth_sheet.dart';
import '../models/order.dart';
import '../providers/orders_provider.dart';
import 'order_widgets.dart';

/// Shown after a successful checkout. Mirrors
/// `frontend/app/[locale]/checkout/confirm/[orderId]/page.tsx`.
class OrderConfirmationScreen extends ConsumerWidget {
  const OrderConfirmationScreen({super.key, required this.orderId});

  final int orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailProvider(orderId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background),
      body: SafeArea(
        child: orderAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (err, _) => Center(
            child: Text(context.l10n.unexpectedError, style: TextStyle(color: AppColors.gray2)),
          ),
          data: (order) => _OrderConfirmationBody(order: order),
        ),
      ),
    );
  }
}

class _OrderConfirmationBody extends StatelessWidget {
  const _OrderConfirmationBody({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final basra = order.type == 'basra';
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Center(
          child: Container(
            width: 96,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.check_circle, color: Colors.white, size: 36),
          ),
        ),
        const SizedBox(height: 16),
        Text(context.l10n.orderConfirmedSuccessfully,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        Text(context.l10n.orderConfirmationMessage,
            textAlign: TextAlign.center, style: TextStyle(color: AppColors.gray2, fontSize: 15)),
        const SizedBox(height: 24),
        if (order.is_guest) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.gray3,
              borderRadius: BorderRadius.circular(12),
              border: const BorderDirectional(start: BorderSide(color: AppColors.primary, width: 4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${context.l10n.orderReference}: ${order.reference}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(context.l10n.createAccountToTrack, style: TextStyle(color: AppColors.gray2, fontSize: 13)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => showAuthSheet(context),
                  child: Text(context.l10n.createAccountCta,
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
        OrderSummaryCard(order: order),
        const SizedBox(height: 16),
        OrderInfoCard(
          icon: basra ? Icons.storefront_outlined : Icons.local_shipping_outlined,
          title: basra ? context.l10n.branchPickup : context.l10n.estimatedDeliveryDate,
          lines: basra
              ? [order.branch?.name ?? '', order.branch?.address ?? '', order.branch?.phone ?? '']
              : ['3 ${context.l10n.businessDays}'],
          badge: basra ? context.l10n.readyForPickup : statusLabel(order.status),
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
        const SizedBox(height: 16),
        const NeedHelpCard(),
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
            child: Text(context.l10n.backToHome, style: TextStyle(fontWeight: FontWeight.w800)),
          ),
        ),
      ],
    );
  }
}
