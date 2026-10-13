import '../../../l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../data/store_repository.dart';
import '../providers/store_provider.dart';
import 'widgets/tabs_filter_by.dart';

const double _maxRange = 999999;

/// Filter drawer mirroring web `Filters.tsx`: title + context.l10n.clearFilters,
/// description, vehicle/size tabs (brand grid under the size tab), price
/// range slider and the context.l10n.findYourTireNow apply button.
class FilterSheet extends ConsumerStatefulWidget {
  const FilterSheet({super.key});

  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<FilterSheet> {
  late ProductFilters _draft;
  late RangeValues _range;

  @override
  void initState() {
    super.initState();
    _draft = ref.read(storeListProvider).value?.filters ?? const ProductFilters();
    _range = RangeValues((_draft.minPrice ?? 0).toDouble(), (_draft.maxPrice ?? _maxRange).toDouble());
  }

  Widget _brandSection() {
    final brandsAsync = ref.watch(brandsProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.brand, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.foregroundLight)),
          const SizedBox(height: 16),
          brandsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('$e', style: const TextStyle(color: AppColors.error)),
            data: (brands) => LayoutBuilder(
              builder: (context, c) {
                final w = (c.maxWidth - 8) / 2;
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final brand in brands)
                      SizedBox(
                        width: w,
                        child: _draft.brandId == brand.id
                            ? ElevatedButton(
                                onPressed: () => setState(() => _draft = _draft.copyWith(clearBrand: true)),
                                child: Text(brand.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                              )
                            : OutlinedButton(
                                style: OutlinedButton.styleFrom(foregroundColor: AppColors.foregroundLight),
                                onPressed: () => setState(() => _draft = _draft.copyWith(brandId: brand.id)),
                                child: Text(brand.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                              ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.light,
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Material(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            clipBehavior: Clip.antiAlias,
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(context.l10n.filters, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.foregroundLight)),
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: AppColors.foregroundLight),
                      // Web keeps type / search / badge when clearing.
                      onPressed: () {
                        final keep = _draft;
                        ref.read(storeListProvider.notifier).applyFilters(
                              ProductFilters(search: keep.search, type: keep.type, badge: keep.badge),
                            );
                        Navigator.of(context).pop();
                      },
                      child: Text(context.l10n.clearFilters, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                Text(context.l10n.filtersDescription, style: TextStyle(fontSize: 10, height: 2.8, color: AppColors.gray3)),
                const SizedBox(height: 24),
                TabsFilterBy(
                  filters: _draft,
                  onChanged: (next) => setState(() => _draft = next),
                  sizeTabExtra: _brandSection(),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(context.l10n.priceRange, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.foregroundLight)),
                    Text(
                      '${_range.start.round()} - ${_range.end.round()}',
                      style: const TextStyle(fontSize: 12, color: AppColors.gray2),
                    ),
                  ],
                ),
                RangeSlider(
                  values: _range,
                  min: 0,
                  max: _maxRange,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _range = v),
                  onChangeEnd: (v) => setState(() {
                    final atDefault = v.start == 0 && v.end == _maxRange;
                    _draft = atDefault
                        ? _draft.copyWith(clearPrice: true)
                        : _draft.copyWith(minPrice: v.start.round(), maxPrice: v.end.round());
                  }),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: () {
                    ref.read(storeListProvider.notifier).applyFilters(_draft);
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.search),
                  label: Text(context.l10n.findYourTireNow, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
