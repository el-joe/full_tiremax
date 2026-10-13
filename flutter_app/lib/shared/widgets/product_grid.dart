import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../features/product/models/product.dart';
import 'product_card.dart';

/// Height of a [ProductCard] for a given column [width]: the 1:1 image well
/// plus a text block that scales with the user's text scale factor.
double productCardExtent(BuildContext context, double width) {
  final scale = MediaQuery.textScalerOf(context).scale(1.0).clamp(1.0, 2.0);
  return width / kProductImageAspect + 142 * scale;
}

SliverGridDelegate _delegate(
  BuildContext context,
  double crossAxisExtent,
  double gap,
) {
  final colWidth = (crossAxisExtent - gap) / 2;
  return SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    mainAxisSpacing: gap,
    crossAxisSpacing: gap,
    mainAxisExtent: productCardExtent(context, colWidth),
  );
}

/// Lazy 2-column product grid for use inside a `CustomScrollView`. Each cell
/// has a fixed height derived from the column width and text scale (no
/// IntrinsicHeight). Wrap in `SliverPadding` for the page gutter.
class SliverProductGrid extends StatelessWidget {
  const SliverProductGrid({
    super.key,
    required this.products,
    this.gap = AppSpacing.md,
  });

  final List<Product> products;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) => SliverGrid(
        gridDelegate: _delegate(context, constraints.crossAxisExtent, gap),
        delegate: SliverChildBuilderDelegate(
          (_, i) => ProductCard(product: products[i]),
          childCount: products.length,
        ),
      ),
    );
  }
}

/// Non-scrolling 2-column product grid (shrink-wrapped, for use inside a
/// ListView/Column). Prefer [SliverProductGrid] in scroll views.
/// [rowGap] is kept for API compatibility and is used for both axes.
class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    required this.products,
    this.rowGap = AppSpacing.md,
  });

  final List<Product> products;
  final double rowGap;

  @override
  Widget build(BuildContext context) {
    final gap = rowGap > 24 ? AppSpacing.md : rowGap;
    return LayoutBuilder(
      builder: (context, constraints) => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: _delegate(context, constraints.maxWidth, gap),
        itemCount: products.length,
        itemBuilder: (_, i) => ProductCard(product: products[i]),
      ),
    );
  }
}
