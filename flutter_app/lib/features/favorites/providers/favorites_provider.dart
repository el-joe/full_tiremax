import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/favorites_repository.dart';

/// Tracks which product ids are currently favorited, hydrated from
/// `GET /favorites` so the heart icon on product cards elsewhere in the app
/// (home, store, product detail) reflects real server-side favorite state
/// instead of only this-session toggles.
///
/// [favoritesListProvider] is the richer, screen-facing counterpart (full
/// [CustomerFav] objects) used by the Favorites screen itself; this notifier
/// stays in sync with it via [syncIds] so both never disagree after a toggle
/// from either surface.
class FavoritesNotifier extends Notifier<Set<int>> {
  @override
  Set<int> build() {
    // Hydrate asynchronously from the server on first use (app start / first
    // time any widget reads this provider) without blocking the initial
    // (empty) state.
    Future(() async {
      final repository = ref.read(favoritesRepositoryProvider);
      try {
        final favorites = await repository.fetchFavorites();
        state = favorites.map((f) => f.id).toSet();
      } catch (_) {
        // Leave state empty; a toggle still round-trips to the real API and
        // the favorites screen will surface any load error itself.
      }
    });
    return <int>{};
  }

  /// Replaces the id set wholesale, e.g. after the favorites screen loads
  /// the authoritative list from the server.
  void syncIds(Iterable<int> ids) => state = ids.toSet();

  Future<void> toggle(int productId) async {
    final wasFavorited = state.contains(productId);
    state = wasFavorited
        ? ({...state}..remove(productId))
        : ({...state}..add(productId));

    final repository = ref.read(favoritesRepositoryProvider);
    try {
      await repository.toggle(productId);
    } catch (_) {
      // Roll back optimistic update on failure.
      state = wasFavorited
          ? ({...state}..add(productId))
          : ({...state}..remove(productId));
      rethrow;
    }
  }
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, Set<int>>(
  FavoritesNotifier.new,
);
