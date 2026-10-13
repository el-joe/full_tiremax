import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'app_layout.dart';

/// Light-surface colour for a raw order/booking status (pill text + tint).
Color statusColor(String status) {
  switch (status) {
    case 'pending':
      return const Color(0xFFB45309);
    case 'delivered':
    case 'complete':
    case 'completed':
    case 'paid':
      return AppColors.green;
    case 'cancelled':
    case 'canceled':
    case 'failed':
      return AppColors.error;
    default:
      return AppColors.blue;
  }
}

/// Vertical, timeline-like progress list. [steps] are labels in order;
/// [current] is the index of the active step (-1 = none reached, and
/// [cancelled] paints the whole timeline red/inactive).
class StatusTimeline extends StatelessWidget {
  const StatusTimeline({
    super.key,
    required this.steps,
    required this.current,
    this.cancelled = false,
  });

  final List<String> steps;
  final int current;
  final bool cancelled;

  @override
  Widget build(BuildContext context) {
    final active = cancelled ? AppColors.error : AppColors.primary;
    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 28,
                  child: Column(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i <= current ? active : Colors.white,
                          border: Border.all(
                            color: i <= current ? active : AppColors.gray,
                            width: 2,
                          ),
                        ),
                        child: i <= current && !cancelled
                            ? const Icon(
                                Icons.check,
                                size: 12,
                                color: AppColors.chrome,
                              )
                            : null,
                      ),
                      if (i < steps.length - 1)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: i < current ? active : AppColors.gray,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: Text(
                      steps[i],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: i == current
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: i <= current
                            ? AppColors.foregroundLight
                            : AppColors.gray2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Single grouped-list row (icon, label, optional trailing, chevron).
class GroupTile extends StatelessWidget {
  const GroupTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.trailing,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = destructive ? AppColors.error : AppColors.foregroundLight;
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 52),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: destructive ? AppColors.error : AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
              ?trailing,
              if (onTap != null && trailing == null)
                Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? Icons.chevron_left
                      : Icons.chevron_right,
                  size: 20,
                  color: AppColors.gray2,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// White rounded card holding [GroupTile]s separated by hairlines.
class TileGroup extends StatelessWidget {
  const TileGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0)
                const Divider(height: 1, indent: 52, color: AppColors.gray),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}

/// Light confirm dialog; resolves true when the user confirms.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  required String cancelLabel,
  bool destructive = true,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.foregroundLight,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      content: Text(message, style: const TextStyle(color: AppColors.gray2)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text(
            cancelLabel,
            style: const TextStyle(color: AppColors.gray2),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: Text(
            confirmLabel,
            style: TextStyle(
              color: destructive ? AppColors.error : AppColors.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// Compact previous / "page x of y" / next pager.
class PagerBar extends StatelessWidget {
  const PagerBar({
    super.key,
    required this.current,
    required this.last,
    required this.onPage,
  });

  final int current;
  final int last;
  final ValueChanged<int> onPage;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          constraints: const BoxConstraints(
            minWidth: AppSpacing.minTap,
            minHeight: AppSpacing.minTap,
          ),
          onPressed: current > 1 ? () => onPage(current - 1) : null,
          icon: Icon(rtl ? Icons.chevron_right : Icons.chevron_left),
        ),
        Text(
          '$current / $last',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.foregroundLight,
          ),
        ),
        IconButton(
          constraints: const BoxConstraints(
            minWidth: AppSpacing.minTap,
            minHeight: AppSpacing.minTap,
          ),
          onPressed: current < last ? () => onPage(current + 1) : null,
          icon: Icon(rtl ? Icons.chevron_left : Icons.chevron_right),
        ),
      ],
    );
  }
}
