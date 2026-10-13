import '../../../l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/utils/format.dart';
import '../../../shared/widgets/shimmer_box.dart';
import '../../../shared/widgets/status_badge.dart';
import '../models/order.dart';

/// Web `PriceBreakdown`: subtotal / discount / shipping / grand total.
class PriceBreakdown extends StatelessWidget {
  const PriceBreakdown({
    super.key,
    required this.subtotal,
    this.discount = 0,
    this.discountPercent,
    this.shippingFee = 0,
    required this.total,
  });

  final num subtotal;
  final num discount;
  final num? discountPercent;
  final num shippingFee;
  final num total;

  Widget _row(String label, String value, {Color? color}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
            Text(value, style: TextStyle(color: color ?? Colors.white, fontWeight: FontWeight.w700)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _row(context.l10n.subtotal, formatIqd(subtotal)),
        if (discount > 0)
          _row(
            '${context.l10n.discount}${discountPercent != null && discountPercent! > 0 ? ' (${formatNumber(double.parse(discountPercent!.toStringAsFixed(2)))}%)' : ''}',
            '-${formatIqd(discount)}',
            color: Colors.red,
          ),
        if (shippingFee > 0) _row(context.l10n.shippingFee, formatIqd(shippingFee)),
        const Divider(color: Color(0x33FFFFFF), height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.l10n.grandTotal,
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
            Text(formatIqd(total),
                style: const TextStyle(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.w700)),
          ],
        ),
      ],
    );
  }
}

/// Web order `OrderSummary`: status badge, item lines (`qty × unit = total`)
/// and the price breakdown.
class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.gray3,
        borderRadius: AppRadii.radiusXl,
        border: const Border(top: BorderSide(color: AppColors.primary, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(context.l10n.orderSummary,
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
              ),
              StatusBadge(status: order.status, kind: StatusBadgeKind.orderDetail),
            ],
          ),
          const SizedBox(height: 16),
          for (final item in order.items)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => context.push('/product/${item.product_id}'),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: SizedBox(
                        width: 62,
                        height: 62,
                        child: item.image == null
                            ? Container(color: AppColors.gray4, child: const Icon(Icons.image_outlined, color: AppColors.gray2))
                            : AppNetworkImage(url: item.image!, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.product_name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 6),
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: Text(
                              '${item.quantity} × ${formatNumber(item.unit_price)} = ${formatIqd(item.total)}',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const Divider(color: Color(0x33FFFFFF)),
          PriceBreakdown(
            subtotal: order.subtotal,
            discount: order.discount,
            discountPercent: order.subtotal > 0 ? order.discount / order.subtotal * 100 : null,
            shippingFee: order.shipping_fee + order.installation_fee,
            total: order.total,
          ),
        ],
      ),
    );
  }
}

/// Web order info row: primary icon square + title + gray lines (start border).
class OrderInfoCard extends StatelessWidget {
  const OrderInfoCard({super.key, required this.icon, required this.title, required this.lines, this.badge});

  final IconData icon;
  final String title;
  final List<String> lines;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.gray3,
        borderRadius: BorderRadius.circular(8),
        border: const BorderDirectional(start: BorderSide(color: AppColors.primary, width: 4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                for (final l in lines)
                  Text(l, style: const TextStyle(color: AppColors.gray2, fontSize: 13)),
              ],
            ),
          ),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(badge!, style: const TextStyle(color: AppColors.primary, fontSize: 12)),
            ),
        ],
      ),
    );
  }
}

/// Web `NeedHelpCard` (links to /contact).
class NeedHelpCard extends StatelessWidget {
  const NeedHelpCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.gray3, borderRadius: AppRadii.radiusXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.needHelp, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(context.l10n.supportDescription, style: TextStyle(color: AppColors.gray2, fontSize: 13)),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => context.push('/contact'),
            child: Text(context.l10n.chatWithAnExpert),
          ),
        ],
      ),
    );
  }
}
