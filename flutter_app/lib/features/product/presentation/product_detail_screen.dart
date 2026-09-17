import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/utils/protected_action.dart';
import '../../../shared/widgets/product_card.dart';
import '../../../shared/widgets/shimmer_box.dart';
import '../../favorites/providers/favorites_provider.dart';
import '../data/product_repository.dart';
import '../models/product.dart';

/// Product detail screen: gallery, spec, price/stock, add-to-cart,
/// favorite toggle, reviews + write-review form, related products.
/// Mirrors `frontend/app/[locale]/store/[slug]/**`.
class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailProvider(productId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background),
      body: SafeArea(
        child: productAsync.when(
          data: (product) => _ProductDetailBody(product: product),
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: ShimmerBox(width: double.infinity, height: 300),
          ),
          error: (error, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$error', style: const TextStyle(color: AppColors.gray2)),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => ref.invalidate(productDetailProvider(productId)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductDetailBody extends ConsumerStatefulWidget {
  const _ProductDetailBody({required this.product});

  final Product product;

  @override
  ConsumerState<_ProductDetailBody> createState() => _ProductDetailBodyState();
}

class _ProductDetailBodyState extends ConsumerState<_ProductDetailBody> {
  int _activeImage = 0;
  int _quantity = 1;
  bool _addingToCart = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final images = product.images.isNotEmpty
        ? product.images.map((e) => e.url).toList()
        : (product.primary_image != null ? [product.primary_image!] : <String>[]);
    final isFavorited = ref.watch(favoritesProvider).contains(product.id);

    return ListView(
      padding: const EdgeInsets.only(bottom: 40),
      children: [
        _Gallery(images: images, activeIndex: _activeImage, onSelect: (i) => setState(() => _activeImage = i)),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(product.brand.name, style: const TextStyle(color: AppColors.gray2)),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: isFavorited ? AppColors.primary : Colors.white,
                    ),
                    onPressed: () => requireAuth(
                      context,
                      ref,
                      () => ref.read(favoritesProvider.notifier).toggle(product.id),
                    ),
                  ),
                ],
              ),
              Text(product.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              if (product.badges.isNotEmpty)
                Wrap(
                  spacing: 6,
                  children: product.badges
                      .map((b) => Chip(
                            label: Text(b, style: const TextStyle(fontSize: 11)),
                            backgroundColor: AppColors.gray3,
                            labelStyle: const TextStyle(color: Colors.white),
                          ))
                      .toList(),
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '${product.effective_price.toStringAsFixed(0)} EGP',
                    style: const TextStyle(color: AppColors.primary, fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                  if (product.has_discount) ...[
                    const SizedBox(width: 10),
                    Text(
                      '${product.price.toStringAsFixed(0)} EGP',
                      style: const TextStyle(color: AppColors.gray2, decoration: TextDecoration.lineThrough),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                product.in_stock ? 'In stock (${product.stock})' : 'Out of stock',
                style: TextStyle(color: product.in_stock ? AppColors.green : AppColors.error, fontSize: 13),
              ),
              const SizedBox(height: 16),
              _SpecSection(product: product),
              const SizedBox(height: 20),
              Row(
                children: [
                  _QuantityStepper(
                    quantity: _quantity,
                    onChanged: (q) => setState(() => _quantity = q),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        shape: RoundedRectangleBorder(borderRadius: AppRadii.radiusFull),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: (!product.in_stock || _addingToCart)
                          ? null
                          : () => requireAuth(context, ref, _addToCart),
                      child: _addingToCart
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onPrimary),
                            )
                          : const Text('Add to Cart'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(color: AppColors.gray3),
        _ReviewsSection(productId: product.id),
        const Divider(color: AppColors.gray3),
        _RelatedSection(productId: product.id),
      ],
    );
  }

  Future<void> _addToCart() async {
    setState(() => _addingToCart = true);
    try {
      await ref.read(productRepositoryProvider).addToCart(
            productId: widget.product.id,
            quantity: _quantity,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to cart.')),
        );
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _addingToCart = false);
    }
  }
}

class _Gallery extends StatelessWidget {
  const _Gallery({required this.images, required this.activeIndex, required this.onSelect});

  final List<String> images;
  final int activeIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const AspectRatio(aspectRatio: 1, child: AppNetworkImage(url: null));
    }
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.1,
          child: AppNetworkImage(url: images[activeIndex.clamp(0, images.length - 1)], width: double.infinity, height: double.infinity),
        ),
        if (images.length > 1)
          SizedBox(
            height: 64,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final selected = index == activeIndex;
                return GestureDetector(
                  onTap: () => onSelect(index),
                  child: Container(
                    width: 56,
                    decoration: BoxDecoration(
                      borderRadius: AppRadii.radiusMd,
                      border: Border.all(
                        color: selected ? AppColors.primary : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: selected
                          ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.6), blurRadius: 8)]
                          : null,
                    ),
                    child: AppNetworkImage(url: images[index], borderRadius: AppRadii.radiusMd),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _SpecSection extends StatelessWidget {
  const _SpecSection({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final rows = <MapEntry<String, String>>[];
    final tire = product.tire_spec;
    final battery = product.battery_spec;
    if (tire != null) {
      rows.addAll([
        MapEntry('Size', tire.size_string),
        MapEntry('Load Index', tire.load_index),
        MapEntry('Speed Rating', tire.speed_rating),
        MapEntry('Usage', tire.usage_type),
        MapEntry('Runflat', tire.runflat ? 'Yes' : 'No'),
      ]);
    }
    if (battery != null) {
      rows.addAll([
        MapEntry('Voltage', '${battery.voltage}V'),
        MapEntry('Capacity', '${battery.ampere_hour}Ah'),
        MapEntry('CCA', '${battery.cca}'),
        MapEntry('Type', battery.battery_type),
        MapEntry('Terminal', battery.terminal_position),
      ]);
    }
    if (rows.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.gray3, borderRadius: AppRadii.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Specifications', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          for (final row in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(row.key, style: const TextStyle(color: AppColors.gray2, fontSize: 13)),
                  Text(row.value, style: const TextStyle(color: Colors.white, fontSize: 13)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({required this.quantity, required this.onChanged});

  final int quantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.gray3, borderRadius: AppRadii.radiusFull),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.remove, size: 18), onPressed: quantity > 1 ? () => onChanged(quantity - 1) : null),
          Text('$quantity', style: const TextStyle(color: Colors.white)),
          IconButton(icon: const Icon(Icons.add, size: 18), onPressed: () => onChanged(quantity + 1)),
        ],
      ),
    );
  }
}

class _ReviewsSection extends ConsumerStatefulWidget {
  const _ReviewsSection({required this.productId});

  final int productId;

  @override
  ConsumerState<_ReviewsSection> createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends ConsumerState<_ReviewsSection> {
  final _commentController = TextEditingController();
  num _rating = 5;
  bool _submitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_commentController.text.trim().isEmpty) return;
    setState(() => _submitting = true);
    try {
      await ref.read(productRepositoryProvider).submitReview(
            widget.productId,
            rating: _rating,
            comment: _commentController.text.trim(),
          );
      _commentController.clear();
      ref.invalidate(productReviewsProvider(widget.productId));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Review submitted.')));
      }
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final reviewsAsync = ref.watch(productReviewsProvider(widget.productId));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Reviews', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          reviewsAsync.when(
            data: (state) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.primary, size: 18),
                    const SizedBox(width: 4),
                    Text('${state.ratingAvg.toStringAsFixed(1)} (${state.ratingCount} reviews)',
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 12),
                if (state.reviews.isEmpty)
                  const Text('No reviews yet.', style: TextStyle(color: AppColors.gray2))
                else
                  for (final review in state.reviews)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: AppColors.gray3, borderRadius: AppRadii.radiusMd),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(review.customer.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                const Spacer(),
                                Row(
                                  children: List.generate(
                                    5,
                                    (i) => Icon(
                                      i < review.rating.round() ? Icons.star : Icons.star_border,
                                      color: AppColors.primary,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(review.comment, style: const TextStyle(color: AppColors.gray2, fontSize: 13)),
                          ],
                        ),
                      ),
                    ),
              ],
            ),
            loading: () => const ShimmerBox(width: double.infinity, height: 80),
            error: (error, _) => Text('$error', style: const TextStyle(color: AppColors.gray2)),
          ),
          const SizedBox(height: 16),
          const Text('Write a review', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: List.generate(
              5,
              (i) => IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  i < _rating ? Icons.star : Icons.star_border,
                  color: AppColors.primary,
                ),
                onPressed: () => setState(() => _rating = i + 1),
              ),
            ),
          ),
          TextField(
            controller: _commentController,
            style: const TextStyle(color: Colors.white),
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Share your thoughts…',
              filled: true,
              fillColor: AppColors.gray3,
              border: OutlineInputBorder(borderRadius: AppRadii.radiusMd, borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: AppRadii.radiusFull),
              ),
              onPressed: _submitting
                  ? null
                  : () => requireAuth(context, ref, _submit),
              child: _submitting
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onPrimary))
                  : const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}

class _RelatedSection extends ConsumerWidget {
  const _RelatedSection({required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relatedAsync = ref.watch(relatedProductsProvider(productId));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Related Products', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 10),
          relatedAsync.when(
            data: (products) {
              if (products.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('No related products.', style: TextStyle(color: AppColors.gray2)),
                );
              }
              return SizedBox(
                height: 272,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: products.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) => ProductCard(product: products[index]),
                ),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ShimmerBox(width: double.infinity, height: 200),
            ),
            error: (error, _) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('$error', style: const TextStyle(color: AppColors.gray2)),
            ),
          ),
        ],
      ),
    );
  }
}
