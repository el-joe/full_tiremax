import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/branch.dart';
import '../../../core/models/governorate.dart';
import '../../../core/network/api_client.dart';
import '../../orders/models/order.dart';
import '../models/payment.dart';
import '../models/payment_method.dart';

/// Handles the checkout-time endpoints: governorates, branches, payment
/// gateways, order creation and payment lookup. Mirrors
/// `frontend/components/pages/checkout/CheckoutForm.tsx`.
///
/// Note: unlike the task brief assumed, the real checkout flow does NOT use
/// the saved `/addresses` CRUD endpoints at all — `createOrderSchemas.ts` and
/// the Postman `POST /orders` body take a freeform `shipping_address` string
/// plus `governorate_id` directly (or `branch_id` for branch pickup), with
/// no `address_id` field anywhere. So this repository intentionally has no
/// address methods; checkout collects the address inline.
class CheckoutRepository {
  CheckoutRepository(this._dio);

  final Dio _dio;

  Future<List<Governorate>> fetchGovernorates() async {
    final response = await _dio.get('governorates');
    final data = (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
    return data.map((e) => Governorate.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Branch>> fetchBranches() async {
    final response = await _dio.get('branches');
    final data = (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
    return data.map((e) => Branch.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<PaymentMethod>> fetchPaymentMethods() async {
    final response = await _dio.get('payment-gateways');
    final data = (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
    return data.map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Order> createOrder({
    required String type,
    required String paymentMethod,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    String? locale,
    String? offerCode,
    String? notes,
    int? governorateId,
    String? shippingAddress,
    int? branchId,
  }) async {
    final body = <String, dynamic>{
      'type': type,
      'payment_method': paymentMethod,
      if (customerName != null && customerName.isNotEmpty) 'customer_name': customerName,
      if (customerPhone != null && customerPhone.isNotEmpty) 'customer_phone': customerPhone,
      if (customerEmail != null && customerEmail.isNotEmpty) 'customer_email': customerEmail,
      'locale': ?locale,
      if (offerCode != null && offerCode.isNotEmpty) 'offer_code': offerCode,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
      if (type == 'basra' && branchId != null) 'branch_id': branchId,
      if (type != 'basra' && governorateId != null) 'governorate_id': governorateId,
      if (type != 'basra' && shippingAddress != null) 'shipping_address': shippingAddress,
    };
    final response = await _dio.post('orders', data: body);
    final res = response.data as Map<String, dynamic>;
    return Order.fromJson(res['data'] as Map<String, dynamic>);
  }

  /// Returns null if the order has no payment record yet (e.g. COD), mirroring
  /// the web's try/catch-and-proceed behavior.
  Future<Payment?> fetchPayment(int orderId) async {
    try {
      final response = await _dio.get('orders/$orderId/payment');
      final body = response.data as Map<String, dynamic>;
      return Payment.fromJson(body['data'] as Map<String, dynamic>);
    } on DioException {
      return null;
    }
  }
}

final checkoutRepositoryProvider = Provider<CheckoutRepository>((ref) {
  return CheckoutRepository(ref.watch(apiClientProvider));
});

final governoratesProvider = FutureProvider<List<Governorate>>((ref) {
  return ref.watch(checkoutRepositoryProvider).fetchGovernorates();
});

final checkoutBranchesProvider = FutureProvider<List<Branch>>((ref) {
  return ref.watch(checkoutRepositoryProvider).fetchBranches();
});

final paymentMethodsProvider = FutureProvider<List<PaymentMethod>>((ref) {
  return ref.watch(checkoutRepositoryProvider).fetchPaymentMethods();
});
