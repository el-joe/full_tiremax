import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
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
      SnackBar(content: Text(error ?? offer?.offer.title ?? 'Offer applied.')),
    );
  }

  Future<void> _clearCart() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.gray3,
        title: const Text('Clear cart?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'This will remove all items from your cart.',
          style: TextStyle(color: AppColors.gray2),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Clear', style: TextStyle(color: AppColors.error)),
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
        title: const Text('Shopping Cart'),
        actions: [
          if ((cartAsync.value?.items.isNotEmpty ?? false))
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Clear cart',
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
                  child: Text('Could not load your cart.', style: TextStyle(color: AppColors.gray2)),
                ),
              ],
            ),
            data: (cart) {
              if (cart.items.isEmpty) {
                return ListView(
                  children: const [
                    SizedBox(height: 120),
                    Icon(Icons.shopping_cart_outlined, color: AppColors.gray2, size: 56),
                    SizedBox(height: 16),
                    Center(
                      child: Text('Your cart is empty.', style: TextStyle(color: AppColors.gray2)),
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
                  _PromoCodeField(
                    controller: _promoController,
                    isApplying: _isApplyingOffer,
                    onApply: _applyOffer,
                  ),
                  const SizedBox(height: 16),
                  _SummaryCard(
                    subtotal: cart.subtotal,
                    discount: appliedOffer?.discount,
                    total: appliedOffer?.total ?? cart.subtotal,
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
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.item.unit_price.toStringAsFixed(2),
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _StepperButton(icon: Icons.remove, onPressed: _isUpdating ? null : () => _changeQuantity(-1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text('${widget.item.quantity}', style: const TextStyle(color: Colors.white)),
                      ),
                      _StepperButton(icon: Icons.add, onPressed: _isUpdating ? null : () => _changeQuantity(1)),
                      const Spacer(),
                      Text(
                        widget.item.total.toStringAsFixed(2),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 18, color: AppColors.gray2),
              onPressed: _isUpdating ? null : _remove,
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
      borderRadius: AppRadii.radiusSm,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(color: AppColors.background, borderRadius: AppRadii.radiusSm),
        child: Icon(icon, size: 16, color: Colors.white),
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
              hintText: 'Promo code',
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
              : const Text('Apply'),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.onCheckout,
  });

  final num subtotal;
  final num? discount;
  final num total;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.gray3, borderRadius: AppRadii.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _row('Subtotal', subtotal),
          if (discount != null && discount! > 0) _row('Discount', -discount!, color: AppColors.green),
          const Divider(color: AppColors.background),
          _row('Total', total, bold: true),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onCheckout,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: AppRadii.radiusLg),
            ),
            child: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, num value, {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: color ?? AppColors.gray2, fontWeight: bold ? FontWeight.w800 : FontWeight.w400)),
          Text(
            value.toStringAsFixed(2),
            style: TextStyle(
              color: color ?? (bold ? AppColors.primary : Colors.white),
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
