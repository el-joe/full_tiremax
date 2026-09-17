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
  });

  final double? width;
  final double? height;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.gray3,
      highlightColor: const Color(0xFF4A4A4A),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.gray3,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

/// A remote image with a [ShimmerBox] placeholder and a graceful fallback
/// icon on error.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
  });

  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final placeholder = ClipRRect(
      borderRadius: borderRadius,
      child: ShimmerBox(width: width, height: height, borderRadius: borderRadius),
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
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.gray3,
        borderRadius: borderRadius,
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.image_not_supported_outlined, color: AppColors.gray2),
    );
  }
}
