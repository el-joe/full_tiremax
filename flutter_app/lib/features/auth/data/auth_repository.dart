import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/storage/token_storage.dart';
import '../../profile/models/customer_profile.dart';

/// Result of a successful login/register call.
class AuthResult {
  AuthResult({
    required this.customer,
    required this.accessToken,
    required this.expiresIn,
    this.linkedOrders = 0,
    this.linkedBookings = 0,
  });

  final CustomerProfile customer;
  final String accessToken;
  final int? expiresIn;
  final int linkedOrders;
  final int linkedBookings;

  bool get hasLinked => linkedOrders > 0 || linkedBookings > 0;
}

/// Mirrors `frontend/hooks/useAuth.ts`'s mutation functions.
class AuthRepository {
  AuthRepository(this._dio, this._tokenStorage);

  final Dio _dio;
  final TokenStorage _tokenStorage;

  Future<AuthResult> login({
    required String login,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'auth/login',
        data: {'login': login, 'password': password},
      );
      return await _handleAuthResponse(response);
    } on DioException catch (e) {
      throw e.error is ApiException ? e.error as ApiException : ApiException.fromDioException(e);
    }
  }

  Future<AuthResult> register({
    required String name,
    required String phone,
    String? email,
    required String password,
    required String passwordConfirmation,
    String? address,
    String? locale,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'auth/register',
        data: {
          'name': name,
          'phone': phone,
          if (email != null && email.isNotEmpty) 'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          if (address != null && address.isNotEmpty) 'address': address,
          'locale': ?locale,
        },
      );
      return await _handleAuthResponse(response);
    } on DioException catch (e) {
      throw e.error is ApiException ? e.error as ApiException : ApiException.fromDioException(e);
    }
  }

  Future<CustomerProfile> updateMe({
    String? name,
    String? email,
    String? password,
    String? passwordConfirmation,
    String? locale,
  }) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        'auth/me',
        data: {
          'name': ?name,
          'email': ?email,
          'password': ?password,
          'password_confirmation': ?passwordConfirmation,
          'locale': ?locale,
        },
      );
      final data = response.data?['data'] as Map<String, dynamic>;
      final customer = CustomerProfile.fromJson(data);
      await _tokenStorage.saveCustomerInfo(customer.toJson());
      return customer;
    } on DioException catch (e) {
      throw e.error is ApiException ? e.error as ApiException : ApiException.fromDioException(e);
    }
  }

  Future<AuthResult> _handleAuthResponse(
    Response<Map<String, dynamic>> response,
  ) async {
    final data = response.data?['data'] as Map<String, dynamic>;
    final customer =
        CustomerProfile.fromJson(data['customer'] as Map<String, dynamic>);
    final accessToken = data['access_token'] as String;
    final expiresIn = data['expires_in'] as int?;
    final meta = response.data?['meta'];
    int metaInt(String key) {
      final v = meta is Map ? meta[key] : null;
      return v is num ? v.toInt() : int.tryParse('$v') ?? 0;
    }

    await _tokenStorage.saveToken(accessToken);
    await _tokenStorage.saveCustomerInfo(customer.toJson());
    // Guest data is now linked to the account; start fresh as a guest later.
    await _tokenStorage.clearGuestToken();

    return AuthResult(
      customer: customer,
      accessToken: accessToken,
      expiresIn: expiresIn,
      linkedOrders: metaInt('linked_orders'),
      linkedBookings: metaInt('linked_bookings'),
    );
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(apiClientProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);
  return AuthRepository(dio, tokenStorage);
});
