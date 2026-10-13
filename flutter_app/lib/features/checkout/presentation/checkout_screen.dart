import '../../../l10n/l10n.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/models/branch.dart';
import '../../../core/models/governorate.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/format.dart';
import '../../../shared/widgets/widgets.dart';
import '../../../shared/widgets/web_dropdown.dart';
import '../../auth/presentation/auth_sheet.dart';
import '../../auth/providers/auth_provider.dart';
import '../../cart/providers/cart_provider.dart';
import 'package:go_router/go_router.dart';
import '../data/checkout_repository.dart';
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
        await ref
            .read(authProvider.notifier)
            .register(
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                msg == null
                    ? context.l10n.accountNotCreated
                    : '${context.l10n.accountNotCreated} $msg',
              ),
            ),
          );
        }
      }
    }
    if (!mounted) return;

    setState(() => _isRedirecting = true);
    try {
      final payment = await ref
          .read(checkoutRepositoryProvider)
          .fetchPayment(orderId);
      if (payment != null &&
          payment.gateway.driver == 'paymob' &&
          payment.redirect_url != null) {
        final uri = Uri.tryParse(payment.redirect_url!);
        if (uri != null) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }
    } catch (_) {
      // Never block the confirmation screen on the payment redirect.
    } finally {
      if (mounted) setState(() => _isRedirecting = false);
    }

    if (!mounted) return;
    context.go('/order-confirmation/$orderId');
  }

  @override
  Widget build(BuildContext context) {
    final flow = ref.watch(checkoutFlowProvider);
    final notifier = ref.read(checkoutFlowProvider.notifier);
    final governoratesAsync = ref.watch(governoratesProvider);
    final branchesAsync = ref.watch(checkoutBranchesProvider);
    final paymentMethodsAsync = ref.watch(paymentMethodsProvider);
    final cart = ref.watch(cartProvider).value;
    final isLogged = ref.watch(isLoggedInProvider);
    final errors = _showErrors ? flow.validate() : const <String, String>{};
    final offer = ref.read(cartProvider.notifier).appliedOffer;
    final busy = flow.isSubmitting || _isRedirecting;
    final total = cart == null
        ? 0
        : (cart.subtotal - (offer?.discount ?? 0)).clamp(0, double.infinity);
    final l = context.l10n;

    return AppScaffold(
      title: l.checkout,
      bottomBar: StickyBottomBar(
        label: l.cartTotal,
        value: Text(
          formatIqd(total),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.foregroundLight,
          ),
        ),
        action: PrimaryButton(
          label: l.confirmOrder,
          loading: busy,
          onPressed: busy ? null : _placeOrder,
        ),
      ),
      body: IgnorePointer(
        ignoring: busy,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(AppSpacing.gutter),
          children: [
            _Title(l.orderType),
            Row(
              children: [
                Expanded(
                  child: _OrderTypeCard(
                    icon: Icons.local_shipping_outlined,
                    label: l.delivery,
                    selected: flow.type == OrderType.delivery,
                    onTap: () => notifier.setType(OrderType.delivery),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _OrderTypeCard(
                    icon: Icons.storefront_outlined,
                    label: l.branchPickup,
                    selected: flow.type == OrderType.basra,
                    onTap: () => notifier.setType(OrderType.basra),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _Title(l.personalInformation),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isLogged)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: InkWell(
                        onTap: () => showAuthSheet(context),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: AppSpacing.minTap,
                          ),
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${l.haveAnAccount} ',
                                    style: const TextStyle(
                                      color: AppColors.gray2,
                                    ),
                                  ),
                                  TextSpan(
                                    text: l.logIn,
                                    style: const TextStyle(
                                      color: AppColors.onPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  _field(
                    _nameController,
                    l.fullName,
                    errors['name'],
                    notifier.setCustomerName,
                  ),
                  _field(
                    _phoneController,
                    l.phoneNumber,
                    errors['phone'],
                    notifier.setCustomerPhone,
                    type: TextInputType.phone,
                  ),
                  _field(
                    _emailController,
                    l.emailOptional,
                    errors['email'],
                    notifier.setCustomerEmail,
                    type: TextInputType.emailAddress,
                  ),
                  if (!isLogged) ...[
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: AppColors.primary,
                      checkColor: AppColors.onPrimary,
                      value: flow.createAccount,
                      onChanged: (v) => notifier.setCreateAccount(v ?? false),
                      title: Text(
                        l.createAccountWithOrder,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    if (flow.createAccount)
                      _field(
                        _passwordController,
                        l.password,
                        errors['password'],
                        notifier.setPassword,
                        obscure: true,
                      ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _Title(
              flow.type == OrderType.basra ? l.branchLabel : l.deliveryAddress,
            ),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (flow.type == OrderType.basra) ...[
                    branchesAsync.when(
                      loading: () => const ShimmerBox(height: 48),
                      error: (_, _) => ErrorState(
                        message: l.unexpectedError,
                        onRetry: () => ref.invalidate(checkoutBranchesProvider),
                      ),
                      data: (List<Branch> branches) => WebDropdown<int>(
                        label: l.branchLabel,
                        placeholder: l.selectBranch,
                        value: flow.branchId,
                        items: [
                          for (final b in branches)
                            DropdownMenuItem(
                              value: b.id,
                              child: Text(
                                b.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                        onChanged: (id) {
                          if (id != null) notifier.setBranch(id);
                        },
                      ),
                    ),
                    _err(errors['branch']),
                  ] else ...[
                    governoratesAsync.when(
                      loading: () => const ShimmerBox(height: 48),
                      error: (_, _) => ErrorState(
                        message: l.unexpectedError,
                        onRetry: () => ref.invalidate(governoratesProvider),
                      ),
                      data: (List<Governorate> governorates) =>
                          WebDropdown<int>(
                            label: l.governorate,
                            placeholder: l.selectGovernorate,
                            value: flow.governorateId,
                            items: [
                              for (final g in governorates)
                                DropdownMenuItem(
                                  value: g.id,
                                  child: Text(
                                    g.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                            onChanged: (id) {
                              if (id != null) notifier.setGovernorate(id);
                            },
                          ),
                    ),
                    _err(errors['governorate']),
                    const SizedBox(height: AppSpacing.md),
                    _field(
                      _addressController,
                      l.fullAddress,
                      errors['address'],
                      notifier.setShippingAddress,
                      lines: 3,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    l.notes,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.foregroundLight,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _field(
                    _notesController,
                    l.notesPlaceholder,
                    errors['notes'],
                    notifier.setNotes,
                    lines: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _Title(l.paymentMethod),
            paymentMethodsAsync.when(
              loading: () => const ShimmerBox(height: 56),
              error: (_, _) => ErrorState(
                message: l.unexpectedError,
                onRetry: () => ref.invalidate(paymentMethodsProvider),
              ),
              data: (methods) => methods.isEmpty
                  ? EmptyState(
                      icon: Icons.payments_outlined,
                      title: l.noPaymentMethodsAvailable,
                    )
                  : Column(
                      children: [
                        for (final method in methods)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.sm,
                            ),
                            child: SelectableCard(
                              selected: flow.paymentMethod == method.driver,
                              onTap: () =>
                                  notifier.setPaymentMethod(method.driver),
                              child: Text(
                                method.display_name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.foregroundLight,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
            _err(errors['payment']),
            const SizedBox(height: AppSpacing.lg),
            if (cart != null)
              AppCard(
                padding: EdgeInsets.zero,
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    childrenPadding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      0,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    title: Text(
                      l.orderSummary,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.foregroundLight,
                      ),
                    ),
                    subtitle: Text(
                      l.itemsCount(cart.items.length),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.gray2,
                      ),
                    ),
                    children: [
                      for (final item in cart.items)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: AppNetworkImage(
                                  url:
                                      item.product.primary_image ??
                                      (item.product.images.isNotEmpty
                                          ? item.product.images.first
                                          : null),
                                  width: 48,
                                  height: 48,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Text(
                                  '${item.quantity} x ${item.product.name}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.foregroundLight,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                formatIqd(
                                  item.product.effective_price * item.quantity,
                                ),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.foregroundLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const Divider(color: AppColors.gray),
                      PriceSummary(
                        subtotal: cart.subtotal,
                        discount: offer?.discount ?? 0,
                        discountPercent: offer?.discount_percent,
                        total: total,
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l.confirmOrderDisclaimer,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.gray2, fontSize: 12),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String label,
    String? error,
    ValueChanged<String> onChanged, {
    TextInputType? type,
    int lines = 1,
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppTextField(
        label: label,
        controller: c,
        errorText: error,
        keyboardType: type,
        maxLines: lines,
        obscureText: obscure,
        onChanged: onChanged,
      ),
    );
  }

  Widget _err(String? text) => text == null
      ? const SizedBox.shrink()
      : Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xs),
          child: Text(
            text,
            style: const TextStyle(color: AppColors.error, fontSize: 12),
          ),
        );
}

class _OrderTypeCard extends StatelessWidget {
  const _OrderTypeCard({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? AppColors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.sm,
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? AppColors.primary : AppColors.gray2),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: AppColors.foregroundLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.foregroundLight,
      ),
    ),
  );
}
