import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/orders_repository.dart';
import '../models/order.dart';

/// Orders list keyed by (status tab, page), like web `orders?status=&page=`.
final ordersListProvider = FutureProvider.autoDispose
    .family<PagedResult<Order>, ({String? status, int page})>((ref, key) {
      return ref
          .watch(ordersRepositoryProvider)
          .fetchOrdersPage(page: key.page, status: key.status);
    });

/// A single order's detail (GET /orders/{id}), keyed by order id.
final orderDetailProvider = FutureProvider.autoDispose.family<Order, int>((
  ref,
  id,
) {
  return ref.watch(ordersRepositoryProvider).fetchOrder(id);
});
