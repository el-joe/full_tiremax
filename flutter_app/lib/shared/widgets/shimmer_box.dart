import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/theme/app_colors.dart';

/// A rounded shimmering placeholder box, used while content loads.
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.light = false,
  });

  /// Light-surface palette (for [AppColors.page] backgrounds).
  final bool light;

  final double? width;
  final double? height;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final light =
        this.light || Theme.of(context).brightness == Brightness.light;
    return Shimmer.fromColors(
      baseColor: light ? AppColors.gray : AppColors.gray3,
      highlightColor: light ? const Color(0xFFF7F7F7) : const Color(0xFF4A4A4A),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: light ? AppColors.gray : AppColors.gray3,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

/// A remote image with a [ShimmerBox] placeholder and a fallback to the
/// bundled default product image on error — mirrors the web app's fallback
/// to `/images/product-image.jpg` (see `ItemsList.tsx`:
/// `data.product.primary_image ?? "/images/product-image.jpg"`).
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
  });

  static const String placeholderAsset =
      'assets/images/product-placeholder.jpg';

  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final placeholder = ClipRRect(
      borderRadius: borderRadius,
      child: ShimmerBox(
        width: width,
        height: height,
        borderRadius: borderRadius,
      ),
    );

    if (url == null || url!.isEmpty) {
      return _fallback();
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        imageUrl: url!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, _) => placeholder,
        errorWidget: (context, _, _) => _fallback(),
      ),
    );
  }

  Widget _fallback() {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.asset(
        placeholderAsset,
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }
}
