import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../product/models/product.dart';
import '../models/flash_sale.dart';

class OffersRepository {
  OffersRepository(this._dio);

  final Dio _dio;

  Future<List<FlashSale>> fetchFlashSales() async {
    final response = await _dio.get('flash-sales');
    final data = (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
    return data.map((e) => FlashSale.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Product>> fetchFlashSaleProducts(int flashSaleId) async {
    final response = await _dio.get('flash-sales/$flashSaleId/products');
    final data = (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
    return data.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  }
}

final offersRepositoryProvider = Provider<OffersRepository>((ref) {
  return OffersRepository(ref.watch(apiClientProvider));
});

final flashSalesProvider = FutureProvider<List<FlashSale>>((ref) {
  return ref.watch(offersRepositoryProvider).fetchFlashSales();
});

final flashSaleProductsProvider =
    FutureProvider.family<List<Product>, int>((ref, flashSaleId) {
  return ref.watch(offersRepositoryProvider).fetchFlashSaleProducts(flashSaleId);
});
