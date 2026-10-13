import '../../../l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/shimmer_box.dart';
import '../../../shared/widgets/web_dropdown.dart';
import '../../../shared/widgets/web_pagination.dart';
import '../../../shared/widgets/web_sheet.dart';
import '../data/store_repository.dart';
import '../providers/store_provider.dart';
import 'filter_sheet.dart';

BorderRadius _startRadius(BuildContext context, double r) =>
    BorderRadiusDirectional.horizontal(start: Radius.circular(r)).resolve(Directionality.of(context));

Map<String, String> _badges(BuildContext context) => {
  'best_seller': context.l10n.bestSeller,
  'new': context.l10n.newBadge,
  'best_choice': context.l10n.bestChoice,
  'special_offer': context.l10n.specialOffer,
};

/// Store / Offers screen. Mirrors
/// `frontend/app/[locale]/(productsView)/{layout,store/page,offers}`: title +
/// description, search + badge select, All/Tires/Batteries tabs, product grid,
/// numbered pagination and the filter drawer (floating button on mobile).
/// `/offers` is the same catalog preset to `badge=special_offer` (the web
/// redirects it to `store?filter_products_badge=special_offer`).
class StoreScreen extends ConsumerStatefulWidget {
  const StoreScreen({super.key, this.initialFilters = const ProductFilters(), this.isOffers = false});

  final ProductFilters initialFilters;
  final bool isOffers;

  @override
  ConsumerState<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends ConsumerState<StoreScreen> {
  late final TextEditingController _search;
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _search = TextEditingController(text: widget.initialFilters.search ?? '');
    Future.microtask(() => ref.read(storeListProvider.notifier).reset(widget.initialFilters));
  }

  @override
  void didUpdateWidget(StoreScreen old) {
    super.didUpdateWidget(old);
    if (widget.isOffers != old.isOffers ||
        widget.initialFilters.toQuery(1).toString() != old.initialFilters.toQuery(1).toString()) {
      _search.text = widget.initialFilters.search ?? '';
      ref.read(storeListProvider.notifier).reset(widget.initialFilters);
    }
  }

  @override
  void dispose() {
    _search.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _apply(ProductFilters f) => ref.read(storeListProvider.notifier).applyFilters(f);

  @override
  Widget build(BuildContext context) {
    final listState = ref.watch(storeListProvider);
    final filters = listState.value?.filters ?? widget.initialFilters;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(widget.isOffers ? context.l10n.offers : context.l10n.store),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () => ref.read(storeListProvider.notifier).applyFilters(filters),
              child: ListView(
                controller: _scroll,
                padding: const EdgeInsets.only(top: 8, bottom: 140),
                children: [
                  WebSheet(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          widget.isOffers ? context.l10n.offers : context.l10n.productCatalog,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.foregroundLight),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          context.l10n.productCatalogDescription,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 26),
                        _searchRow(filters),
                        const SizedBox(height: 22),
                        _typeTabs(filters),
                        const SizedBox(height: 22),
                        listState.when(
                          loading: () => const _GridSkeleton(),
                          error: (error, _) => Center(
                            child: Column(
                              children: [
                                Text('$error', textAlign: TextAlign.center),
                                TextButton(
                                  onPressed: () => ref.invalidate(storeListProvider),
                                  child: Text(context.l10n.retry),
                                ),
                              ],
                            ),
                          ),
                          data: (state) => Column(
                            children: [
                              if (state.products.isEmpty)
                                Center(
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 400),
                                    child: Image.asset('assets/images/no_products.webp', semanticLabel: context.l10n.noProducts),
                                  ),
                                )
                              else
                                ProductGrid(products: state.products, rowGap: 48),
                              const SizedBox(height: 40),
                              WebPagination(
                                current: state.page,
                                last: state.lastPage,
                                onPage: (p) {
                                  ref.read(storeListProvider.notifier).goToPage(p);
                                  if (_scroll.hasClients) _scroll.jumpTo(0);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Web SmallScreenFilters: fixed button on the right at 40% height.
            PositionedDirectional(
              end: 0,
              top: MediaQuery.sizeOf(context).height * 0.3,
              child: Material(
                color: AppColors.primary,
                borderRadius: _startRadius(context, 12),
                child: InkWell(
                  borderRadius: _startRadius(context, 12),
                  onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const FilterSheet(),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(Icons.tune, color: AppColors.onPrimary),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchRow(ProductFilters filters) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _search,
                  style: const TextStyle(fontSize: 12, color: AppColors.foregroundLight),
                  textInputAction: TextInputAction.search,
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (v) => _apply(filters.copyWith(search: v, clearSearch: v.isEmpty)),
                  decoration: InputDecoration(
                    hintText: context.l10n.searchPlaceholder,
                    hintStyle: const TextStyle(fontSize: 12, color: AppColors.gray2),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    suffixIcon: _search.text.isEmpty
                        ? null
                        : IconButton(
                            iconSize: 16,
                            icon: const Icon(Icons.close, color: Colors.black),
                            onPressed: () {
                              _search.clear();
                              _apply(filters.copyWith(clearSearch: true));
                            },
                          ),
                    border: OutlineInputBorder(
                      borderRadius: _startRadius(context, 16),
                      borderSide: BorderSide(color: AppColors.gray),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: _startRadius(context, 16),
                      borderSide: BorderSide(color: AppColors.gray),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 46,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.horizontal(end: Radius.circular(16))),
                  ),
                  onPressed: () => _apply(filters.copyWith(search: _search.text, clearSearch: _search.text.isEmpty)),
                  icon: const Icon(Icons.search, size: 16),
                  label: Text(context.l10n.search, style: TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 110,
          child: WebDropdown<String>(
            label: null,
            placeholder: context.l10n.filterBy,
            radius: 16,
            value: filters.badge,
            items: [for (final e in _badges(context).entries) DropdownMenuItem(value: e.key, child: Text(e.value, style: const TextStyle(fontSize: 12)))],
            onChanged: (v) => _apply(v == null ? filters.copyWith(clearBadge: true) : filters.copyWith(badge: v)),
          ),
        ),
      ],
    );
  }

  Widget _typeTabs(ProductFilters filters) {
    Widget tab(String label, String? type) {
      final active = (filters.type ?? '') == (type ?? '');
      return InkWell(
        onTap: () => _apply(type == null ? filters.copyWith(clearType: true) : filters.copyWith(type: type)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 3, color: active ? AppColors.primary : Colors.transparent)),
          ),
          child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0x33D5C4AB)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [tab(context.l10n.all, null), tab(context.l10n.tires, 'tire'), tab(context.l10n.batteries, 'battery')],
      ),
    );
  }
}

class _GridSkeleton extends StatelessWidget {
  const _GridSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < 3; i++)
          const Padding(
            padding: EdgeInsets.only(bottom: 14),
            child: Row(
              children: [
                Expanded(child: ShimmerBox(height: 260, borderRadius: BorderRadius.all(Radius.circular(12)))),
                SizedBox(width: 14),
                Expanded(child: ShimmerBox(height: 260, borderRadius: BorderRadius.all(Radius.circular(12)))),
              ],
            ),
          ),
      ],
    );
  }
}
