import '../../../../l10n/l10n.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/web_dropdown.dart';
import '../../data/store_repository.dart';

/// Mirrors web `components/shared/TabsFilterBy.tsx` + `FilterByVehicle` +
/// `FilterBySize`: a two-tab card (context.l10n.searchByVehicle / context.l10n.searchBySize).
/// Holds no filter state itself: it edits [filters] through [onChanged]. The
/// vehicle id is resolved (GET `vehicles`) as soon as make+model+year are
/// all chosen, like the web.
class TabsFilterBy extends ConsumerStatefulWidget {
  const TabsFilterBy({
    super.key,
    required this.filters,
    required this.onChanged,
    this.sizeTabExtra,
    this.submitLabel,
    this.onSubmit,
  });

  final ProductFilters filters;
  final ValueChanged<ProductFilters> onChanged;

  /// Rendered under the size fields (web `sizeTabExtra`: the brand grid).
  final Widget? sizeTabExtra;

  /// When set, shows the primary context.l10n.findYourTireNow button (web `showButton`).
  final String? submitLabel;
  final VoidCallback? onSubmit;

  @override
  ConsumerState<TabsFilterBy> createState() => _TabsFilterByState();
}

class _TabsFilterByState extends ConsumerState<TabsFilterBy> {
  late bool _bySize;
  String? _vehicleLabel;
  bool _vehicleLoading = false;

  ProductFilters get f => widget.filters;

  @override
  void initState() {
    super.initState();
    _bySize = f.width != null || f.aspectRatio != null || f.rimDiameter != null;
  }

  void _setTab(bool bySize) {
    if (bySize == _bySize) return;
    setState(() {
      _bySize = bySize;
      _vehicleLabel = null;
    });
    // Drop the other mode's selections so hidden filters never apply silently.
    widget.onChanged(
      bySize
          ? f.copyWith(
              clearMake: true,
              clearModel: true,
              clearYear: true,
              clearVehicle: true,
            )
          : f.copyWith(clearSize: true, clearBrand: true),
    );
  }

  Future<void> _resolveVehicle(ProductFilters next) async {
    if (next.makeId == null || next.modelId == null || next.year == null) {
      setState(() => _vehicleLabel = null);
      widget.onChanged(next.copyWith(clearVehicle: true));
      return;
    }
    setState(() => _vehicleLoading = true);
    try {
      final match = await ref
          .read(storeRepositoryProvider)
          .fetchVehicleMatch(
            makeId: next.makeId!,
            modelId: next.modelId!,
            year: next.year!,
          );
      if (!mounted) return;
      setState(() {
        _vehicleLabel = match?.label;
        _vehicleLoading = false;
      });
      widget.onChanged(
        match == null
            ? next.copyWith(clearVehicle: true)
            : next.copyWith(vehicleId: match.id),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _vehicleLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: AppColors.primary,
              padding: const EdgeInsets.only(top: 3),
              child: Row(
                children: [
                  _TabButton(
                    label: context.l10n.searchByVehicle,
                    selected: !_bySize,
                    onTap: () => _setTab(false),
                  ),
                  _TabButton(
                    label: context.l10n.searchBySize,
                    selected: _bySize,
                    onTap: () => _setTab(true),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: _bySize ? _sizeTab() : _vehicleTab(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vehicleTab() {
    final makes = ref.watch(vehicleMakesProvider);
    final models = f.makeId == null
        ? null
        : ref.watch(vehicleModelsProvider(f.makeId!));
    final years = f.modelId == null
        ? null
        : ref.watch(vehicleYearsProvider(f.modelId!));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WebDropdown<int>(
          label: context.l10n.make,
          placeholder: context.l10n.selectMake,
          isLoading: makes.isLoading,
          value: f.makeId,
          items: [
            for (final m in makes.value ?? const <VehicleOption>[])
              DropdownMenuItem(value: m.id, child: Text(m.name)),
          ],
          onChanged: (v) {
            setState(() => _vehicleLabel = null);
            widget.onChanged(
              f.copyWith(
                makeId: v,
                clearModel: true,
                clearYear: true,
                clearVehicle: true,
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        WebDropdown<int>(
          label: context.l10n.model,
          placeholder: context.l10n.selectModel,
          isLoading: models?.isLoading ?? false,
          value: f.modelId,
          items: [
            for (final m in models?.value ?? const <VehicleOption>[])
              DropdownMenuItem(value: m.id, child: Text(m.name)),
          ],
          onChanged: (v) {
            setState(() => _vehicleLabel = null);
            widget.onChanged(
              f.copyWith(modelId: v, clearYear: true, clearVehicle: true),
            );
          },
        ),
        const SizedBox(height: 12),
        WebDropdown<int>(
          label: context.l10n.year,
          placeholder: context.l10n.selectYear,
          isLoading: years?.isLoading ?? false,
          value: f.year,
          items: [
            for (final y in years?.value ?? const <int>[])
              DropdownMenuItem(value: y, child: Text('$y')),
          ],
          onChanged: (v) =>
              _resolveVehicle(f.copyWith(year: v, clearVehicle: true)),
        ),
        if (_vehicleLoading) ...[
          const SizedBox(height: 12),
          const LinearProgressIndicator(
            minHeight: 44,
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
        ],
        if (_vehicleLabel != null && !_vehicleLoading) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              border: Border.all(color: const Color(0xFFB9F8CF)),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.directions_car_outlined,
                  size: 20,
                  color: Color(0xFF008236),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    _vehicleLabel!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF008236),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        ..._submit(),
      ],
    );
  }

  Widget _sizeTab() {
    final sizes = ref.watch(tyreSizesProvider);
    final list = sizes.value ?? const [];
    List<DropdownMenuItem<num>> opts(Iterable<num> values) => [
      for (final v in values.toSet())
        DropdownMenuItem(value: v, child: Text('$v')),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WebDropdown<num>(
          label: context.l10n.width,
          placeholder: context.l10n.selectWidth,
          isLoading: sizes.isLoading,
          value: f.width,
          items: opts(list.map((e) => e.width)),
          onChanged: (v) => widget.onChanged(f.copyWith(width: v)),
        ),
        const SizedBox(height: 12),
        WebDropdown<num>(
          label: context.l10n.aspectRatio,
          placeholder: context.l10n.selectAspectRatio,
          isLoading: sizes.isLoading,
          value: f.aspectRatio,
          items: opts(list.map((e) => e.aspect_ratio)),
          onChanged: (v) => widget.onChanged(f.copyWith(aspectRatio: v)),
        ),
        const SizedBox(height: 12),
        WebDropdown<num>(
          label: context.l10n.rimDiameter,
          placeholder: context.l10n.selectRimDiameter,
          isLoading: sizes.isLoading,
          value: f.rimDiameter,
          items: opts(list.map((e) => e.rim_diameter)),
          onChanged: (v) => widget.onChanged(f.copyWith(rimDiameter: v)),
        ),
        ..._submit(),
        if (widget.sizeTabExtra != null) widget.sizeTabExtra!,
      ],
    );
  }

  List<Widget> _submit() {
    if (widget.submitLabel == null) return const [];
    return [
      const SizedBox(height: 16),
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: widget.onSubmit,
        icon: const Icon(Icons.search, size: 18),
        label: Text(widget.submitLabel!, style: const TextStyle(fontSize: 12)),
      ),
    ];
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 8),
          color: selected ? AppColors.primary : Colors.white,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.foregroundLight,
            ),
          ),
        ),
      ),
    );
  }
}
