import '../../../l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/format.dart';
import '../../orders/presentation/order_widgets.dart' show PriceBreakdown;
import '../../../core/theme/app_radii.dart';
import '../../../shared/widgets/shimmer_box.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';

/// The shopping cart screen: item list with quantity steppers, promo code
/// input, subtotal/total summary, and a Checkout CTA. Mirrors
/// `frontend/app/[locale]/cart/page.tsx` (`ItemsList` + `CartSummary`).
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
    final notifier = ref.read(cartProvider.notifier);
    final offer = notifier.appliedOffer;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error ?? offer?.offer.title ?? context.l10n.offerApplied)),
    );
  }

  Future<void> _clearCart() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.gray3,
        title: Text(context.l10n.clearCartQuestion, style: TextStyle(color: Colors.white)),
        content: Text(
          context.l10n.clearCartBody,
          style: TextStyle(color: AppColors.gray2),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text(context.l10n.commonCancel)),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(context.l10n.clear, style: TextStyle(color: AppColors.error)),
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(context.l10n.shoppingCart),
        actions: [
          if ((cartAsync.value?.items.isNotEmpty ?? false))
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: context.l10n.clearCartTooltip,
              onPressed: _clearCart,
            ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(cartProvider.notifier).refresh(),
          child: cartAsync.when(
            loading: () => const _CartLoadingSkeleton(),
            error: (err, _) => ListView(
              children: [
                const SizedBox(height: 120),
                Center(
                  child: Text(context.l10n.unexpectedError, style: TextStyle(color: AppColors.gray2)),
                ),
              ],
            ),
            data: (cart) {
              if (cart.items.isEmpty) {
                return ListView(
                  children: [
                    const SizedBox(height: 120),
                    Center(
                      child: Text(context.l10n.emptyCart,
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                          shape: RoundedRectangleBorder(borderRadius: AppRadii.radiusLg),
                        ),
                        onPressed: () => context.go('/store'),
                        child: Text(context.l10n.goToShopping),
                      ),
                    ),
                  ],
                );
              }
              final notifier = ref.read(cartProvider.notifier);
              final appliedOffer = notifier.appliedOffer;
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  for (final item in cart.items) ...[
                    _CartItemTile(item: item),
                    const SizedBox(height: 12),
                  ],
                  const SizedBox(height: 8),
                  _SummaryCard(
                    subtotal: cart.subtotal,
                    discount: appliedOffer?.discount,
                    discountPercent: appliedOffer?.discount_percent,
                    total: (cart.subtotal - (appliedOffer?.discount ?? 0)).clamp(0, double.infinity),
                    offerTitle: appliedOffer?.offer.title,
                    offerError: appliedOffer == null ? notifier.applyOfferError : null,
                    promo: _PromoCodeField(
                      controller: _promoController,
                      isApplying: _isApplyingOffer,
                      onApply: _applyOffer,
                    ),
                    onCheckout: () => context.push('/checkout'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CartLoadingSkeleton extends StatelessWidget {
  const _CartLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: List.generate(
        3,
        (_) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ShimmerBox(height: 96, borderRadius: AppRadii.radiusLg),
        ),
      ),
    );
  }
}

class _CartItemTile extends ConsumerStatefulWidget {
  const _CartItemTile({required this.item});

  final CartItem item;

  @override
  ConsumerState<_CartItemTile> createState() => _CartItemTileState();
}

class _CartItemTileState extends ConsumerState<_CartItemTile> {
  bool _isUpdating = false;

  Future<void> _changeQuantity(int delta) async {
    final newQuantity = widget.item.quantity + delta;
    if (newQuantity < 1) return;
    setState(() => _isUpdating = true);
    await ref.read(cartProvider.notifier).updateQuantity(widget.item.id, newQuantity);
    if (mounted) setState(() => _isUpdating = false);
  }

  Future<void> _remove() async {
    setState(() => _isUpdating = true);
    await ref.read(cartProvider.notifier).removeItem(widget.item.id);
    if (mounted) setState(() => _isUpdating = false);
  }

  Widget _badge(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12)),
        child: Text(text.toUpperCase(),
            style: const TextStyle(color: AppColors.gray2, fontSize: 10, fontWeight: FontWeight.w700)),
      );

  @override
  Widget build(BuildContext context) {
    final product = widget.item.product;
    final image = product.primary_image ?? (product.images.isNotEmpty ? product.images.first : null);

    return Opacity(
      opacity: _isUpdating ? 0.6 : 1,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.gray3, borderRadius: AppRadii.radiusLg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: AppRadii.radiusMd,
              child: AppNetworkImage(url: image, width: 64, height: 64),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _badge(product.brand.name),
                      InkWell(
                        onTap: _isUpdating ? null : _remove,
                        child: const Padding(
                          padding: EdgeInsets.all(2),
                          child: Icon(Icons.delete_outline, size: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () => context.push('/product/${product.id}'),
                    child: Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Text(product.short_description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.gray2, fontSize: 12)),
                  const SizedBox(height: 4),
                  _badge(product.brand.country),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Web pill control: primary border, trash instead of
                      // minus when quantity is 1.
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primary),
                          borderRadius: AppRadii.radiusFull,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _StepperButton(
                              icon: widget.item.quantity <= 1 ? Icons.delete_outline : Icons.remove,
                              onPressed: _isUpdating
                                  ? null
                                  : (widget.item.quantity <= 1 ? _remove : () => _changeQuantity(-1)),
                            ),
                            ConstrainedBox(
                              constraints: const BoxConstraints(minWidth: 28),
                              child: Text('${widget.item.quantity}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            ),
                            _StepperButton(icon: Icons.add, onPressed: _isUpdating ? null : () => _changeQuantity(1)),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Text(
                          formatIqd(product.effective_price),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
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
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      customBorder: const CircleBorder(),
      child: SizedBox(
        width: 30,
        height: 30,
        child: Icon(icon, size: 16, color: onPressed == null ? AppColors.gray2 : Colors.white),
      ),
    );
  }
}

class _PromoCodeField extends StatelessWidget {
  const _PromoCodeField({required this.controller, required this.isApplying, required this.onApply});

  final TextEditingController controller;
  final bool isApplying;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: context.l10n.enterOfferCode,
              hintStyle: const TextStyle(color: AppColors.gray2),
              filled: true,
              fillColor: AppColors.gray3,
              border: OutlineInputBorder(borderRadius: AppRadii.radiusLg, borderSide: BorderSide.none),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: isApplying ? null : onApply,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            shape: RoundedRectangleBorder(borderRadius: AppRadii.radiusLg),
          ),
          child: isApplying
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onPrimary),
                )
              : Text(context.l10n.apply),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.subtotal,
    required this.discount,
    required this.discountPercent,
    required this.total,
    required this.offerTitle,
    required this.offerError,
    required this.promo,
    required this.onCheckout,
  });

  final num subtotal;
  final num? discount;
  final num? discountPercent;
  final num total;
  final String? offerTitle;
  final String? offerError;
  final Widget promo;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.gray3,
        borderRadius: AppRadii.radiusXl,
        border: const Border(top: BorderSide(color: AppColors.primary, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(context.l10n.orderSummary,
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          promo,
          if (offerTitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text('${context.l10n.offerApplied}: $offerTitle (-${formatIqd(discount ?? 0)})',
                  style: const TextStyle(color: AppColors.green, fontWeight: FontWeight.w700, fontSize: 14)),
            ),
          if (offerError != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(offerError!, style: const TextStyle(color: Colors.red, fontSize: 14)),
            ),
          const SizedBox(height: 16),
          PriceBreakdown(
            subtotal: subtotal,
            discount: discount ?? 0,
            discountPercent: discountPercent,
            total: total,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onCheckout,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: AppRadii.radiusLg),
            ),
            child: Text(context.l10n.proceedToCheckout, style: TextStyle(fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 20),
          _guarantee(Icons.verified_user_outlined, context.l10n.flexible72HourReturnGuarantee,
              context.l10n.easyReturnsAndExchangesDescription),
          const SizedBox(height: 16),
          _guarantee(Icons.handshake_outlined, context.l10n.sixMonthAfterSalesSupport, context.l10n.afterSalesSupportDescription),
        ],
      ),
    );
  }

  Widget _guarantee(IconData icon, String title, String desc) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
                Text(desc, style: const TextStyle(color: AppColors.gray2, fontSize: 11)),
              ],
            ),
          ),
        ],
      );
}
