import '../../../l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../shared/widgets/shimmer_box.dart';
import '../../../shared/widgets/web_sheet.dart';
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
      brand: Brand(id: f.brand.id, slug: f.brand.slug, name: f.brand.name, country: '', is_active: true),
    );

/// GET /favorites as the web's `FavList`: centered title + description and the
/// shared product grid. Mirrors `frontend/app/[locale]/favorites/page.tsx`.
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesListProvider);
    // Hearts toggled from a card drop the product from the grid immediately
    // (the web re-fetches favourites after every toggle).
    final ids = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, title: Text(context.l10n.favorites)),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => ref.read(favoritesListProvider.notifier).refresh(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              Text(context.l10n.favorites,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Text(context.l10n.savedProductsDescription,
                  textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF6B7280), fontSize: 14)),
              const SizedBox(height: 32),
              favoritesAsync.when(
                loading: () => Row(
                  children: [
                    for (var i = 0; i < 2; i++) ...[
                      if (i > 0) const SizedBox(width: 14),
                      Expanded(child: ShimmerBox(height: 240, borderRadius: AppRadii.radiusXl)),
                    ],
                  ],
                ),
                error: (error, _) => Column(
                  children: [
                    Text(context.l10n.unexpectedError, style: TextStyle(color: AppColors.gray2)),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () => ref.read(favoritesListProvider.notifier).refresh(),
                      child: Text(context.l10n.retry),
                    ),
                  ],
                ),
                data: (favorites) {
                  final shown = favorites.where((f) => ids.contains(f.id)).map(customerFavToProduct).toList();
                  if (shown.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Text(context.l10n.noFavoriteProducts,
                          textAlign: TextAlign.center, style: TextStyle(color: AppColors.gray2)),
                    );
                  }
                  return ProductGrid(products: shown);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
