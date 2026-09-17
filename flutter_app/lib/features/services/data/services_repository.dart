import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../models/service.dart';

class ServicesRepository {
  ServicesRepository(this._dio);

  final Dio _dio;

  Future<List<Service>> fetchServices() async {
    final response = await _dio.get('services');
    final data = (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
    return data.map((e) => Service.fromJson(e as Map<String, dynamic>)).toList();
  }
}

final servicesRepositoryProvider = Provider<ServicesRepository>((ref) {
  return ServicesRepository(ref.watch(apiClientProvider));
});

final servicesProvider = FutureProvider<List<Service>>((ref) {
  return ref.watch(servicesRepositoryProvider).fetchServices();
});
