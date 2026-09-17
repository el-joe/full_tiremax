import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/paginated_response.dart';
import '../models/product.dart';
import '../models/review.dart';

class ProductRepository {
  ProductRepository(this._dio);

  final Dio _dio;

  Future<Product> fetchProduct(int id) async {
    final response = await _dio.get('products/$id');
    final body = response.data as Map<String, dynamic>;
    return Product.fromJson(body['data'] as Map<String, dynamic>);
  }

  Future<List<Product>> fetchRelated(int id) async {
    final response = await _dio.get('products/$id/related');
    final data = (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
    return data.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<(List<Review>, ProductReviewMeta)> fetchReviews(int id, {int page = 1}) async {
    final response = await _dio.get('reviews/$id', queryParameters: {'page': page});
    final body = response.data as Map<String, dynamic>;
    final data = body['data'] as List<dynamic>;
    final reviews = data.map((e) => Review.fromJson(e as Map<String, dynamic>)).toList();
    return (reviews, ProductReviewMeta.fromJson(body));
  }

  Future<void> submitReview(int id, {required num rating, required String comment}) async {
    await _dio.post('reviews/$id', data: {'rating': rating, 'comment': comment});
  }

  Future<void> addToCart({required int productId, required int quantity}) async {
    await _dio.post('cart/items', data: {'product_id': productId, 'quantity': quantity});
  }
}

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(ref.watch(apiClientProvider));
});

final productDetailProvider = FutureProvider.family<Product, int>((ref, id) {
  return ref.watch(productRepositoryProvider).fetchProduct(id);
});

final relatedProductsProvider = FutureProvider.family<List<Product>, int>((ref, id) {
  return ref.watch(productRepositoryProvider).fetchRelated(id);
});

class ReviewsState {
  const ReviewsState({required this.reviews, required this.ratingAvg, required this.ratingCount});

  final List<Review> reviews;
  final double ratingAvg;
  final int ratingCount;
}

final productReviewsProvider = FutureProvider.family<ReviewsState, int>((ref, id) async {
  final repository = ref.watch(productRepositoryProvider);
  final (reviews, meta) = await repository.fetchReviews(id);
  return ReviewsState(reviews: reviews, ratingAvg: meta.ratingAvg, ratingCount: meta.ratingCount);
});
