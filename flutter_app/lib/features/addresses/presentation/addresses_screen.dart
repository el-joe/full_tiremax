import '../../../l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/city.dart';
import '../../../core/models/governorate.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../data/addresses_repository.dart';
import '../models/address.dart';
import '../providers/addresses_provider.dart';

/// Saved-address-book CRUD screen: list (GET /addresses), set-default,
/// delete, and an add/edit form with governorate -> city drill-down. Mirrors
/// `frontend/components/dialogs/{CreateAddressDialog,RemoveAddressDialog,
/// SetDefaultAddressDialog}.tsx`.
class AddressesScreen extends ConsumerWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressesAsync = ref.watch(addressesProvider);
    final locale = ref.watch(localeProvider).languageCode;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, title: Text(context.l10n.webProfileAddresses)),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => ref.read(addressesProvider.notifier).refresh(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              // Web `AddressesHeader`.
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.gray3,
                  borderRadius: AppRadii.radiusXl,
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l10n.savedAddresses,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 22)),
                    const SizedBox(height: 6),
                    Text(context.l10n.manageAddressesDescription,
                        style: TextStyle(color: AppColors.gray2, fontSize: 13)),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => _openAddressForm(context),
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(context.l10n.addAddress, style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              addressesAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                ),
                error: (error, _) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: Text(_errorMessage(error, context), style: const TextStyle(color: AppColors.gray2))),
                ),
                data: (addresses) {
                  if (addresses.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(context.l10n.noAddressYet,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      for (final a in addresses) ...[
                        _AddressCard(address: a, locale: locale),
                        const SizedBox(height: 22),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Web address card: icon tile + governorate + name, delete, location lines,
/// "Set as default" or the floating context.l10n.defaultAddress badge.
class _AddressCard extends ConsumerWidget {
  const _AddressCard({required this.address, required this.locale});

  final Address address;
  final String locale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDefault = address.is_default;
    final cityName = locale == 'ar' ? address.city.name_ar : address.city.name_en;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.gray3,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDefault ? AppColors.primary : const Color(0xFFE5E7EB)),
            boxShadow: isDefault
                ? const [BoxShadow(color: Color(0x33FDB604), blurRadius: 15, offset: Offset(0, 10), spreadRadius: -3)]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isDefault ? const Color(0x1AFDB604) : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(Icons.map_outlined, color: isDefault ? AppColors.primary : Colors.black),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(address.governorate.name,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
                        Text(address.full_name, style: const TextStyle(color: AppColors.gray2, fontSize: 13)),
                      ],
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.edit_outlined, size: 20, color: Colors.white),
                    onPressed: () => _openAddressForm(context, existing: address),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.delete_outline, size: 22, color: Colors.white),
                    onPressed: () => _confirmDelete(context, ref, address),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${address.governorate.name} $cityName',
                            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                        Text(address.address, style: const TextStyle(color: AppColors.gray2, fontSize: 14)),
                        const SizedBox(height: 12),
                        Text(address.phone, style: const TextStyle(color: AppColors.gray2, fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
              if (!isDefault) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: AppColors.gray2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () => _confirmSetDefault(context, ref, address),
                    child: Text(context.l10n.setAsDefaultAddress),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (isDefault)
          PositionedDirectional(
            top: -15,
            end: 20,
            child: Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(14)),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline, size: 16, color: Colors.black),
                  SizedBox(width: 6),
                  Text(context.l10n.defaultAddress,
                      style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

void _confirmSetDefault(BuildContext context, WidgetRef ref, Address address) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.gray3,
      title: Text(context.l10n.setAsDefaultAddress, style: TextStyle(color: Colors.white)),
      content: Text(context.l10n.setAsDefaultAddressWarning, style: TextStyle(color: AppColors.gray2)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(context.l10n.cancel)),
        TextButton(
          onPressed: () async {
            Navigator.pop(dialogContext);
            try {
              await ref.read(addressesProvider.notifier).setDefault(address.id);
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_errorMessage(e, context))));
              }
            }
          },
          child: Text(context.l10n.set, style: TextStyle(color: AppColors.primary)),
        ),
      ],
    ),
  );
}

void _confirmDelete(BuildContext context, WidgetRef ref, Address address) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.gray3,
      title: Text(context.l10n.removeAddress, style: TextStyle(color: Colors.white)),
      content: Text(context.l10n.removeAddressWarning, style: TextStyle(color: AppColors.gray2)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(context.l10n.cancel)),
        TextButton(
          onPressed: () async {
            Navigator.pop(dialogContext);
            try {
              await ref.read(addressesProvider.notifier).delete(address.id);
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_errorMessage(e, context))));
              }
            }
          },
          child: Text(context.l10n.remove, style: TextStyle(color: AppColors.red)),
        ),
      ],
    ),
  );
}

String _errorMessage(Object error, BuildContext context) {
  if (error is ApiException) return error.message;
  return context.l10n.somethingWentWrong;
}

void _openAddressForm(BuildContext context, {Address? existing}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _AddressFormSheet(existing: existing),
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
  late final TextEditingController _nameController =
      TextEditingController(text: widget.existing?.full_name);
  late final TextEditingController _phoneController =
      TextEditingController(text: widget.existing?.phone);
  late final TextEditingController _addressController =
      TextEditingController(text: widget.existing?.address);

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

  Future<void> _loadCities(int governorateId, {bool preserveSelection = false}) async {
    setState(() {
      _citiesLoading = true;
      if (!preserveSelection) _cityId = null;
    });
    try {
      final cities = await ref.read(addressesRepositoryProvider).fetchCities(governorateId);
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
          fullName: _nameController.text.trim().isEmpty ? null : _nameController.text.trim(),
          phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
          governorateId: _governorateId!,
          cityId: _cityId!,
          address: _addressController.text.trim(),
        );
      } else {
        await repository.updateAddress(
          id: widget.existing!.id,
          fullName: _nameController.text.trim().isEmpty ? null : _nameController.text.trim(),
          phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
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
    final governoratesAsync = ref.watch(_addressGovernoratesProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsetsDirectional.only(
            start: 20,
            end: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              controller: scrollController,
              children: [
                Text(
                  widget.existing == null ? context.l10n.createAddress : '${context.l10n.edit} ${context.l10n.webProfileAddresses}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
                ),
                const SizedBox(height: 20),
                _FormField(
                  label: context.l10n.profileFullName,
                  hint: context.l10n.enterYourFullName,
                  controller: _nameController,
                  // Optional in the web schema but required by the API
                  // (`StoreAddressRequest`), so enforce it here.
                  validator: (v) {
                    final t = v?.trim() ?? '';
                    if (t.isEmpty) return context.l10n.fullNameRequired;
                    return t.length > 120 ? context.l10n.nameMaxLength : null;
                  },
                ),
                const SizedBox(height: 14),
                _FormField(
                  label: context.l10n.profilePhoneNumber,
                  hint: context.l10n.phoneNumberPlaceholder,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    final t = v?.trim() ?? '';
                    if (t.isEmpty) return context.l10n.phoneRequired;
                    return t.length > 20 ? context.l10n.phoneNumberMaxLength : null;
                  },
                ),
                const SizedBox(height: 14),
                Text(context.l10n.governorate, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                governoratesAsync.when(
                  loading: () => const LinearProgressIndicator(color: AppColors.primary),
                  error: (_, _) => Text(context.l10n.somethingWentWrong, style: TextStyle(color: AppColors.gray2)),
                  data: (governorates) => _Dropdown<int>(
                    value: _governorateId,
                    hint: context.l10n.selectGovernorate,
                    items: [for (final g in governorates) DropdownMenuItem(value: g.id, child: Text(g.name))],
                    onChanged: (value) {
                      setState(() => _governorateId = value);
                      if (value != null) _loadCities(value);
                    },
                  ),
                ),
                const SizedBox(height: 14),
                Text(context.l10n.city, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                if (_citiesLoading)
                  const LinearProgressIndicator(color: AppColors.primary)
                else
                  _Dropdown<int>(
                    value: _cityId,
                    hint: context.l10n.selectCity,
                    items: [for (final c in _cities) DropdownMenuItem(value: c.id, child: Text((ref.watch(localeProvider).languageCode == 'ar') ? c.name_ar : c.name_en))],
                    onChanged: (value) => setState(() => _cityId = value),
                  ),
                const SizedBox(height: 14),
                _FormField(
                  label: context.l10n.profileFullAddress,
                  hint: context.l10n.profileFullAddressPlaceholder,
                  controller: _addressController,
                  maxLines: 3,
                  validator: (v) {
                    final trimmed = v?.trim() ?? '';
                    if (trimmed.isEmpty) return context.l10n.theAddressIsRequired;
                    if (trimmed.length < 12) return context.l10n.theAddressMustBeMoreThen12Character;
                    if (trimmed.length > 255) return context.l10n.addressMax255;
                    return null;
                  },
                ),
                if (_error != null) ...[
                  const SizedBox(height: 14),
                  Text(_error!, style: const TextStyle(color: AppColors.error)),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: AppRadii.radiusLg),
                    ),
                    onPressed: _submitting ? null : _submit,
                    child: _submitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onPrimary),
                          )
                        : Text(widget.existing == null ? context.l10n.createAddress : context.l10n.saveChanges,
                            style: const TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

final _addressGovernoratesProvider = FutureProvider<List<Governorate>>((ref) {
  return ref.watch(addressesRepositoryProvider).fetchGovernorates();
});

class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.controller,
    this.hint,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
  });

  final String label;
  final String? hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.gray2),
            filled: true,
            fillColor: AppColors.gray3,
            border: OutlineInputBorder(borderRadius: AppRadii.radiusLg, borderSide: BorderSide.none),
            errorStyle: const TextStyle(color: AppColors.error),
          ),
        ),
      ],
    );
  }
}

class _Dropdown<T> extends StatelessWidget {
  const _Dropdown({required this.value, required this.hint, required this.items, required this.onChanged});

  final T? value;
  final String hint;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: AppColors.gray3, borderRadius: AppRadii.radiusLg),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          hint: Text(hint, style: const TextStyle(color: AppColors.gray2)),
          dropdownColor: AppColors.gray3,
          style: const TextStyle(color: Colors.white),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
