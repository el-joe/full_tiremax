import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/models/branch.dart';
import '../../../core/models/governorate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../cart/providers/cart_provider.dart';
import '../../orders/presentation/order_confirmation_screen.dart';
import '../data/checkout_repository.dart';
import '../models/payment_method.dart';
import '../providers/checkout_flow_provider.dart';

/// The checkout screen: order type (delivery/branch pickup), address details,
/// payment method selection, order summary and "Place order" CTA. Mirrors
/// `frontend/components/pages/checkout/CheckoutForm.tsx`.
///
/// IMPORTANT deviation from the task brief: the real checkout flow (per
/// `createOrderSchemas.ts` + the Postman `POST /orders` body) does NOT read
/// or write the saved `/addresses` CRUD endpoints at all. It takes a
/// freeform `shipping_address` text field plus a `governorate_id` select
/// directly on the order (or a `branch_id` for in-store pickup) — there is
/// no `address_id` concept on `Order`. So this screen has no address
/// picker/CRUD; it reproduces the web form's inline governorate + address
/// fields instead.
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isRedirecting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    final notifier = ref.read(checkoutFlowProvider.notifier);
    notifier
      ..setCustomerName(_nameController.text.trim())
      ..setCustomerPhone(_phoneController.text.trim())
      ..setCustomerEmail(_emailController.text.trim())
      ..setShippingAddress(_addressController.text.trim())
      ..setNotes(_notesController.text.trim());

    final orderId = await notifier.submit();
    if (!mounted) return;
    if (orderId == null) {
      final error = ref.read(checkoutFlowProvider).submitError;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? 'Could not place order.')),
      );
      return;
    }

    // Clear the local cart state (the backend clears it server-side on order
    // creation) and refresh so other screens don't show stale items.
    ref.read(cartProvider.notifier).refresh();

    setState(() => _isRedirecting = true);
    final payment = await ref.read(checkoutRepositoryProvider).fetchPayment(orderId);
    if (!mounted) return;
    setState(() => _isRedirecting = false);

    if (payment != null && payment.gateway.driver == 'paymob' && payment.redirect_url != null) {
      final uri = Uri.tryParse(payment.redirect_url!);
      if (uri != null) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }

    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => OrderConfirmationScreen(orderId: orderId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final flow = ref.watch(checkoutFlowProvider);
    final governoratesAsync = ref.watch(governoratesProvider);
    final branchesAsync = ref.watch(checkoutBranchesProvider);
    final paymentMethodsAsync = ref.watch(paymentMethodsProvider);
    final cart = ref.watch(cartProvider).value;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, title: const Text('Checkout')),
      body: SafeArea(
        child: (flow.isSubmitting || _isRedirecting)
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _SectionTitle('Order type'),
                  Row(
                    children: [
                      Expanded(
                        child: _OrderTypeCard(
                          label: 'Delivery',
                          selected: flow.type == OrderType.delivery,
                          onTap: () => ref.read(checkoutFlowProvider.notifier).setType(OrderType.delivery),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _OrderTypeCard(
                          label: 'Branch pickup',
                          selected: flow.type == OrderType.basra,
                          onTap: () => ref.read(checkoutFlowProvider.notifier).setType(OrderType.basra),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _SectionTitle('Personal information'),
                  _TextField(controller: _nameController, hint: 'Full name'),
                  const SizedBox(height: 10),
                  _TextField(controller: _phoneController, hint: 'Phone number', keyboardType: TextInputType.phone),
                  const SizedBox(height: 10),
                  _TextField(controller: _emailController, hint: 'Email (optional)', keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 20),
                  if (flow.type == OrderType.basra) ...[
                    _SectionTitle('Pickup branch'),
                    branchesAsync.when(
                      loading: () => const CircularProgressIndicator(color: AppColors.primary),
                      error: (_, _) => const Text('Could not load branches.', style: TextStyle(color: AppColors.gray2)),
                      data: (branches) => _BranchDropdown(
                        branches: branches,
                        selectedId: flow.branchId,
                        onChanged: (id) => ref.read(checkoutFlowProvider.notifier).setBranch(id),
                      ),
                    ),
                  ] else ...[
                    _SectionTitle('Delivery details'),
                    governoratesAsync.when(
                      loading: () => const CircularProgressIndicator(color: AppColors.primary),
                      error: (_, _) => const Text('Could not load governorates.', style: TextStyle(color: AppColors.gray2)),
                      data: (governorates) => _GovernorateDropdown(
                        governorates: governorates,
                        selectedId: flow.governorateId,
                        onChanged: (id) => ref.read(checkoutFlowProvider.notifier).setGovernorate(id),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _TextField(controller: _addressController, hint: 'Full address', maxLines: 3),
                  ],
                  const SizedBox(height: 10),
                  _TextField(controller: _notesController, hint: 'Notes (optional)', maxLines: 2),
                  const SizedBox(height: 20),
                  _SectionTitle('Payment method'),
                  paymentMethodsAsync.when(
                    loading: () => const CircularProgressIndicator(color: AppColors.primary),
                    error: (_, _) => const Text('Could not load payment methods.', style: TextStyle(color: AppColors.gray2)),
                    data: (methods) => Column(
                      children: [
                        for (final method in methods)
                          _PaymentMethodCard(
                            method: method,
                            selected: flow.paymentMethod == method.driver,
                            onTap: () => ref.read(checkoutFlowProvider.notifier).setPaymentMethod(method.driver),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (cart != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: AppColors.gray3, borderRadius: AppRadii.radiusLg),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Order total', style: TextStyle(color: AppColors.gray2)),
                          Text(
                            cart.subtotal.toStringAsFixed(2),
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: flow.isValid ? _placeOrder : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      disabledBackgroundColor: AppColors.gray3,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: AppRadii.radiusLg),
                    ),
                    child: const Text('Place order', style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
    );
  }
}

class _OrderTypeCard extends StatelessWidget {
  const _OrderTypeCard({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.radiusLg,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.gray3,
          borderRadius: AppRadii.radiusLg,
          border: Border.all(color: selected ? AppColors.primary : Colors.transparent, width: 2),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({required this.controller, required this.hint, this.keyboardType, this.maxLines = 1});

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.gray2),
        filled: true,
        fillColor: AppColors.gray3,
        border: OutlineInputBorder(borderRadius: AppRadii.radiusLg, borderSide: BorderSide.none),
      ),
    );
  }
}

class _GovernorateDropdown extends StatelessWidget {
  const _GovernorateDropdown({required this.governorates, required this.selectedId, required this.onChanged});

  final List<Governorate> governorates;
  final int? selectedId;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: AppColors.gray3, borderRadius: AppRadii.radiusLg),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isExpanded: true,
          value: selectedId,
          hint: const Text('Select governorate', style: TextStyle(color: AppColors.gray2)),
          dropdownColor: AppColors.gray3,
          style: const TextStyle(color: Colors.white),
          items: [
            for (final g in governorates) DropdownMenuItem(value: g.id, child: Text(g.name)),
          ],
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
      ),
    );
  }
}

class _BranchDropdown extends StatelessWidget {
  const _BranchDropdown({required this.branches, required this.selectedId, required this.onChanged});

  final List<Branch> branches;
  final int? selectedId;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: AppColors.gray3, borderRadius: AppRadii.radiusLg),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isExpanded: true,
          value: selectedId,
          hint: const Text('Select branch', style: TextStyle(color: AppColors.gray2)),
          dropdownColor: AppColors.gray3,
          style: const TextStyle(color: Colors.white),
          items: [
            for (final b in branches) DropdownMenuItem(value: b.id, child: Text(b.name)),
          ],
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({required this.method, required this.selected, required this.onTap});

  final PaymentMethod method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.radiusLg,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.gray3,
            borderRadius: AppRadii.radiusLg,
            border: Border.all(color: selected ? AppColors.primary : Colors.transparent, width: 2),
          ),
          child: Row(
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? AppColors.primary : AppColors.gray2,
              ),
              const SizedBox(width: 12),
              Text(method.display_name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}
