import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/format.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/store_repository.dart';
import '../providers/store_provider.dart';
import 'widgets/tabs_filter_by.dart';

const double _maxRange = 999999;

/// Number of active (non search/type) filters, shown on the Store filter button.
int activeFilterCount(ProductFilters f, {bool ignoreBadge = false}) {
  var n = 0;
  if (f.brandId != null) n++;
  if (f.categoryId != null) n++;
  if (f.minPrice != null || f.maxPrice != null) n++;
  if (f.vehicleId != null || f.makeId != null) n++;
  if (f.width != null || f.aspectRatio != null || f.rimDiameter != null) n++;
  if (!ignoreBadge && f.badge != null) n++;
  return n;
}

/// Filter bottom sheet: badge chips, vehicle/size tabs (brand chips under the
/// size tab), price range and a sticky apply/clear bar. Same filter semantics
/// as the web `Filters.tsx`. Show with [showAppBottomSheet].
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
    _draft =
        ref.read(storeListProvider).value?.filters ?? const ProductFilters();
    _range = RangeValues(
      (_draft.minPrice ?? 0).toDouble(),
      (_draft.maxPrice ?? _maxRange).toDouble(),
    );
  }

  Widget _badgeSection() {
    final l10n = context.l10n;
    final badges = {
      'special_offer': l10n.specialOffer,
      'best_seller': l10n.bestSeller,
      'new': l10n.newBadge,
      'best_choice': l10n.bestChoice,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.filterBy, style: _titleStyle),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final e in badges.entries)
              AppChip(
                label: e.value,
                selected: _draft.badge == e.key,
                onTap: () => setState(
                  () => _draft = _draft.badge == e.key
                      ? _draft.copyWith(clearBadge: true)
                      : _draft.copyWith(badge: e.key),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _brandSection() {
    final brandsAsync = ref.watch(brandsProvider);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.brand, style: _titleStyle),
          const SizedBox(height: AppSpacing.md),
          brandsAsync.when(
            loading: () => const ShimmerBox(height: 44, width: double.infinity),
            error: (e, _) => Text(
              context.l10n.somethingWentWrong,
              style: const TextStyle(color: AppColors.error),
            ),
            data: (brands) => Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final brand in brands)
                  AppChip(
                    label: brand.name,
                    selected: _draft.brandId == brand.id,
                    onTap: () => setState(
                      () => _draft = _draft.brandId == brand.id
                          ? _draft.copyWith(clearBrand: true)
                          : _draft.copyWith(brandId: brand.id),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static const _titleStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.foregroundLight,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BottomSheetScaffold(
      title: l10n.filters,
      actionBar: Row(
        children: [
          Expanded(
            child: SecondaryButton(
              label: l10n.clearFilters,
              // Web keeps type / search / badge when clearing.
              onPressed: () {
                final keep = _draft;
                ref
                    .read(storeListProvider.notifier)
                    .applyFilters(
                      ProductFilters(
                        search: keep.search,
                        type: keep.type,
                        badge: keep.badge,
                      ),
                    );
                Navigator.of(context).pop();
              },
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            flex: 2,
            child: PrimaryButton(
              label: l10n.apply,
              onPressed: () {
                ref.read(storeListProvider.notifier).applyFilters(_draft);
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _badgeSection(),
          TabsFilterBy(
            filters: _draft,
            onChanged: (next) => setState(() => _draft = next),
            sizeTabExtra: _brandSection(),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(child: Text(l10n.priceRange, style: _titleStyle)),
              Text(
                '${formatNumber(_range.start.round())} - ${formatNumber(_range.end.round())}',
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
                  : _draft.copyWith(
                      minPrice: v.start.round(),
                      maxPrice: v.end.round(),
                    );
            }),
          ),
        ],
      ),
    );
  }
}
