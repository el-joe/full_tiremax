import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../models/apply_offer_result.dart';
import '../models/customer_cart.dart';

/// Handles the `cart` endpoints. Mirrors `frontend/hooks/useCart.ts`.
class CartRepository {
  CartRepository(this._dio);

  final Dio _dio;

  Future<CustomerCart> fetchCart() async {
    final response = await _dio.get('cart');
    final body = response.data as Map<String, dynamic>;
    return CustomerCart.fromJson(body['data'] as Map<String, dynamic>);
  }

  Future<CustomerCart> addItem({required int productId, required int quantity}) async {
    final response = await _dio.post(
      'cart/items',
      data: {'product_id': productId, 'quantity': quantity},
    );
    final body = response.data as Map<String, dynamic>;
    return CustomerCart.fromJson(body['data'] as Map<String, dynamic>);
  }

  Future<CustomerCart> updateItem({required int itemId, required int quantity}) async {
    final response = await _dio.put(
      'cart/items/$itemId',
      data: {'quantity': quantity},
    );
    final body = response.data as Map<String, dynamic>;
    return CustomerCart.fromJson(body['data'] as Map<String, dynamic>);
  }

  Future<CustomerCart> removeItem(int itemId) async {
    final response = await _dio.delete('cart/items/$itemId');
    final body = response.data as Map<String, dynamic>;
    return CustomerCart.fromJson(body['data'] as Map<String, dynamic>);
  }

  Future<CustomerCart> clearCart() async {
    final response = await _dio.delete('cart');
    final body = response.data as Map<String, dynamic>;
    return CustomerCart.fromJson(body['data'] as Map<String, dynamic>);
  }

  Future<ApplyOfferResult> applyOffer(String code) async {
    final response = await _dio.post('cart/apply-offer', data: {'code': code});
    final body = response.data as Map<String, dynamic>;
    return ApplyOfferResult.fromJson(body['data'] as Map<String, dynamic>);
  }
}

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepository(ref.watch(apiClientProvider));
});
