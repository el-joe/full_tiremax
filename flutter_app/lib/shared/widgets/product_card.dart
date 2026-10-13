import '../../l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/format.dart';
import '../../core/utils/protected_action.dart';
import '../../features/cart/providers/cart_provider.dart';
import '../../features/favorites/providers/favorites_provider.dart';
import '../../features/product/models/product.dart';
import 'shimmer_box.dart';

const _cardBg = Color(0xFFF9F9F9);
const _imageBg = Color(0xFFEEEEEE);
const _chipBg = AppColors.gray4;

/// Product card mirroring web `components/shared/ProductCard.tsx` (mobile
/// sizes): #F9F9F9 card, #EEEEEE image well with favorite (left) and badge
/// (right), brand chip, 1-line name, spec chips, rating + views, price with
/// strikethrough, and an add-to-cart button.
class ProductCard extends ConsumerWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorited = ref.watch(favoritesProvider).contains(product.id);
    final image = product.images.isNotEmpty ? product.images.first.url : product.primary_image;
    final chips = <String>[
      if (product.battery_spec?.battery_type != null) product.battery_spec!.battery_type,
      if (product.tire_spec?.size_string != null) product.tire_spec!.size_string,
      if (product.category?.name != null) product.category!.name,
    ];

    return GestureDetector(
      onTap: () => context.push('/product/${product.id}'),
      child: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Color(0x0D1A1C1C), blurRadius: 10, offset: Offset(0, 8), spreadRadius: -6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 106,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: _imageBg, borderRadius: BorderRadius.circular(6)),
              child: Stack(
                children: [
                  Positioned.fill(child: AppNetworkImage(url: image, fit: BoxFit.contain)),
                                    PositionedDirectional(
                    top: 0,
                    start: 0,
                    child: InkWell(
                      onTap: () => requireAuth(
                        context,
                        ref,
                        () => ref.read(favoritesProvider.notifier).toggle(product.id),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  if (product.badges.isNotEmpty)
                    PositionedDirectional(top: 0, end: 0, child: ProductBadge(content: product.badges.first)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _Chip(product.brand.name.toUpperCase(), color: AppColors.gray2),
            const SizedBox(height: 8),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, height: 14 / 12, fontWeight: FontWeight.w600, color: AppColors.foregroundLight),
            ),
            const SizedBox(height: 8),
            if (chips.isNotEmpty)
              Wrap(spacing: 4, runSpacing: 4, children: [for (final c in chips) _Chip(c)]),
            const SizedBox(height: 8),
            Row(
              children: [
                RatingBarIndicator(
                  rating: (product.expert_rating ?? 0).toDouble(),
                  itemSize: 12,
                  itemBuilder: (_, _) => const Icon(Icons.star, color: Color(0xFFFFC107)),
                ),
                const SizedBox(width: 4),
                Text('(${product.views_count})', style: const TextStyle(fontSize: 8, color: AppColors.gray2)),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatIqd(product.effective_price),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.foregroundLight),
                        ),
                        if (product.has_discount)
                          Text(
                            formatIqd(product.price),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.gray2,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () async {
                      final error = await ref.read(cartProvider.notifier).addProduct(product.id, 1);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(SnackBar(content: Text(error ?? context.l10n.addedToCart)));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.add_shopping_cart, size: 16, color: AppColors.onPrimary),
                    ),
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

class _Chip extends StatelessWidget {
  const _Chip(this.text, {this.color = AppColors.foregroundLight});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: _chipBg, borderRadius: BorderRadius.circular(12)),
      child: Text(text, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: color)),
    );
  }
}

/// Web `CustomBadge` (special_offer / best_seller / best_choice / new).
class ProductBadge extends StatelessWidget {
  const ProductBadge({super.key, required this.content, this.large = false});

  final String content;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final (Color bg, IconData icon, Color iconColor) = switch (content) {
      'special_offer' => (const Color(0xFFAE1819), Icons.percent, const Color(0xFFFFD166)),
      'best_seller' => (AppColors.primary, Icons.workspace_premium, const Color(0xFF5C4033)),
      'best_choice' => (const Color(0xFF2E7D32), Icons.price_check, const Color(0xFF00F40A)),
      'new' => (const Color(0xFF1976D2), Icons.fiber_new, const Color(0xFFB4DDFF)),
      _ => (AppColors.primary, Icons.workspace_premium, Colors.white),
    };
    return Container(
      padding: EdgeInsets.symmetric(horizontal: large ? 12 : 4, vertical: large ? 4 : 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: large ? 14 : 10, color: iconColor),
          const SizedBox(width: 2),
          Text(
            content.split('_').join(' '),
            style: TextStyle(color: Colors.white, fontSize: large ? 12 : 8, fontWeight: FontWeight.w800, height: 1.3),
          ),
        ],
      ),
    );
  }
}
