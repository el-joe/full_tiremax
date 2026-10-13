import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/format.dart';
import '../../l10n/l10n.dart';
import 'app_layout.dart';

/// Label/value row for light summaries.
class SummaryRow extends StatelessWidget {
  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.color,
    this.bold = false,
  });

  final String label;
  final String value;
  final Color? color;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: bold ? 16 : 14,
      fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
      color: color ?? AppColors.foregroundLight,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: style.copyWith(
                color: bold ? style.color : AppColors.gray2,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Flexible(
            child: Text(value, textAlign: TextAlign.end, style: style),
          ),
        ],
      ),
    );
  }
}

/// Light subtotal / discount / shipping / total block.
class PriceSummary extends StatelessWidget {
  const PriceSummary({
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

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final pct = discountPercent != null && discountPercent! > 0
        ? ' (${formatNumber(double.parse(discountPercent!.toStringAsFixed(2)))}%)'
        : '';
    return Column(
      children: [
        SummaryRow(label: l.subtotal, value: formatIqd(subtotal)),
        if (discount > 0)
          SummaryRow(
            label: '${l.discount}$pct',
            value: '-${formatIqd(discount)}',
            color: AppColors.green,
          ),
        if (shippingFee > 0)
          SummaryRow(label: l.shippingFee, value: formatIqd(shippingFee)),
        const Divider(height: 16, color: AppColors.gray),
        SummaryRow(label: l.grandTotal, value: formatIqd(total), bold: true),
      ],
    );
  }
}

/// Animated success check used on confirmation screens.
class SuccessCheck extends StatelessWidget {
  const SuccessCheck({super.key, this.size = 88});

  final double size;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.elasticOut,
      builder: (context, t, child) =>
          Transform.scale(scale: t.clamp(0.0, 1.2), child: child),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.green,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.green.withValues(alpha: 0.3),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(Icons.check, color: Colors.white, size: size * 0.55),
      ),
    );
  }
}

/// Reference number pill with a copy-to-clipboard button.
class CopyReference extends StatelessWidget {
  const CopyReference({
    super.key,
    required this.label,
    required this.reference,
  });

  final String label;
  final String reference;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: AppColors.gray2),
                ),
                Text(
                  reference,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.foregroundLight,
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            style: TextButton.styleFrom(
              minimumSize: const Size(AppSpacing.minTap, AppSpacing.minTap),
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: reference));
              HapticFeedback.selectionClick();
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text(context.l10n.referenceCopied)),
                );
            },
            icon: const Icon(Icons.copy_rounded, size: 18),
            label: Text(context.l10n.copyReference),
          ),
        ],
      ),
    );
  }
}

/// Icon + label + value line for detail cards.
class InfoLine extends StatelessWidget {
  const InfoLine({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: AppColors.gray2),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.foregroundLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Selectable card with a radio indicator (address / payment / branch / service options).
class SelectableCard extends StatelessWidget {
  const SelectableCard({
    super.key,
    required this.selected,
    required this.onTap,
    required this.child,
  });

  final bool selected;
  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? AppColors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? AppColors.primary : AppColors.gray2,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
