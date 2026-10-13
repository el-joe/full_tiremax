import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/store_repository.dart';
import '../providers/store_provider.dart';
import 'filter_sheet.dart';

/// Store / Offers screen. `/offers` is the same catalog preset to
/// `badge=special_offer`. Large-title app bar with search + filter button
/// (active-count badge), sticky All/Tires/Batteries chips, result count and a
/// lazy 2-column grid with pull-to-refresh and infinite-scroll pagination.
class StoreScreen extends ConsumerStatefulWidget {
  const StoreScreen({
    super.key,
    this.initialFilters = const ProductFilters(),
    this.isOffers = false,
  });

  final ProductFilters initialFilters;
  final bool isOffers;

  @override
  ConsumerState<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends ConsumerState<StoreScreen> {
  late final TextEditingController _search;

  @override
  void initState() {
    super.initState();
    _search = TextEditingController(text: widget.initialFilters.search ?? '');
    Future.microtask(
      () => ref.read(storeListProvider.notifier).reset(widget.initialFilters),
    );
  }

  @override
  void didUpdateWidget(StoreScreen old) {
    super.didUpdateWidget(old);
    if (widget.isOffers != old.isOffers ||
        widget.initialFilters.toQuery(1).toString() !=
            old.initialFilters.toQuery(1).toString()) {
      _search.text = widget.initialFilters.search ?? '';
      ref.read(storeListProvider.notifier).reset(widget.initialFilters);
    }
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _apply(ProductFilters f) =>
      ref.read(storeListProvider.notifier).applyFilters(f);

  bool _onScroll(ScrollNotification n) {
    if (n.depth == 0 && n.metrics.maxScrollExtent - n.metrics.pixels < 600) {
      ref.read(storeListProvider.notifier).loadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final listState = ref.watch(storeListProvider);
    final filters = listState.value?.filters ?? widget.initialFilters;
    final activeCount = activeFilterCount(
      filters,
      ignoreBadge: widget.isOffers,
    );

    return Scaffold(
      backgroundColor: AppColors.page,
      body: NotificationListener<ScrollNotification>(
        onNotification: _onScroll,
        child: RefreshIndicator(
          onRefresh: () =>
              ref.read(storeListProvider.notifier).applyFilters(filters),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              LargeTitleSliverAppBar(
                title: widget.isOffers ? l10n.offers : l10n.store,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(64),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.gutter,
                      0,
                      AppSpacing.gutter,
                      AppSpacing.md,
                    ),
                    child: _searchRow(filters, activeCount),
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _ChipsHeader(
                  child: ChipRow(
                    children: [
                      AppChip(
                        label: l10n.all,
                        selected: filters.type == null,
                        onTap: () => _apply(filters.copyWith(clearType: true)),
                      ),
                      AppChip(
                        label: l10n.tires,
                        selected: filters.type == 'tire',
                        onTap: () => _apply(filters.copyWith(type: 'tire')),
                      ),
                      AppChip(
                        label: l10n.batteries,
                        selected: filters.type == 'battery',
                        onTap: () => _apply(filters.copyWith(type: 'battery')),
                      ),
                    ],
                  ),
                ),
              ),
              ...listState.when(
                loading: () => [const _GridSkeleton()],
                error: (error, _) => [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: ErrorState(
                      message: error.toString(),
                      onRetry: () => ref.invalidate(storeListProvider),
                    ),
                  ),
                ],
                data: (state) => state.products.isEmpty
                    ? [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: EmptyState(
                            icon: Icons.search_off,
                            title: l10n.noProducts,
                            actionLabel: l10n.clearFilters,
                            onAction: () {
                              _search.clear();
                              _apply(const ProductFilters());
                            },
                          ),
                        ),
                      ]
                    : [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              AppSpacing.gutter,
                              AppSpacing.xs,
                              AppSpacing.gutter,
                              AppSpacing.sm,
                            ),
                            child: Text(
                              l10n.resultsCount(state.total),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.gray2,
                              ),
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.gutter,
                          ),
                          sliver: SliverProductGrid(products: state.products),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 72,
                            child: state.isLoadingMore
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchRow(ProductFilters filters, int activeCount) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: TextField(
              controller: _search,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.foregroundLight,
              ),
              textInputAction: TextInputAction.search,
              onChanged: (_) => setState(() {}),
              onSubmitted: (v) =>
                  _apply(filters.copyWith(search: v, clearSearch: v.isEmpty)),
              decoration: InputDecoration(
                hintText: context.l10n.searchPlaceholder,
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: AppColors.gray2,
                ),
                filled: true,
                fillColor: Colors.white,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                prefixIcon: const Icon(Icons.search, color: AppColors.gray2),
                suffixIcon: _search.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 18,
                          color: AppColors.gray2,
                        ),
                        onPressed: () {
                          _search.clear();
                          setState(() {});
                          _apply(filters.copyWith(clearSearch: true));
                        },
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Semantics(
          button: true,
          label: context.l10n.filters,
          child: Material(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () =>
                  showAppBottomSheet<void>(context, (_) => const FilterSheet()),
              child: SizedBox(
                width: 48,
                height: 48,
                child: Center(
                  child: Badge(
                    isLabelVisible: activeCount > 0,
                    label: Text('$activeCount'),
                    child: const Icon(Icons.tune, color: AppColors.chrome),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChipsHeader extends SliverPersistentHeaderDelegate {
  _ChipsHeader({required this.child});

  final Widget child;

  static const double _height = 56;

  @override
  double get minExtent => _height;
  @override
  double get maxExtent => _height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: AppColors.page,
      alignment: Alignment.center,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _ChipsHeader old) => true;
}

class _GridSkeleton extends StatelessWidget {
  const _GridSkeleton();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(AppSpacing.gutter),
      sliver: SliverLayoutBuilder(
        builder: (context, c) {
          const gap = AppSpacing.md;
          final h = productCardExtent(context, (c.crossAxisExtent - gap) / 2);
          return SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: gap,
              crossAxisSpacing: gap,
              mainAxisExtent: h,
            ),
            delegate: SliverChildBuilderDelegate(
              (_, _) => const ShimmerBox(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              childCount: 6,
            ),
          );
        },
      ),
    );
  }
}
