import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/city.dart';
import '../../../core/models/governorate.dart';
import '../../../core/network/api_exception.dart';
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, title: const Text('Addresses')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        onPressed: () => _openAddressForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Address', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: addressesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (error, _) => Center(child: Text('$error', style: const TextStyle(color: AppColors.gray2))),
          data: (addresses) {
            if (addresses.isEmpty) {
              return const Center(child: Text('No saved addresses yet.', style: TextStyle(color: AppColors.gray2)));
            }
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => ref.read(addressesProvider.notifier).refresh(),
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                itemCount: addresses.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) => _AddressCard(address: addresses[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AddressCard extends ConsumerWidget {
  const _AddressCard({required this.address});

  final Address address;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.gray3, borderRadius: AppRadii.radiusXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(address.full_name,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
              ),
              if (address.is_default)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: AppRadii.radiusFull),
                  child: const Text('Default',
                      style: TextStyle(color: AppColors.onPrimary, fontSize: 11, fontWeight: FontWeight.w700)),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(address.phone, style: const TextStyle(color: AppColors.gray2, fontSize: 13)),
          const SizedBox(height: 4),
          Text(
            '${address.address}, ${address.city.name_en}, ${address.governorate.name}',
            style: const TextStyle(color: AppColors.gray2, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (!address.is_default)
                TextButton(
                  onPressed: () => _confirmSetDefault(context, ref, address),
                  child: const Text('Set as default', style: TextStyle(color: AppColors.primary)),
                ),
              TextButton(
                onPressed: () => _openAddressForm(context, existing: address),
                child: const Text('Edit', style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () => _confirmDelete(context, ref, address),
                child: const Text('Delete', style: TextStyle(color: AppColors.red)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void _confirmSetDefault(BuildContext context, WidgetRef ref, Address address) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.gray3,
      title: const Text('Set as Default Address', style: TextStyle(color: Colors.white)),
      content: const Text(
        'Make this your default delivery address?',
        style: TextStyle(color: AppColors.gray2),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
        TextButton(
          onPressed: () async {
            Navigator.pop(dialogContext);
            try {
              await ref.read(addressesProvider.notifier).setDefault(address.id);
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_errorMessage(e))));
              }
            }
          },
          child: const Text('Confirm', style: TextStyle(color: AppColors.primary)),
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
      title: const Text('Remove Address', style: TextStyle(color: Colors.white)),
      content: const Text(
        "You won't be able to restore this address once it has been removed.",
        style: TextStyle(color: AppColors.gray2),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Keep Address')),
        TextButton(
          onPressed: () async {
            Navigator.pop(dialogContext);
            try {
              await ref.read(addressesProvider.notifier).delete(address.id);
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_errorMessage(e))));
              }
            }
          },
          child: const Text('Remove', style: TextStyle(color: AppColors.red)),
        ),
      ],
    ),
  );
}

String _errorMessage(Object error) {
  if (error is ApiException) return error.message;
  return 'Something went wrong. Please try again.';
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
      setState(() => _error = 'Governorate selection is required');
      return;
    }
    if (_cityId == null) {
      setState(() => _error = 'City selection is required');
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
          fullName: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          governorateId: _governorateId!,
          cityId: _cityId!,
          address: _addressController.text.trim(),
        );
      } else {
        await repository.updateAddress(
          id: widget.existing!.id,
          fullName: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
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
        _error = _errorMessage(e);
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
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              controller: scrollController,
              children: [
                Text(
                  widget.existing == null ? 'Add Address' : 'Edit Address',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
                ),
                const SizedBox(height: 20),
                _FormField(
                  label: 'Full Name',
                  controller: _nameController,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Full name is required' : null,
                ),
                const SizedBox(height: 14),
                _FormField(
                  label: 'Phone Number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Phone is required' : null,
                ),
                const SizedBox(height: 14),
                const Text('Governorate', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                governoratesAsync.when(
                  loading: () => const LinearProgressIndicator(color: AppColors.primary),
                  error: (_, _) => const Text('Could not load governorates.', style: TextStyle(color: AppColors.gray2)),
                  data: (governorates) => _Dropdown<int>(
                    value: _governorateId,
                    hint: 'Select governorate',
                    items: [for (final g in governorates) DropdownMenuItem(value: g.id, child: Text(g.name))],
                    onChanged: (value) {
                      setState(() => _governorateId = value);
                      if (value != null) _loadCities(value);
                    },
                  ),
                ),
                const SizedBox(height: 14),
                const Text('City', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                if (_citiesLoading)
                  const LinearProgressIndicator(color: AppColors.primary)
                else
                  _Dropdown<int>(
                    value: _cityId,
                    hint: 'Select city',
                    items: [for (final c in _cities) DropdownMenuItem(value: c.id, child: Text(c.name_en))],
                    onChanged: (value) => setState(() => _cityId = value),
                  ),
                const SizedBox(height: 14),
                _FormField(
                  label: 'Full Address',
                  controller: _addressController,
                  maxLines: 3,
                  validator: (v) {
                    final trimmed = v?.trim() ?? '';
                    if (trimmed.isEmpty) return 'Address is required';
                    if (trimmed.length < 12) return 'The address must be more than 12 characters';
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
                        : Text(widget.existing == null ? 'Add Address' : 'Save Changes',
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
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
  });

  final String label;
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
