import 'package:dio/dio.dart';
import '../../../core/utils/format.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../data/cart_repository.dart';
import '../models/apply_offer_result.dart';
import '../models/customer_cart.dart';

const _emptyCart = CustomerCart(id: 0, subtotal: 0, items_count: 0);

/// Holds the live cart state, mirroring `frontend/hooks/useCart.ts`. Loaded
/// eagerly so other screens (e.g. a future cart badge in the bottom nav)
/// could watch item count.
class CartNotifier extends AsyncNotifier<CustomerCart> {
  ApplyOfferResult? _appliedOffer;
  String? _applyOfferError;

  ApplyOfferResult? get appliedOffer => _appliedOffer;
  String? get applyOfferError => _applyOfferError;

  @override
  Future<CustomerCart> build() async {
    try {
      return await ref.read(cartRepositoryProvider).fetchCart();
    } on DioException {
      return _emptyCart;
    }
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(() => ref.read(cartRepositoryProvider).fetchCart());
  }

  /// Adds [productId] to the cart (web `useCartContext().addItem`). Returns
  /// an error message, or null on success.
  Future<String?> addProduct(int productId, int quantity) async {
    _appliedOffer = null;
    try {
      final cart = await ref.read(cartRepositoryProvider).addItem(productId: productId, quantity: quantity);
      state = AsyncData(cart);
      return null;
    } on DioException catch (e) {
      final error = e.error;
      return error is ApiException ? error.message : currentL10n.somethingWentWrongPeriod;
    }
  }

  Future<String?> updateQuantity(int itemId, int quantity) async {
    _appliedOffer = null;
    try {
      final cart = await ref.read(cartRepositoryProvider).updateItem(itemId: itemId, quantity: quantity);
      state = AsyncData(cart);
      return null;
    } on DioException catch (e) {
      final error = e.error;
      return error is ApiException ? error.message : currentL10n.somethingWentWrongPeriod;
    }
  }

  Future<String?> removeItem(int itemId) async {
    _appliedOffer = null;
    try {
      final cart = await ref.read(cartRepositoryProvider).removeItem(itemId);
      state = AsyncData(cart);
      return null;
    } on DioException catch (e) {
      final error = e.error;
      return error is ApiException ? error.message : currentL10n.somethingWentWrongPeriod;
    }
  }

  Future<String?> clearCart() async {
    _appliedOffer = null;
    try {
      await ref.read(cartRepositoryProvider).clearCart();
      state = const AsyncData(_emptyCart);
      return null;
    } on DioException catch (e) {
      final error = e.error;
      return error is ApiException ? error.message : currentL10n.somethingWentWrongPeriod;
    }
  }

  Future<String?> applyOffer(String code) async {
    try {
      final result = await ref.read(cartRepositoryProvider).applyOffer(code);
      _appliedOffer = result;
      _applyOfferError = null;
      final current = state.value ?? _emptyCart;
      state = AsyncData(current.copyWith(subtotal: result.subtotal));
      return null;
    } on DioException catch (e) {
      final error = e.error;
      final message = error is ApiException ? error.message : currentL10n.somethingWentWrongPeriod;
      _applyOfferError = message;
      return message;
    }
  }

  void clearAppliedOfferError() {
    _applyOfferError = null;
  }
}

final cartProvider = AsyncNotifierProvider<CartNotifier, CustomerCart>(CartNotifier.new);

/// Convenience total item count for badges, defaulting to 0 while loading.
final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).value?.items_count ?? 0;
});
