import '../../../l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/format.dart';
import '../../../shared/widgets/shimmer_box.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/web_pagination.dart';
import '../../../core/theme/app_radii.dart';
import '../models/order.dart';
import '../providers/orders_provider.dart';

/// GET /orders list with status tabs + pagination. Mirrors
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
    final key = (status: _status, page: _page);
    final ordersAsync = ref.watch(ordersListProvider(key));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, title: Text(context.l10n.myOrders)),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            ref.invalidate(ordersListProvider(key));
            await ref.read(ordersListProvider(key).future);
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              _header(ordersAsync.asData?.value.total ?? 0),
              const SizedBox(height: 16),
              ordersAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                ),
                error: (error, _) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: Text(context.l10n.unexpectedError, style: const TextStyle(color: AppColors.gray2))),
                ),
                data: (page) {
                  if (page.items.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(context.l10n.noOrdersYet,
                            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      for (final o in page.items) ...[_OrderTile(order: o), const SizedBox(height: 16)],
                      if (page.lastPage > 1)
                        WebPagination(
                          current: page.currentPage,
                          last: page.lastPage,
                          onPage: (p) => setState(() => _page = p),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(int count) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.gray3, borderRadius: AppRadii.radiusXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.myOrders, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text('${context.l10n.youHave} $count ${context.l10n.orderWord}',
              style: const TextStyle(color: AppColors.gray2, fontSize: 13)),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final t in _tabs(context))
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _status = t.$1;
                        _page = 1;
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                        decoration: BoxDecoration(
                          color: _status == t.$1 ? AppColors.primary : AppColors.gray4,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(t.$2,
                            style: TextStyle(
                                color: _status == t.$1 ? Colors.black : AppColors.gray2,
                                fontWeight: FontWeight.w700,
                                fontSize: 13)),
                      ),
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

class _OrderTile extends StatelessWidget {
  const _OrderTile({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final first = order.items.isEmpty ? null : order.items.first;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.gray3,
        borderRadius: AppRadii.radiusXl,
        border: Border.all(color: const Color(0xFFE5E7EB).withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 64,
              height: 64,
              child: first?.image == null
                  ? Container(color: AppColors.gray4, child: const Icon(Icons.image_outlined, color: AppColors.gray2))
                  : AppNetworkImage(url: first!.image!, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(first == null ? '' : '${first.product_name} X ${first.quantity}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                          Text('${context.l10n.orderNumber} ${order.reference}',
                              style: const TextStyle(color: AppColors.gray2, fontSize: 12)),
                        ],
                      ),
                    ),
                    StatusBadge(status: order.status, kind: StatusBadgeKind.orderList),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(_date(order.placed_at), style: const TextStyle(color: AppColors.gray2, fontSize: 12)),
                    const Spacer(),
                    Text(formatIqd(order.total),
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800)),
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () => context.push('/profile/orders/${order.id}'),
                    child: Text(context.l10n.viewDetails),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Web `new Date(x).toDateString()`.
  static String _date(String raw) {
    final d = DateTime.tryParse(raw)?.toLocal();
    return d == null ? raw : formatDateLocalized('EEE MMM dd yyyy', d);
  }
}
