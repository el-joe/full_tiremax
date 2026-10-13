import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/protected_action.dart';
import '../../features/cart/providers/cart_provider.dart';
import '../../features/favorites/providers/favorites_provider.dart';
import '../../features/product/models/product.dart';
import '../../l10n/l10n.dart';
import 'app_feedback.dart';
import 'shimmer_box.dart';

/// Default Hero tag for a product's main image (card -> detail gallery).
Object productHeroTag(int id) => 'product-image-$id';

/// Mobile product card: 1:1 white image well with a 36px circular favorite
/// button (top-start) and discount pill + badge (top-end), then small-caps
/// brand, 2-line name, spec line, rating, bold price (+ strikethrough old
/// price) and a 40px circular yellow add-to-cart button. The whole card is
/// tappable. Adding to cart gives haptic feedback and a snackbar with a
/// "View cart" action.
///
/// Height must be bounded by the parent: use [ProductGrid] /
/// [SliverProductGrid] (see `productCardExtent`) or give it a fixed height.
/// Pass [heroTag] to enable a Hero transition on the image.
class ProductCard extends ConsumerWidget {
  const ProductCard({super.key, required this.product, this.heroTag});

  final Product product;
  final Object? heroTag;

  int? get _discountPercent {
    if (!product.has_discount || product.price <= 0) return null;
    final p = ((product.price - product.effective_price) / product.price * 100)
        .round();
    return p > 0 ? p : null;
  }

  String? get _spec =>
      product.tire_spec?.size_string ??
      product.battery_spec?.battery_type ??
      product.category?.name;

  Future<void> _addToCart(BuildContext context, WidgetRef ref) async {
    HapticFeedback.lightImpact();
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final router = GoRouter.maybeOf(context);
    final error = await ref
        .read(cartProvider.notifier)
        .addProduct(product.id, 1);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(error ?? l10n.addedToCart),
          action: error == null && router != null
              ? SnackBarAction(
                  label: l10n.viewCart,
                  onPressed: () => router.push('/cart'),
                )
              : null,
        ),
      );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorited = ref.watch(favoritesProvider).contains(product.id);
    final l10n = context.l10n;
    final image = product.images.isNotEmpty
        ? product.images.first.url
        : product.primary_image;
    final discount = _discountPercent;
    final spec = _spec;

    Widget img = AppNetworkImage(url: image, fit: BoxFit.cover);
    img = Hero(tag: heroTag ?? productHeroTag(product.id), child: img);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push('/product/${product.id}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: kProductImageAspect,
                child: Stack(
                  children: [
                    Positioned.fill(child: img),
                    PositionedDirectional(
                      top: 2,
                      start: 2,
                      child: Semantics(
                        button: true,
                        label: isFavorited
                            ? l10n.removeFromFavoritesLabel
                            : l10n.addToFavoritesLabel,
                        child: InkResponse(
                          radius: 22,
                          onTap: () => requireAuth(
                            context,
                            ref,
                            () => ref
                                .read(favoritesProvider.notifier)
                                .toggle(product.id),
                          ),
                          child: SizedBox(
                            width: 44,
                            height: 44,
                            child: Center(
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x26000000),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  isFavorited
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 20,
                                  color: isFavorited
                                      ? AppColors.error
                                      : AppColors.foregroundLight,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    PositionedDirectional(
                      top: 8,
                      end: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (discount != null)
                            _DiscountPill(percent: discount),
                          if (product.badges.isNotEmpty) ...[
                            if (discount != null) const SizedBox(height: 4),
                            ProductBadge(content: product.badges.first),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.brand.name.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: AppColors.gray2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.25,
                          fontWeight: FontWeight.w600,
                          color: AppColors.foregroundLight,
                        ),
                      ),
                      if (spec != null)
                        Text(
                          spec,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.gray2,
                          ),
                        ),
                      const SizedBox(height: 2),
                      if ((product.expert_rating ?? 0) > 0)
                        StarRating(
                          rating: product.expert_rating!.toDouble(),
                          size: 14,
                        ),
                      const Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: AlignmentDirectional.centerStart,
                              child: PriceText(
                                price: product.effective_price,
                                oldPrice: product.has_discount
                                    ? product.price
                                    : null,
                              ),
                            ),
                          ),
                          Semantics(
                            button: true,
                            label: l10n.commonAddToCart,
                            child: InkResponse(
                              radius: 22,
                              onTap: () => _addToCart(context, ref),
                              child: SizedBox(
                                width: 44,
                                height: 44,
                                child: Center(
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.add_shopping_cart,
                                      size: 20,
                                      color: AppColors.chrome,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Image aspect ratio (width / height) of the card's image area.
const double kProductImageAspect = 1.1;

/// Compact star row (full / half / empty) that never clips fractional values.
class StarRating extends StatelessWidget {
  const StarRating({super.key, required this.rating, this.size = 14});

  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 1; i <= 5; i++)
            Icon(
              rating >= i - 0.25
                  ? Icons.star_rounded
                  : (rating >= i - 0.75
                        ? Icons.star_half_rounded
                        : Icons.star_outline_rounded),
              size: size,
              color: const Color(0xFFFFB400),
            ),
        ],
      ),
    );
  }
}

class _DiscountPill extends StatelessWidget {
  const _DiscountPill({required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Text(
          '-$percent%',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

/// Product badge pill (special_offer / best_seller / best_choice / new).
class ProductBadge extends StatelessWidget {
  const ProductBadge({super.key, required this.content, this.large = false});

  final String content;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final (Color bg, IconData icon, Color iconColor) = switch (content) {
      'special_offer' => (
        const Color(0xFFAE1819),
        Icons.percent,
        const Color(0xFFFFD166),
      ),
      'best_seller' => (
        AppColors.primary,
        Icons.workspace_premium,
        const Color(0xFF5C4033),
      ),
      'best_choice' => (
        const Color(0xFF2E7D32),
        Icons.price_check,
        const Color(0xFF00F40A),
      ),
      'new' => (
        const Color(0xFF1976D2),
        Icons.fiber_new,
        const Color(0xFFB4DDFF),
      ),
      _ => (AppColors.primary, Icons.workspace_premium, Colors.white),
    };
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 12 : 6,
        vertical: large ? 4 : 2,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: large ? 14 : 12, color: iconColor),
          const SizedBox(width: 2),
          Flexible(
            child: Text(
              switch (content) {
                'special_offer' => context.l10n.specialOffer,
                'best_seller' => context.l10n.bestSeller,
                'best_choice' => context.l10n.bestChoice,
                'new' => context.l10n.newBadge,
                _ => content.split('_').join(' '),
              },
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: large ? 12 : 11,
                fontWeight: FontWeight.w800,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
