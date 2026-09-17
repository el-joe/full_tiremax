import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../shared/widgets/product_card.dart';
import '../../../shared/widgets/shimmer_box.dart';
import '../providers/store_provider.dart';
import 'filter_sheet.dart';

/// Store screen: searchable/filterable product grid with infinite scroll,
/// mirroring `frontend/app/[locale]/(productsView)/store/**`.
class StoreScreen extends ConsumerStatefulWidget {
  const StoreScreen({super.key});

  @override
  ConsumerState<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends ConsumerState<StoreScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 300) {
        ref.read(storeListProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listState = ref.watch(storeListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Store'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const FilterSheet(),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search products…',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: AppColors.gray3,
                  border: OutlineInputBorder(borderRadius: AppRadii.radiusFull, borderSide: BorderSide.none),
                ),
                onSubmitted: (value) => ref.read(storeListProvider.notifier).search(value),
              ),
            ),
            Expanded(
              child: listState.when(
                data: (state) {
                  if (state.products.isEmpty) {
                    return const Center(
                      child: Text('No products found.', style: TextStyle(color: AppColors.gray2)),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () => ref.read(storeListProvider.notifier).applyFilters(state.filters),
                    child: GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 140),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.58,
                      ),
                      itemCount: state.products.length + (state.hasMore ? 2 : 0),
                      itemBuilder: (context, index) {
                        if (index >= state.products.length) {
                          return const ShimmerBox(width: double.infinity, height: double.infinity);
                        }
                        return ProductCard(product: state.products[index], width: double.infinity);
                      },
                    ),
                  );
                },
                loading: () => GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.58,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) => const ShimmerBox(width: double.infinity, height: double.infinity),
                ),
                error: (error, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('$error', style: const TextStyle(color: AppColors.gray2), textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => ref.invalidate(storeListProvider),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
