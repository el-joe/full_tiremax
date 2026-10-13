import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/format.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/widgets/widgets.dart';
import '../models/order.dart';
import '../providers/orders_provider.dart';

/// GET /orders list with status chips + pagination. Mirrors
/// `frontend/app/[locale]/profile/orders/**` (OrdersHeader/OrdersList).
class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  String? _status;
  int _page = 1;

  List<(String?, String)> _tabs(BuildContext context) => <(String?, String)>[
    (null, context.l10n.all),
    ('processing', context.l10n.processing),
    ('on_the_way', context.l10n.onTheWay),
    ('delivered', context.l10n.delivered),
    ('cancelled', context.l10n.cancelled),
  ];

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final key = (status: _status, page: _page);
    final ordersAsync = ref.watch(ordersListProvider(key));

    return AppScaffold(
      title: l.myOrders,
      body: Column(
        children: [
          const SizedBox(height: AppSpacing.sm),
          ChipRow(
            children: [
              for (final t in _tabs(context))
                AppChip(
                  label: t.$2,
                  selected: _status == t.$1,
                  onTap: () => setState(() {
                    _status = t.$1;
                    _page = 1;
                  }),
                ),
            ],
          ),
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                ref.invalidate(ordersListProvider(key));
                await ref.read(ordersListProvider(key).future);
              },
              child: ordersAsync.when(
                loading: () => const SkeletonList(itemHeight: 112),
                error: (error, _) => ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: 360,
                      child: ErrorState(
                        message: l.unexpectedError,
                        onRetry: () => ref.invalidate(ordersListProvider(key)),
                      ),
                    ),
                  ],
                ),
                data: (page) {
                  if (page.items.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: 360,
                          child: EmptyState(
                            icon: Icons.receipt_long_outlined,
                            title: l.noOrdersYet,
                            actionLabel: l.goToShopping,
                            onAction: () => context.go('/store'),
                          ),
                        ),
                      ],
                    );
                  }
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(AppSpacing.gutter),
                    children: [
                      for (final o in page.items) ...[
                        _OrderCard(order: o),
                        const SizedBox(height: AppSpacing.md),
                      ],
                      if (page.lastPage > 1)
                        PagerBar(
                          current: page.currentPage,
                          last: page.lastPage,
                          onPage: (p) => setState(() => _page = p),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final first = order.items.isEmpty ? null : order.items.first;
    final date = DateTime.tryParse(order.placed_at)?.toLocal();
    return AppCard(
      onTap: () => context.push('/profile/orders/${order.id}'),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: AppNetworkImage(
              url: first?.image,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${l.orderNumber} ${order.reference}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
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
                if (first != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      order.items.length > 1
                          ? '${first.product_name} +${order.items.length - 1}'
                          : '${first.product_name} x ${first.quantity}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.gray2,
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        date == null
                            ? order.placed_at
                            : formatDateLocalized('EEE MMM dd yyyy', date),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.gray2,
                        ),
                      ),
                    ),
                    Text(
                      formatIqd(order.total),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.foregroundLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
