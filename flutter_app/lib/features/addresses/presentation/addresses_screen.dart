import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/city.dart';
import '../../../core/models/governorate.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/addresses_repository.dart';
import '../models/address.dart';
import '../providers/addresses_provider.dart';

/// Saved-address-book CRUD screen: card list (GET /addresses), set-default,
/// delete, and an add/edit bottom-sheet form with governorate -> city
/// drill-down. Mirrors `frontend/components/dialogs/{CreateAddressDialog,
/// RemoveAddressDialog,SetDefaultAddressDialog}.tsx`.
class AddressesScreen extends ConsumerWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final addressesAsync = ref.watch(addressesProvider);
    final locale = ref.watch(localeProvider).languageCode;

    return AppScaffold(
      title: l.webProfileAddresses,
      bottomBar: StickyBottomBar(
        action: PrimaryButton(
          label: l.addAddress,
          icon: Icons.add,
          onPressed: () => _openAddressForm(context),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => ref.read(addressesProvider.notifier).refresh(),
        child: addressesAsync.when(
          loading: () => const SkeletonList(itemCount: 3, itemHeight: 140),
          error: (error, _) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: 360,
                child: ErrorState(
                  message: _errorMessage(error, context),
                  onRetry: () => ref.read(addressesProvider.notifier).refresh(),
                ),
              ),
            ],
          ),
          data: (addresses) {
            if (addresses.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: 360,
                    child: EmptyState(
                      icon: Icons.location_off_outlined,
                      title: l.noAddressYet,
                      message: l.manageAddressesDescription,
                    ),
                  ),
                ],
              );
            }
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.gutter),
              children: [
                for (final a in addresses) ...[
                  _AddressCard(address: a, locale: locale),
                  const SizedBox(height: AppSpacing.md),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AddressCard extends ConsumerWidget {
  const _AddressCard({required this.address, required this.locale});

  final Address address;
  final String locale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final isDefault = address.is_default;
    final cityName = locale == 'ar'
        ? address.city.name_ar
        : address.city.name_en;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDefault ? AppColors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    '${address.governorate.name} - $cityName',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.foregroundLight,
                    ),
                  ),
                ),
                if (isDefault)
                  StatusPill(label: l.defaultAddress, color: AppColors.green),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              address.full_name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.foregroundLight,
              ),
            ),
            Text(
              address.address,
              style: const TextStyle(fontSize: 13, color: AppColors.gray2),
            ),
            Text(
              address.phone,
              textDirection: TextDirection.ltr,
              style: const TextStyle(fontSize: 13, color: AppColors.gray2),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                if (!isDefault)
                  TextButton(
                    onPressed: () => _confirmSetDefault(context, ref, address),
                    child: Text(l.setAsDefaultAddress),
                  ),
                TextButton.icon(
                  onPressed: () => _openAddressForm(context, existing: address),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: Text(l.edit),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(foregroundColor: AppColors.error),
                  onPressed: () => _confirmDelete(context, ref, address),
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: Text(l.remove),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _confirmSetDefault(
  BuildContext context,
  WidgetRef ref,
  Address address,
) async {
  final l = context.l10n;
  final ok = await showConfirmDialog(
    context,
    title: l.setAsDefaultAddress,
    message: l.setAsDefaultAddressWarning,
    confirmLabel: l.set,
    cancelLabel: l.cancel,
    destructive: false,
  );
  if (!ok) return;
  try {
    await ref.read(addressesProvider.notifier).setDefault(address.id);
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(_errorMessage(e, context))));
    }
  }
}

Future<void> _confirmDelete(
  BuildContext context,
  WidgetRef ref,
  Address address,
) async {
  final l = context.l10n;
  final ok = await showConfirmDialog(
    context,
    title: l.removeAddress,
    message: l.removeAddressWarning,
    confirmLabel: l.remove,
    cancelLabel: l.cancel,
  );
  if (!ok) return;
  try {
    await ref.read(addressesProvider.notifier).delete(address.id);
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(_errorMessage(e, context))));
    }
  }
}

String _errorMessage(Object error, BuildContext context) {
  if (error is ApiException) return error.message;
  return context.l10n.somethingWentWrong;
}

void _openAddressForm(BuildContext context, {Address? existing}) {
  showAppBottomSheet<void>(
    context,
    (context) => _AddressFormSheet(existing: existing),
  );
}

class _AddressFormSheet extends ConsumerStatefulWidget {
  const _AddressFormSheet({this.existing});

  final Address? existing;

  @override
  ConsumerState<_AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends ConsumerState<_AddressFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController = TextEditingController(
    text: widget.existing?.full_name,
  );
  late final TextEditingController _phoneController = TextEditingController(
    text: widget.existing?.phone,
  );
  late final TextEditingController _addressController = TextEditingController(
    text: widget.existing?.address,
  );

  int? _governorateId;
  int? _cityId;
  List<City> _cities = const [];
  bool _citiesLoading = false;
  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _governorateId = widget.existing?.governorate.id;
    _cityId = widget.existing?.city.id;
    if (_governorateId != null) {
      _loadCities(_governorateId!, preserveSelection: true);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _loadCities(
    int governorateId, {
    bool preserveSelection = false,
  }) async {
    setState(() {
      _citiesLoading = true;
      if (!preserveSelection) _cityId = null;
    });
    try {
      final cities = await ref
          .read(addressesRepositoryProvider)
          .fetchCities(governorateId);
      setState(() {
        _cities = cities;
        _citiesLoading = false;
      });
    } catch (_) {
      setState(() {
        _cities = const [];
        _citiesLoading = false;
      });
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_governorateId == null) {
      setState(() => _error = context.l10n.selectGovernorateIsRequired);
      return;
    }
    if (_cityId == null) {
      setState(() => _error = context.l10n.selectCityIsRequired);
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      final repository = ref.read(addressesRepositoryProvider);
      if (widget.existing == null) {
        await repository.createAddress(
          fullName: _nameController.text.trim().isEmpty
              ? null
              : _nameController.text.trim(),
          phone: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
          governorateId: _governorateId!,
          cityId: _cityId!,
          address: _addressController.text.trim(),
        );
      } else {
        await repository.updateAddress(
          id: widget.existing!.id,
          fullName: _nameController.text.trim().isEmpty
              ? null
              : _nameController.text.trim(),
          phone: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
          governorateId: _governorateId!,
          cityId: _cityId!,
          address: _addressController.text.trim(),
        );
      }
      await ref.read(addressesProvider.notifier).refresh();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() {
        _submitting = false;
        _error = _errorMessage(e, context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final governoratesAsync = ref.watch(_addressGovernoratesProvider);
    final isAr = ref.watch(localeProvider).languageCode == 'ar';

    return BottomSheetScaffold(
      title: widget.existing == null
          ? l.createAddress
          : '${l.edit} ${l.webProfileAddresses}',
      actionBar: PrimaryButton(
        label: widget.existing == null ? l.createAddress : l.saveChanges,
        loading: _submitting,
        onPressed: _submit,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              label: l.profileFullName,
              controller: _nameController,
              textInputAction: TextInputAction.next,
              // Optional in the web schema but required by the API
              // (`StoreAddressRequest`), so enforce it here.
              validator: (v) {
                final t = v?.trim() ?? '';
                if (t.isEmpty) return l.fullNameRequired;
                return t.length > 120 ? l.nameMaxLength : null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: l.profilePhoneNumber,
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              validator: (v) {
                final t = v?.trim() ?? '';
                if (t.isEmpty) return l.phoneRequired;
                return t.length > 20 ? l.phoneNumberMaxLength : null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            governoratesAsync.when(
              loading: () =>
                  const LinearProgressIndicator(color: AppColors.primary),
              error: (_, _) => Text(
                l.somethingWentWrong,
                style: const TextStyle(color: AppColors.gray2),
              ),
              data: (governorates) => _Dropdown<int>(
                label: l.governorate,
                value: _governorateId,
                items: [
                  for (final g in governorates)
                    DropdownMenuItem(value: g.id, child: Text(g.name)),
                ],
                onChanged: (value) {
                  setState(() => _governorateId = value);
                  if (value != null) _loadCities(value);
                },
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (_citiesLoading)
              const LinearProgressIndicator(color: AppColors.primary)
            else
              _Dropdown<int>(
                label: l.city,
                value: _cityId,
                items: [
                  for (final c in _cities)
                    DropdownMenuItem(
                      value: c.id,
                      child: Text(isAr ? c.name_ar : c.name_en),
                    ),
                ],
                onChanged: (value) => setState(() => _cityId = value),
              ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: l.profileFullAddress,
              controller: _addressController,
              maxLines: 3,
              validator: (v) {
                final trimmed = v?.trim() ?? '';
                if (trimmed.isEmpty) return l.theAddressIsRequired;
                if (trimmed.length < 12) {
                  return l.theAddressMustBeMoreThen12Character;
                }
                if (trimmed.length > 255) return l.addressMax255;
                return null;
              },
            ),
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.md),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 18,
                    color: AppColors.error,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      _error!,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

final _addressGovernoratesProvider = FutureProvider<List<Governorate>>((ref) {
  return ref.watch(addressesRepositoryProvider).fetchGovernorates();
});

class _Dropdown<T> extends StatelessWidget {
  const _Dropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color c) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: c),
    );
    return DropdownButtonFormField<T>(
      key: ValueKey('$label-$value-${items.length}'),
      initialValue: value,
      isExpanded: true,
      items: items,
      onChanged: onChanged,
      dropdownColor: Colors.white,
      style: const TextStyle(fontSize: 14, color: AppColors.foregroundLight),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.gray2),
        filled: true,
        fillColor: Colors.white,
        border: border(AppColors.gray),
        enabledBorder: border(AppColors.gray),
        focusedBorder: border(AppColors.primary),
      ),
    );
  }
}
