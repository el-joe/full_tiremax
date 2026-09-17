import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../data/store_repository.dart';
import '../providers/store_provider.dart';

/// Filter bottom sheet: brand, tire size, and vehicle make/model/year,
/// mirroring the web store's filter drawer.
class FilterSheet extends ConsumerStatefulWidget {
  const FilterSheet({super.key});

  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<FilterSheet> {
  late ProductFilters _draft;
  String? _selectedMake;
  String? _selectedModel;

  @override
  void initState() {
    super.initState();
    _draft = ref.read(storeListProvider).value?.filters ?? const ProductFilters();
    _selectedMake = _draft.make;
    _selectedModel = _draft.model;
  }

  @override
  Widget build(BuildContext context) {
    final brandsAsync = ref.watch(brandsProvider);
    final sizesAsync = ref.watch(tyreSizesProvider);
    final makesAsync = ref.watch(vehicleMakesProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.gray3,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Filters', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                  TextButton(
                    onPressed: () => setState(() {
                      _draft = const ProductFilters();
                      _selectedMake = null;
                      _selectedModel = null;
                    }),
                    child: const Text('Clear'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Brand', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              brandsAsync.when(
                data: (brands) => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: brands.map((brand) {
                    final selected = _draft.brandId == brand.id;
                    return ChoiceChip(
                      label: Text(brand.name),
                      selected: selected,
                      selectedColor: AppColors.primary,
                      onSelected: (value) => setState(() {
                        _draft = _draft.copyWith(brandId: value ? brand.id : null, clearBrand: !value);
                      }),
                    );
                  }).toList(),
                ),
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Failed to load brands', style: TextStyle(color: AppColors.error.withValues(alpha: 0.9))),
              ),
              const SizedBox(height: 20),
              const Text('Tire size', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              sizesAsync.when(
                data: (sizes) => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: sizes.map((size) {
                    final selected = _draft.width == size.width &&
                        _draft.aspectRatio == size.aspect_ratio &&
                        _draft.rimDiameter == size.rim_diameter;
                    return ChoiceChip(
                      label: Text('${size.width}/${size.aspect_ratio}R${size.rim_diameter}'),
                      selected: selected,
                      selectedColor: AppColors.primary,
                      onSelected: (value) => setState(() {
                        _draft = value
                            ? _draft.copyWith(
                                width: size.width,
                                aspectRatio: size.aspect_ratio,
                                rimDiameter: size.rim_diameter,
                              )
                            : _draft.copyWith(clearSize: true);
                      }),
                    );
                  }).toList(),
                ),
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => const Text('Failed to load sizes', style: TextStyle(color: AppColors.error)),
              ),
              const SizedBox(height: 20),
              const Text('Vehicle', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              makesAsync.when(
                data: (makes) => DropdownButtonFormField<String>(
                  initialValue: _selectedMake,
                  dropdownColor: AppColors.gray3,
                  decoration: const InputDecoration(labelText: 'Make'),
                  items: makes.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                  onChanged: (value) => setState(() {
                    _selectedMake = value;
                    _selectedModel = null;
                    _draft = _draft.copyWith(make: value, clearModel: true, clearYear: true);
                  }),
                ),
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => const Text('Failed to load makes', style: TextStyle(color: AppColors.error)),
              ),
              if (_selectedMake != null) ...[
                const SizedBox(height: 12),
                Consumer(builder: (context, ref, _) {
                  final modelsAsync = ref.watch(vehicleModelsProvider(_selectedMake!));
                  return modelsAsync.when(
                    data: (models) => DropdownButtonFormField<String>(
                      initialValue: _selectedModel,
                      dropdownColor: AppColors.gray3,
                      decoration: const InputDecoration(labelText: 'Model'),
                      items: models.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                      onChanged: (value) => setState(() {
                        _selectedModel = value;
                        _draft = _draft.copyWith(model: value, clearYear: true);
                      }),
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => const Text('Failed to load models', style: TextStyle(color: AppColors.error)),
                  );
                }),
              ],
              if (_selectedModel != null) ...[
                const SizedBox(height: 12),
                Consumer(builder: (context, ref, _) {
                  final yearsAsync = ref.watch(vehicleYearsProvider(_selectedModel!));
                  return yearsAsync.when(
                    data: (years) => DropdownButtonFormField<int>(
                      initialValue: _draft.year,
                      dropdownColor: AppColors.gray3,
                      decoration: const InputDecoration(labelText: 'Year'),
                      items: years.map((y) => DropdownMenuItem(value: y, child: Text('$y'))).toList(),
                      onChanged: (value) => setState(() => _draft = _draft.copyWith(year: value)),
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => const Text('Failed to load years', style: TextStyle(color: AppColors.error)),
                  );
                }),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: AppRadii.radiusFull),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    ref.read(storeListProvider.notifier).applyFilters(_draft);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
