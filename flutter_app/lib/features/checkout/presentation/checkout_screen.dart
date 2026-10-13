import '../../../l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/models/branch.dart';
import '../../../core/models/governorate.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/utils/format.dart';
import '../../../shared/widgets/shimmer_box.dart';
import '../../../shared/widgets/web_dropdown.dart';
import '../../auth/presentation/auth_sheet.dart';
import '../../auth/providers/auth_provider.dart';
import '../../cart/providers/cart_provider.dart';
import '../../orders/presentation/order_confirmation_screen.dart';
import '../../orders/presentation/order_widgets.dart' show PriceBreakdown;
import '../data/checkout_repository.dart';
import '../models/payment_method.dart';
import '../providers/checkout_flow_provider.dart';

/// Checkout form: order type, personal info (+ optional account creation),
/// branch / governorate + address, notes, payment method, order summary and
/// context.l10n.confirmOrder. Mirrors `frontend/components/pages/checkout/CheckoutForm.tsx`
/// + `CheckoutSummary.tsx` and `Schemas/createOrderSchemas.ts`. The web form
/// takes a freeform `shipping_address` (no saved-address CRUD).
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
  final _passwordController = TextEditingController();
  bool _isRedirecting = false;
  bool _showErrors = false;

  @override
  void initState() {
    super.initState();
    final customer = ref.read(customerProvider);
    if (customer != null) {
      _nameController.text = customer.name;
      _phoneController.text = customer.phone;
      _emailController.text = customer.email ?? '';
    }
    Future.microtask(() {
      if (!mounted) return;
      ref.invalidate(checkoutFlowProvider);
      if (customer != null) {
        ref.read(checkoutFlowProvider.notifier)
          ..setCustomerName(customer.name)
          ..setCustomerPhone(customer.phone)
          ..setCustomerEmail(customer.email ?? '');
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    final notifier = ref.read(checkoutFlowProvider.notifier);
    notifier
      ..setCustomerName(_nameController.text.trim())
      ..setCustomerPhone(_phoneController.text.trim())
      ..setCustomerEmail(_emailController.text.trim())
      ..setShippingAddress(_addressController.text.trim())
      ..setNotes(_notesController.text.trim())
      ..setPassword(_passwordController.text);
    setState(() => _showErrors = true);
    if (!ref.read(checkoutFlowProvider).isValid) return;

    final isLogged = ref.read(isLoggedInProvider);
    final form = ref.read(checkoutFlowProvider);
    final orderId = await notifier.submit();
    if (!mounted) return;
    if (orderId == null) {
      final error = ref.read(checkoutFlowProvider).submitError;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? context.l10n.somethingWentWrong)),
      );
      return;
    }

    // Server cart is emptied by the order; reset the local cart.
    ref.read(cartProvider.notifier).refresh();

    // Optional: create an account with this order (server links the guest order).
    if (!isLogged && form.createAccount && form.password.isNotEmpty) {
      try {
        await ref.read(authProvider.notifier).register(
              name: form.customerName,
              phone: form.customerPhone,
              email: form.customerEmail.isEmpty ? null : form.customerEmail,
              password: form.password,
              passwordConfirmation: form.password,
              locale: ref.read(localeProvider).languageCode,
            );
      } catch (e) {
        if (mounted) {
          final msg = e is ApiException ? e.message : null;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(msg == null ? context.l10n.accountNotCreated : '${context.l10n.accountNotCreated} $msg')));
        }
      }
    }
    if (!mounted) return;

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
    final notifier = ref.read(checkoutFlowProvider.notifier);
    final governoratesAsync = ref.watch(governoratesProvider);
    final branchesAsync = ref.watch(checkoutBranchesProvider);
    final paymentMethodsAsync = ref.watch(paymentMethodsProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final cart = ref.watch(cartProvider).value;
    final isLogged = ref.watch(isLoggedInProvider);
    final errors = _showErrors ? flow.validate() : const <String, String>{};
    final offer = cartNotifier.appliedOffer;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, title: Text(context.l10n.checkout)),
      body: SafeArea(
        child: (flow.isSubmitting || _isRedirecting)
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _SectionTitle(context.l10n.orderType),
                  Row(
                    children: [
                      Expanded(
                        child: _OrderTypeCard(
                          label: context.l10n.delivery,
                          selected: flow.type == OrderType.delivery,
                          onTap: () => notifier.setType(OrderType.delivery),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _OrderTypeCard(
                          label: context.l10n.branchPickup,
                          selected: flow.type == OrderType.basra,
                          onTap: () => notifier.setType(OrderType.basra),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _SectionTitle(context.l10n.personalInformation)),
                      if (!isLogged)
                        GestureDetector(
                          onTap: () => showAuthSheet(context),
                          child: Text.rich(TextSpan(children: [
                            TextSpan(text: '${context.l10n.haveAnAccount} ', style: TextStyle(color: AppColors.gray2)),
                            TextSpan(
                                text: context.l10n.logIn,
                                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                          ])),
                        ),
                    ],
                  ),
                  _TextField(
                    controller: _nameController,
                    label: context.l10n.fullName,
                    hint: context.l10n.enterYourFullName,
                    error: errors['name'],
                    onChanged: notifier.setCustomerName,
                  ),
                  _TextField(
                    controller: _phoneController,
                    label: context.l10n.phoneNumber,
                    hint: context.l10n.phoneNumberPlaceholder,
                    keyboardType: TextInputType.phone,
                    error: errors['phone'],
                    onChanged: notifier.setCustomerPhone,
                  ),
                  _TextField(
                    controller: _emailController,
                    label: context.l10n.emailOptional,
                    hint: context.l10n.emailPlaceholder,
                    keyboardType: TextInputType.emailAddress,
                    error: errors['email'],
                    onChanged: notifier.setCustomerEmail,
                  ),
                  if (!isLogged) ...[
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: AppColors.primary,
                      value: flow.createAccount,
                      onChanged: (v) => notifier.setCreateAccount(v ?? false),
                      title: Text(context.l10n.createAccountWithOrder, style: TextStyle(color: Colors.white)),
                    ),
                    if (flow.createAccount)
                      _TextField(
                        controller: _passwordController,
                        label: context.l10n.password,
                        hint: context.l10n.passwordPlaceholder,
                        obscure: true,
                        error: errors['password'],
                        onChanged: notifier.setPassword,
                      ),
                  ],
                  const SizedBox(height: 8),
                  if (flow.type == OrderType.basra) ...[
                    _dropdownLabel(context.l10n.branchLabel),
                    branchesAsync.when(
                      loading: () => const ShimmerBox(height: 48),
                      error: (_, _) => Text(context.l10n.unexpectedError, style: TextStyle(color: AppColors.gray2)),
                      data: (List<Branch> branches) => WebDropdown<int>(
                        label: null,
                        placeholder: context.l10n.selectBranch,
                        value: flow.branchId,
                        items: [for (final b in branches) DropdownMenuItem(value: b.id, child: Text(b.name))],
                        onChanged: (id) {
                          if (id != null) notifier.setBranch(id);
                        },
                      ),
                    ),
                    _err(errors['branch']),
                  ] else ...[
                    _dropdownLabel(context.l10n.governorate),
                    governoratesAsync.when(
                      loading: () => const ShimmerBox(height: 48),
                      error: (_, _) => Text(context.l10n.unexpectedError, style: TextStyle(color: AppColors.gray2)),
                      data: (List<Governorate> governorates) => WebDropdown<int>(
                        label: null,
                        placeholder: context.l10n.selectGovernorate,
                        value: flow.governorateId,
                        items: [for (final g in governorates) DropdownMenuItem(value: g.id, child: Text(g.name))],
                        onChanged: (id) {
                          if (id != null) notifier.setGovernorate(id);
                        },
                      ),
                    ),
                    _err(errors['governorate']),
                    const SizedBox(height: 12),
                    _TextField(
                      controller: _addressController,
                      label: context.l10n.fullAddress,
                      hint: context.l10n.fullAddressPlaceholder,
                      maxLines: 3,
                      error: errors['address'],
                      onChanged: notifier.setShippingAddress,
                    ),
                  ],
                  const SizedBox(height: 4),
                  _TextField(
                    controller: _notesController,
                    label: context.l10n.notes,
                    hint: context.l10n.notesPlaceholder,
                    maxLines: 2,
                    error: errors['notes'],
                    onChanged: notifier.setNotes,
                  ),
                  const SizedBox(height: 8),
                  _SectionTitle(context.l10n.paymentMethod),
                  paymentMethodsAsync.when(
                    loading: () => const ShimmerBox(height: 56),
                    error: (_, _) => Text(context.l10n.unexpectedError, style: TextStyle(color: AppColors.gray2)),
                    data: (methods) => methods.isEmpty
                        ? Text(context.l10n.noPaymentMethodsAvailable, style: TextStyle(color: AppColors.gray2))
                        : Column(
                            children: [
                              for (final method in methods)
                                _PaymentMethodCard(
                                  method: method,
                                  selected: flow.paymentMethod == method.driver,
                                  onTap: () => notifier.setPaymentMethod(method.driver),
                                ),
                            ],
                          ),
                  ),
                  _err(errors['payment']),
                  const SizedBox(height: 20),
                  if (cart != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.gray3,
                        borderRadius: AppRadii.radiusXl,
                        border: const Border(top: BorderSide(color: AppColors.primary, width: 3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.l10n.orderSummary,
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 12),
                          for (final item in cart.items)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: InkWell(
                                onTap: () => context.push('/product/${item.product.id}'),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: AppNetworkImage(
                                        url: item.product.primary_image ??
                                            (item.product.images.isNotEmpty ? item.product.images.first : null),
                                        width: 62,
                                        height: 62,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(item.product.name,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                                    ),
                                    Text(formatIqd(item.product.effective_price),
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                            ),
                          const Divider(color: Color(0x33FFFFFF)),
                          PriceBreakdown(
                            subtotal: cart.subtotal,
                            discount: offer?.discount ?? 0,
                            discountPercent: offer?.discount_percent,
                            total: (cart.subtotal - (offer?.discount ?? 0)).clamp(0, double.infinity),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _placeOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: AppRadii.radiusLg),
                    ),
                    child: Text(context.l10n.confirmOrder, style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(height: 8),
                  Text(context.l10n.confirmOrderDisclaimer,
                      textAlign: TextAlign.center, style: TextStyle(color: AppColors.gray2, fontSize: 12)),
                  const SizedBox(height: 24),
                ],
              ),
      ),
    );
  }

  Widget _dropdownLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
      );

  Widget _err(String? text) => text == null
      ? const SizedBox.shrink()
      : Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(text, style: const TextStyle(color: AppColors.error, fontSize: 12)),
        );
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
  const _TextField({
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType,
    this.maxLines = 1,
    this.onChanged,
    this.error,
    this.obscure = false,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final String? error;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          maxLines: maxLines,
          obscureText: obscure,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.gray2),
            errorText: error,
            filled: true,
            fillColor: AppColors.gray3,
            border: OutlineInputBorder(borderRadius: AppRadii.radiusLg, borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 12),
      ],
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
