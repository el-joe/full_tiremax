import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/orders_repository.dart';
import '../models/order.dart';

class OrdersListNotifier extends AsyncNotifier<List<Order>> {
  @override
  Future<List<Order>> build() async {
    return ref.read(ordersRepositoryProvider).fetchOrders();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(ordersRepositoryProvider).fetchOrders());
  }
}

final ordersListProvider = AsyncNotifierProvider<OrdersListNotifier, List<Order>>(
  OrdersListNotifier.new,
);

/// A single order's detail (GET /orders/{id}), keyed by order id.
final orderDetailProvider = FutureProvider.autoDispose.family<Order, int>((ref, id) {
  return ref.watch(ordersRepositoryProvider).fetchOrder(id);
});
