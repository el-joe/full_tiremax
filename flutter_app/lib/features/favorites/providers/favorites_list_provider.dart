import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/favorites_repository.dart';
import '../models/customer_fav.dart';
import 'favorites_provider.dart';

/// Full favorites list (used by the Favorites screen), backed by
/// `GET /favorites`. Keeps [favoritesProvider]'s id set in sync so the heart
/// icon elsewhere in the app reflects the same state.
class FavoritesListNotifier extends AsyncNotifier<List<CustomerFav>> {
  @override
  Future<List<CustomerFav>> build() async {
    final repository = ref.read(favoritesRepositoryProvider);
    final favorites = await repository.fetchFavorites();
    ref.read(favoritesProvider.notifier).syncIds(favorites.map((f) => f.id));
    return favorites;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(favoritesRepositoryProvider);
      final favorites = await repository.fetchFavorites();
      ref.read(favoritesProvider.notifier).syncIds(favorites.map((f) => f.id));
      return favorites;
    });
  }

  /// Optimistically removes [productId] from the list and toggles it off on
  /// the server, rolling back on failure. Mirrors the product-card toggle
  /// but also updates the list shown on this screen.
  Future<void> toggle(int productId) async {
    final previous = state.value ?? const [];
    final next = previous.where((f) => f.id != productId).toList();
    state = AsyncData(next);
    ref.read(favoritesProvider.notifier).syncIds(next.map((f) => f.id));

    final repository = ref.read(favoritesRepositoryProvider);
    try {
      await repository.toggle(productId);
    } catch (_) {
      state = AsyncData(previous);
      ref.read(favoritesProvider.notifier).syncIds(previous.map((f) => f.id));
      rethrow;
    }
  }
}

final favoritesListProvider =
    AsyncNotifierProvider<FavoritesListNotifier, List<CustomerFav>>(
  FavoritesListNotifier.new,
);
