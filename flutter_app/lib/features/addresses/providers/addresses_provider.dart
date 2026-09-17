import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/addresses_repository.dart';
import '../models/address.dart';

class AddressesNotifier extends AsyncNotifier<List<Address>> {
  @override
  Future<List<Address>> build() async {
    return ref.read(addressesRepositoryProvider).fetchAddresses();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(addressesRepositoryProvider).fetchAddresses());
  }

  Future<void> setDefault(int id) async {
    final repository = ref.read(addressesRepositoryProvider);
    await repository.setDefault(id);
    await refresh();
  }

  Future<void> delete(int id) async {
    final repository = ref.read(addressesRepositoryProvider);
    await repository.deleteAddress(id);
    await refresh();
  }
}

final addressesProvider = AsyncNotifierProvider<AddressesNotifier, List<Address>>(
  AddressesNotifier.new,
);
