import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../product/models/product.dart';
import '../data/store_repository.dart';

class StoreListState {
  const StoreListState({
    this.products = const [],
    this.filters = const ProductFilters(),
    this.page = 1,
    this.lastPage = 1,
    this.isLoadingMore = false,
  });

  final List<Product> products;
  final ProductFilters filters;
  final int page;
  final int lastPage;
  final bool isLoadingMore;

  bool get hasMore => page < lastPage;

  StoreListState copyWith({
    List<Product>? products,
    ProductFilters? filters,
    int? page,
    int? lastPage,
    bool? isLoadingMore,
  }) {
    return StoreListState(
      products: products ?? this.products,
      filters: filters ?? this.filters,
      page: page ?? this.page,
      lastPage: lastPage ?? this.lastPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

/// Drives the Store screen's product grid: initial load, infinite-scroll
/// pagination, and filter/search changes (each of which restarts from
/// page 1), backed by `GET /products` + [PaginatedResponse].
class StoreListNotifier extends AsyncNotifier<StoreListState> {
  @override
  Future<StoreListState> build() async {
    return _loadPage(const ProductFilters(), 1);
  }

  Future<StoreListState> _loadPage(ProductFilters filters, int page) async {
    final repository = ref.read(storeRepositoryProvider);
    final result = await repository.fetchProducts(page: page, filters: filters);
    return StoreListState(
      products: result.data,
      filters: filters,
      page: result.pagination.currentPage,
      lastPage: result.pagination.lastPage,
    );
  }

  Future<void> applyFilters(ProductFilters filters) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadPage(filters, 1));
  }

  Future<void> search(String query) async {
    final current = state.value?.filters ?? const ProductFilters();
    await applyFilters(current.copyWith(search: query));
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.isLoadingMore || !current.hasMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));
    try {
      final repository = ref.read(storeRepositoryProvider);
      final result = await repository.fetchProducts(
        page: current.page + 1,
        filters: current.filters,
      );
      state = AsyncData(
        current.copyWith(
          products: [...current.products, ...result.data],
          page: result.pagination.currentPage,
          lastPage: result.pagination.lastPage,
          isLoadingMore: false,
        ),
      );
    } catch (_) {
      state = AsyncData(current.copyWith(isLoadingMore: false));
    }
  }
}

final storeListProvider = AsyncNotifierProvider<StoreListNotifier, StoreListState>(
  StoreListNotifier.new,
);
