import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/city.dart';
import '../../../core/models/governorate.dart';
import '../../../core/network/api_client.dart';
import '../models/address.dart';

/// Handles the saved-address-book CRUD endpoints, mirroring
/// `frontend/components/dialogs/{CreateAddressDialog,RemoveAddressDialog,
/// SetDefaultAddressDialog}.tsx`.
///
/// NOTE: this is a separate feature from checkout's freeform
/// shipping_address + governorate_id (confirmed in Step 6) — checkout does
/// not read from this address book at all.
class AddressesRepository {
  AddressesRepository(this._dio);

  final Dio _dio;

  Future<List<Address>> fetchAddresses() async {
    final response = await _dio.get('addresses');
    final data = (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
    return data.map((e) => Address.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Governorate>> fetchGovernorates() async {
    final response = await _dio.get('governorates');
    final data = (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
    return data.map((e) => Governorate.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<City>> fetchCities(int governorateId) async {
    final response = await _dio.get('governorates/$governorateId/cities');
    final data = (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
    return data.map((e) => City.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Address> createAddress({
    required String fullName,
    required String phone,
    required int governorateId,
    required int cityId,
    required String address,
  }) async {
    final response = await _dio.post('addresses', data: {
      'full_name': fullName,
      'phone': phone,
      'governorate_id': governorateId,
      'city_id': cityId,
      'address': address,
    });
    final body = response.data as Map<String, dynamic>;
    return Address.fromJson(body['data'] as Map<String, dynamic>);
  }

  Future<Address> updateAddress({
    required int id,
    required String fullName,
    required String phone,
    required int governorateId,
    required int cityId,
    required String address,
  }) async {
    final response = await _dio.put('addresses/$id', data: {
      'full_name': fullName,
      'phone': phone,
      'governorate_id': governorateId,
      'city_id': cityId,
      'address': address,
    });
    final body = response.data as Map<String, dynamic>;
    return Address.fromJson(body['data'] as Map<String, dynamic>);
  }

  Future<void> setDefault(int id) async {
    await _dio.post('addresses/$id/set-default');
  }

  Future<void> deleteAddress(int id) async {
    await _dio.delete('addresses/$id');
  }
}

final addressesRepositoryProvider = Provider<AddressesRepository>((ref) {
  return AddressesRepository(ref.watch(apiClientProvider));
});
