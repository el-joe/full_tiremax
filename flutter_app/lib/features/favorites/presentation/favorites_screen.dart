import '../../../l10n/l10n.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/widgets.dart';
import '../../../core/models/brand.dart';
import '../../product/models/product.dart';
import '../models/customer_fav.dart';
import '../providers/favorites_list_provider.dart';
import '../providers/favorites_provider.dart';

/// Adapts the narrow `GET /favorites` payload to the shared `ProductCard`,
/// which (like the web's) is fed favourites directly.
Product customerFavToProduct(CustomerFav f) => Product(
  id: f.id,
  sku: f.sku,
  type: '',
  name: f.name,
  short_description: '',
  price: f.price,
  sale_price: f.sale_price,
  effective_price: f.effective_price ?? f.price,
  has_discount: f.has_discount,
  is_flash_sale: false,
  stock: f.in_stock ? 1 : 0,
  in_stock: f.in_stock,
  manufacture_year: 0,
  manufacturer_warranty_months: 0,
  agency_warranty_months: 0,
  sales_count: 0,
  views_count: 0,
  is_featured: f.is_featured,
  badges: f.badges,
  primary_image: f.primary_image,
  brand: Brand(
    id: f.brand.id,
    slug: f.brand.slug,
    name: f.brand.name,
    country: '',
    is_active: true,
  ),
);

/// GET /favorites as the shared product grid. Mirrors
/// `frontend/app/[locale]/favorites/page.tsx`.
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final favoritesAsync = ref.watch(favoritesListProvider);
    // Hearts toggled from a card drop the product from the grid immediately
    // (the web re-fetches favourites after every toggle).
    final ids = ref.watch(favoritesProvider);

    return AppScaffold(
      title: l.favorites,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => ref.read(favoritesListProvider.notifier).refresh(),
        child: favoritesAsync.when(
          loading: () => LayoutBuilder(
            builder: (context, c) => ListView(
              padding: const EdgeInsets.all(AppSpacing.gutter),
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (var i = 0; i < 2; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Row(
                      children: [
                        for (var j = 0; j < 2; j++) ...[
                          if (j > 0) const SizedBox(width: AppSpacing.md),
                          const Expanded(
                            child: ShimmerBox(
                              height: 240,
                              light: true,
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),
          error: (error, _) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: 360,
                child: ErrorState(
                  message: l.unexpectedError,
                  onRetry: () =>
                      ref.read(favoritesListProvider.notifier).refresh(),
                ),
              ),
            ],
          ),
          data: (favorites) {
            final shown = favorites
                .where((f) => ids.contains(f.id))
                .map(customerFavToProduct)
                .toList();
            if (shown.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: 360,
                    child: EmptyState(
                      icon: Icons.favorite_border,
                      title: l.noFavoriteProducts,
                      message: l.savedProductsDescription,
                      actionLabel: l.goToShopping,
                      onAction: () => context.go('/store'),
                    ),
                  ),
                ],
              );
            }
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.gutter),
              children: [ProductGrid(products: shown)],
            );
          },
        ),
      ),
    );
  }
}
