import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../models/order.dart';

/// Handles fetching a single order, used by the confirmation screen. Mirrors
/// `frontend/app/[locale]/checkout/confirm/[orderId]/page.tsx`.
class OrdersRepository {
  OrdersRepository(this._dio);

  final Dio _dio;

  Future<Order> fetchOrder(int id) async {
    final response = await _dio.get('orders/$id');
    final body = response.data as Map<String, dynamic>;
    return Order.fromJson(body['data'] as Map<String, dynamic>);
  }

  Future<List<Order>> fetchOrders() async {
    final response = await _dio.get('orders');
    final data = (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
    return data.map((e) => Order.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Cancels an order. Only valid while `status` is `pending` or
  /// `confirmed` per `backend/app/Services/OrderService.php::cancel` — the
  /// backend throws a 400 `cannot_cancel` error otherwise (broader than the
  /// task brief's "pending/processing" assumption).
  Future<Order> cancelOrder(int id) async {
    final response = await _dio.post('orders/$id/cancel');
    final body = response.data as Map<String, dynamic>;
    return Order.fromJson(body['data'] as Map<String, dynamic>);
  }
}

/// Mirrors `OrderService::cancel`'s allowed source statuses.
bool isOrderCancellable(String status) => status == 'pending' || status == 'confirmed';

final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  return OrdersRepository(ref.watch(apiClientProvider));
});
