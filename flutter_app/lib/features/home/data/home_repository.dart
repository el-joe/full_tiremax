import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../models/home_res.dart';

class HomeRepository {
  HomeRepository(this._dio);

  final Dio _dio;

  Future<HomeRes> fetchHome() async {
    final response = await _dio.get('home');
    final body = response.data as Map<String, dynamic>;
    return HomeRes.fromJson(body['data'] as Map<String, dynamic>);
  }
}

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(ref.watch(apiClientProvider));
});
