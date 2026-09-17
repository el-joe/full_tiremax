import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../models/customer_fav.dart';

/// Handles `GET /favorites` and `POST /favorites/{product}/toggle`, mirroring
/// `frontend/hooks/useFav.ts`.
class FavoritesRepository {
  FavoritesRepository(this._dio);

  final Dio _dio;

  Future<List<CustomerFav>> fetchFavorites() async {
    final response = await _dio.get('favorites');
    final body = response.data as Map<String, dynamic>;
    final data = body['data'] as List<dynamic>;
    return data
        .map((e) => CustomerFav.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> toggle(int productId) async {
    await _dio.post('favorites/$productId/toggle');
  }
}

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepository(ref.watch(apiClientProvider));
});
