import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../models/order.dart';

/// A page of results plus `meta.pagination` (shared by orders and bookings).
class PagedResult<T> {
  PagedResult(this.items, Map<String, dynamic>? meta)
    : total =
          ((meta?['pagination'] as Map<String, dynamic>?)?['total'] as num?)
              ?.toInt() ??
          items.length,
      currentPage =
          ((meta?['pagination'] as Map<String, dynamic>?)?['current_page']
                  as num?)
              ?.toInt() ??
          1,
      lastPage =
          ((meta?['pagination'] as Map<String, dynamic>?)?['last_page'] as num?)
              ?.toInt() ??
          1;

  final List<T> items;
  final int total;
  final int currentPage;
  final int lastPage;
}

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

  /// Guest lookup by reference + phone (web `TrackForm`: `orders/{ref}?phone=`).
  /// Throws a [DioException] with status 404 when nothing matches.
  Future<Order> trackOrder(String reference, String phone) async {
    final response = await _dio.get(
      'orders/${Uri.encodeComponent(reference.trim())}',
      queryParameters: {'phone': phone.trim()},
    );
    final body = response.data as Map<String, dynamic>;
    return Order.fromJson(body['data'] as Map<String, dynamic>);
  }

  Future<List<Order>> fetchOrders() async => (await fetchOrdersPage()).items;

  /// Web `orders?status=&page=` (status tabs + `meta.pagination`).
  Future<PagedResult<Order>> fetchOrdersPage({
    int page = 1,
    String? status,
  }) async {
    final response = await _dio.get(
      'orders',
      queryParameters: {
        if (page > 1) 'page': page,
        if (status != null && status.isNotEmpty) 'status': status,
      },
    );
    final body = response.data as Map<String, dynamic>;
    final data = body['data'] as List<dynamic>;
    return PagedResult(
      data.map((e) => Order.fromJson(e as Map<String, dynamic>)).toList(),
      body['meta'] as Map<String, dynamic>?,
    );
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
bool isOrderCancellable(String status) =>
    status == 'pending' || status == 'confirmed';

final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  return OrdersRepository(ref.watch(apiClientProvider));
});
