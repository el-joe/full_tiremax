import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/utils/protected_action.dart';
import '../../features/favorites/providers/favorites_provider.dart';
import '../../features/product/models/product.dart';
import 'shimmer_box.dart';

/// A product card matching the web's store/home product card: image, brand,
/// name, price (with strikethrough + discount badge when on sale), rating,
/// and a favorite toggle icon.
class ProductCard extends ConsumerWidget {
  const ProductCard({super.key, required this.product, this.width = 170});

  final Product product;
  final double width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorited = ref.watch(favoritesProvider).contains(product.id);
    final image = product.primary_image ??
        (product.images.isNotEmpty ? product.images.first.url : null);

    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: () => context.push('/product/${product.id}'),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.gray3,
            borderRadius: AppRadii.radiusXl,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1.25,
                    child: AppNetworkImage(url: image, width: double.infinity, height: double.infinity),
                  ),
                  if (product.has_discount)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: AppRadii.radiusSm,
                        ),
                        child: Text(
                          '-${(((product.price - product.effective_price) / product.price) * 100).round()}%',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: InkWell(
                      borderRadius: AppRadii.radiusFull,
                      onTap: () => requireAuth(
                        context,
                        ref,
                        () => ref.read(favoritesProvider.notifier).toggle(product.id),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                        child: Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          size: 16,
                          color: isFavorited ? AppColors.primary : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.brand.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.gray2, fontSize: 11),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    if (product.expert_rating != null)
                      Row(
                        children: [
                          const Icon(Icons.star, color: AppColors.primary, size: 14),
                          const SizedBox(width: 2),
                          Text(
                            product.expert_rating!.toStringAsFixed(1),
                            style: const TextStyle(color: AppColors.gray2, fontSize: 11),
                          ),
                        ],
                      ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '${product.effective_price.toStringAsFixed(0)} EGP',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                        ),
                        if (product.has_discount) ...[
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              product.price.toStringAsFixed(0),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.gray2,
                                fontSize: 11,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                        ],
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
