import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/format.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/widgets/widgets.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';

/// The shopping cart: swipe-to-remove compact rows with quantity steppers, a
/// collapsible offer code, price summary and a sticky total + checkout bar.
/// Mirrors `frontend/app/[locale]/cart/page.tsx` (`ItemsList` + `CartSummary`).
class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final _promoController = TextEditingController();
  bool _isApplyingOffer = false;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  Future<void> _applyOffer() async {
    final code = _promoController.text.trim();
    if (code.isEmpty) return;
    setState(() => _isApplyingOffer = true);
    final error = await ref.read(cartProvider.notifier).applyOffer(code);
    if (!mounted) return;
    setState(() => _isApplyingOffer = false);
    final offer = ref.read(cartProvider.notifier).appliedOffer;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error ?? offer?.offer.title ?? context.l10n.offerApplied),
      ),
    );
  }

  Future<void> _clearCart() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.clearCartQuestion),
        content: Text(ctx.l10n.clearCartBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(ctx.l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              ctx.l10n.clear,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(cartProvider.notifier).clearCart();
  }

  @override
  Widget build(BuildContext context) {
    final cartAsync = ref.watch(cartProvider);
    final cart = cartAsync.value;
    final hasItems = cart != null && cart.items.isNotEmpty;
    final notifier = ref.read(cartProvider.notifier);
    final offer = notifier.appliedOffer;
    final total = cart == null
        ? 0
        : (cart.subtotal - (offer?.discount ?? 0)).clamp(0, double.infinity);

    return AppScaffold(
      title: context.l10n.shoppingCart,
      actions: [
        if (hasItems)
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: context.l10n.clearCartTooltip,
            onPressed: _clearCart,
          ),
      ],
      bottomBar: hasItems
          ? StickyBottomBar(
              label: context.l10n.cartTotal,
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
                label: context.l10n.proceedToCheckout,
                onPressed: () => context.push('/checkout'),
              ),
            )
          : null,
      body: RefreshIndicator(
        onRefresh: () => ref.read(cartProvider.notifier).refresh(),
        child: cartAsync.when(
          loading: () => const SkeletonList(itemCount: 4, itemHeight: 96),
          error: (err, _) => ListView(
            children: [
              SizedBox(
                height: 400,
                child: ErrorState(
                  message: context.l10n.unexpectedError,
                  onRetry: () => ref.read(cartProvider.notifier).refresh(),
                ),
              ),
            ],
          ),
          data: (cart) {
            if (cart.items.isEmpty) {
              return ListView(
                children: [
                  SizedBox(
                    height: 400,
                    child: EmptyState(
                      icon: Icons.shopping_cart_outlined,
                      title: context.l10n.emptyCart,
                      actionLabel: context.l10n.goToShopping,
                      onAction: () => context.go('/store'),
                    ),
                  ),
                ],
              );
            }
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.gutter),
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Text(
                    context.l10n.itemsCount(cart.items.length),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.gray2,
                    ),
                  ),
                ),
                for (final item in cart.items) ...[
                  _CartItemTile(key: ValueKey(item.id), item: item),
                  const SizedBox(height: AppSpacing.md),
                ],
                _OfferSection(
                  controller: _promoController,
                  isApplying: _isApplyingOffer,
                  onApply: _applyOffer,
                  offerTitle: offer?.offer.title,
                  discount: offer?.discount,
                  error: offer == null ? notifier.applyOfferError : null,
                ),
                const SizedBox(height: AppSpacing.md),
                AppCard(
                  child: PriceSummary(
                    subtotal: cart.subtotal,
                    discount: offer?.discount ?? 0,
                    discountPercent: offer?.discount_percent,
                    total: total,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OfferSection extends StatelessWidget {
  const _OfferSection({
    required this.controller,
    required this.isApplying,
    required this.onApply,
    required this.offerTitle,
    required this.discount,
    required this.error,
  });

  final TextEditingController controller;
  final bool isApplying;
  final VoidCallback onApply;
  final String? offerTitle;
  final num? discount;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: offerTitle != null || error != null,
          tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          childrenPadding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          leading: const Icon(
            Icons.local_offer_outlined,
            color: AppColors.primary,
          ),
          title: Text(
            offerTitle != null
                ? '${context.l10n.offerApplied}: $offerTitle'
                : context.l10n.haveOfferCode,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.foregroundLight,
            ),
          ),
          subtitle: discount != null && discount! > 0
              ? Text(
                  '-${formatIqd(discount!)}',
                  style: const TextStyle(
                    color: AppColors.green,
                    fontWeight: FontWeight.w700,
                  ),
                )
              : null,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppTextField(
                    label: context.l10n.enterOfferCode,
                    controller: controller,
                    errorText: error,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => onApply(),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                SizedBox(
                  width: 96,
                  height: AppSpacing.buttonHeight,
                  child: SecondaryButton(
                    label: context.l10n.apply,
                    loading: isApplying,
                    onPressed: isApplying ? null : onApply,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItemTile extends ConsumerStatefulWidget {
  const _CartItemTile({super.key, required this.item});

  final CartItem item;

  @override
  ConsumerState<_CartItemTile> createState() => _CartItemTileState();
}

class _CartItemTileState extends ConsumerState<_CartItemTile> {
  bool _isUpdating = false;

  Future<void> _changeQuantity(int delta) async {
    final newQuantity = widget.item.quantity + delta;
    if (newQuantity < 1) return;
    HapticFeedback.selectionClick();
    setState(() => _isUpdating = true);
    await ref
        .read(cartProvider.notifier)
        .updateQuantity(widget.item.id, newQuantity);
    if (mounted) setState(() => _isUpdating = false);
  }

  Future<void> _remove() async {
    final item = widget.item;
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final notifier = ref.read(cartProvider.notifier);
    HapticFeedback.mediumImpact();
    setState(() => _isUpdating = true);
    await notifier.removeItem(item.id);
    if (mounted) setState(() => _isUpdating = false);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.itemRemoved),
          action: SnackBarAction(
            label: l10n.undo,
            onPressed: () =>
                notifier.addProduct(item.product.id, item.quantity),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final product = item.product;
    final image =
        product.primary_image ??
        (product.images.isNotEmpty ? product.images.first : null);

    return Dismissible(
      key: ValueKey('dismiss_${item.id}'),
      confirmDismiss: (_) async {
        await _remove();
        return false;
      },
      background: const _SwipeBackground(
        alignment: AlignmentDirectional.centerStart,
      ),
      secondaryBackground: const _SwipeBackground(
        alignment: AlignmentDirectional.centerEnd,
      ),
      child: Opacity(
        opacity: _isUpdating ? 0.6 : 1,
        child: AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          onTap: () => context.push('/product/${product.id}'),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AppNetworkImage(url: image, width: 72, height: 72),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.brand.name.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.gray2,
                      ),
                    ),
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.foregroundLight,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        _QtyStepper(
                          quantity: item.quantity,
                          onMinus: _isUpdating
                              ? null
                              : (item.quantity <= 1
                                    ? _remove
                                    : () => _changeQuantity(-1)),
                          onPlus: _isUpdating ? null : () => _changeQuantity(1),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            formatIqd(product.effective_price),
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.foregroundLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SwipeBackground extends StatelessWidget {
  const _SwipeBackground({required this.alignment});

  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.delete_outline, color: Colors.white),
    );
  }
}

class _QtyStepper extends StatelessWidget {
  const _QtyStepper({
    required this.quantity,
    required this.onMinus,
    required this.onPlus,
  });

  final int quantity;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.page,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _btn(quantity <= 1 ? Icons.delete_outline : Icons.remove, onMinus),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 24),
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.foregroundLight,
              ),
            ),
          ),
          _btn(Icons.add, onPlus),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, VoidCallback? onTap) => InkResponse(
    onTap: onTap,
    radius: 22,
    child: SizedBox(
      width: AppSpacing.minTap - 4,
      height: AppSpacing.minTap - 4,
      child: Icon(
        icon,
        size: 18,
        color: onTap == null ? AppColors.gray2 : AppColors.foregroundLight,
      ),
    ),
  );
}
