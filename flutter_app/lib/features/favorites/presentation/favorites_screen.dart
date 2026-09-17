import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../shared/widgets/shimmer_box.dart';
import '../models/customer_fav.dart';
import '../providers/favorites_list_provider.dart';

/// GET /favorites grid. Tap a heart to toggle (optimistic, rolled back on
/// failure), tap a card to go to product detail. Mirrors
/// `frontend/app/[locale]/favorites/**`.
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Favorites'),
      ),
      body: SafeArea(
        child: favoritesAsync.when(
          loading: () => GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.68,
            ),
            itemCount: 6,
            itemBuilder: (context, _) => ShimmerBox(borderRadius: AppRadii.radiusXl),
          ),
          error: (error, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: AppColors.gray2, size: 40),
                const SizedBox(height: 12),
                Text('$error', style: const TextStyle(color: AppColors.gray2)),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => ref.read(favoritesListProvider.notifier).refresh(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (favorites) {
            if (favorites.isEmpty) {
              return const Center(
                child: Text(
                  'No favorites yet.',
                  style: TextStyle(color: AppColors.gray2),
                ),
              );
            }
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => ref.read(favoritesListProvider.notifier).refresh(),
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.68,
                ),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  return _FavoriteCard(favorite: favorites[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FavoriteCard extends ConsumerWidget {
  const _FavoriteCard({required this.favorite});

  final CustomerFav favorite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasDiscount = favorite.has_discount;
    final effectivePrice = favorite.effective_price ?? favorite.price;

    return GestureDetector(
      onTap: () => context.push('/product/${favorite.id}'),
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
                  aspectRatio: 1,
                  child: AppNetworkImage(url: favorite.primary_image, width: double.infinity, height: double.infinity),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: InkWell(
                    borderRadius: AppRadii.radiusFull,
                    onTap: () async {
                      try {
                        await ref.read(favoritesListProvider.notifier).toggle(favorite.id);
                      } catch (_) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Could not update favorite. Try again.')),
                          );
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                      child: const Icon(Icons.favorite, size: 16, color: AppColors.primary),
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
                    favorite.brand.name,
                    style: const TextStyle(color: AppColors.gray2, fontSize: 11),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    favorite.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${effectivePrice.toStringAsFixed(0)} EGP',
                        style: const TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      if (hasDiscount) ...[
                        const SizedBox(width: 6),
                        Text(
                          favorite.price.toStringAsFixed(0),
                          style: const TextStyle(
                            color: AppColors.gray2,
                            fontSize: 11,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (!favorite.in_stock) ...[
                    const SizedBox(height: 4),
                    const Text('Out of stock', style: TextStyle(color: AppColors.error, fontSize: 11)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
