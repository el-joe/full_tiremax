import '../../l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../features/product/models/product.dart';
import 'product_card.dart';

/// Mirrors web `components/ui/Container.tsx`: a white sheet with a 50px top
/// radius sitting on the black page background. Renders its subtree with the
/// light theme so default text is dark, like the web.
class WebSheet extends StatelessWidget {
  const WebSheet({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
    this.color = Colors.white,
    this.roundedTop = true,
    this.roundedBottom = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final bool roundedTop;
  final bool roundedBottom;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.light,
      child: Material(
        color: color,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(roundedTop ? 50 : 0),
            bottom: Radius.circular(roundedBottom ? 50 : 0),
          ),
        ),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// Section heading with an optional context.l10n.showAll link (web
/// RecommendedSection / RecommendedOffersSection header row).
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.showAllRoute});

  final String title;
  final String? showAllRoute;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 19),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.foregroundLight),
            ),
          ),
          if (showAllRoute != null)
            InkWell(
              onTap: () => context.go(showAllRoute!),
              child: Row(
                children: [
                  Text(context.l10n.showAll, style: const TextStyle(color: AppColors.foregroundLight)),
                  const SizedBox(width: 2),
                  const Icon(Icons.chevron_right, size: 20, color: AppColors.foregroundLight),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Wrapping 2-column product grid (web `HStack flexWrap` of `ProductCard`s,
/// 14px gaps on mobile). Rows are equal height (`alignItems: stretch`).
class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key, required this.products, this.rowGap = 14});

  final List<Product> products;
  final double rowGap;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < products.length; i += 2) {
      final second = i + 1 < products.length ? products[i + 1] : null;
      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: i + 2 < products.length ? rowGap : 0),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: ProductCard(product: products[i])),
                const SizedBox(width: 14),
                Expanded(child: second == null ? const SizedBox.shrink() : ProductCard(product: second)),
              ],
            ),
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}
