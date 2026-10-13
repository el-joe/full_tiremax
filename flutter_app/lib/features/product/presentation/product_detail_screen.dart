import '../../../l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/protected_action.dart';
import '../../../shared/widgets/product_card.dart';
import '../../../shared/widgets/shimmer_box.dart';
import '../../../shared/widgets/web_sheet.dart';
import '../../cart/providers/cart_provider.dart';
import '../../favorites/providers/favorites_provider.dart';
import '../data/product_repository.dart';
import '../models/product.dart';

/// Product detail screen mirroring `frontend/app/[locale]/store/[slug]/page.tsx`
/// (ProductImagesPreview, ProductDetails, ProductReviews, Actions). Review
/// writing lives in the web's order flow (it needs a delivered `order_id`),
/// not on this page, so it is not offered here.
class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailProvider(productId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background),
      body: SafeArea(
        child: productAsync.when(
          data: (product) => _ProductDetailBody(product: product),
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: ShimmerBox(width: double.infinity, height: 300),
          ),
          error: (error, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$error', style: const TextStyle(color: AppColors.gray2)),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => ref.invalidate(productDetailProvider(productId)),
                  child: Text(context.l10n.retry),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductDetailBody extends ConsumerStatefulWidget {
  const _ProductDetailBody({required this.product});

  final Product product;

  @override
  ConsumerState<_ProductDetailBody> createState() => _ProductDetailBodyState();
}

class _ProductDetailBodyState extends ConsumerState<_ProductDetailBody> {
  int _activeImage = 0;
  bool _adding = false;

  Future<void> _addToCart() async {
    setState(() => _adding = true);
    final error = await ref.read(cartProvider.notifier).addProduct(widget.product.id, 1);
    if (!mounted) return;
    setState(() => _adding = false);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(error ?? context.l10n.addedToCart)));
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final images = product.images.map((e) => e.url).toList();

    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 140),
      children: [
        WebSheet(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 24, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Gallery(
                      images: images,
                      badge: product.badges.isEmpty ? null : product.badges.first,
                      activeIndex: _activeImage,
                      onSelect: (i) => setState(() => _activeImage = i),
                    ),
                    const SizedBox(height: 16),
                    _Details(product: product),
                    const SizedBox(height: 16),
                    _ReviewsSection(productId: product.id),
                  ],
                ),
              ),
              _ActionsBar(product: product, adding: _adding, onAdd: _addToCart),
            ],
          ),
        ),
      ],
    );
  }
}

class _Gallery extends StatelessWidget {
  const _Gallery({required this.images, required this.badge, required this.activeIndex, required this.onSelect});

  final List<String> images;
  final String? badge;
  final int activeIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final current = images.isEmpty ? null : images[activeIndex.clamp(0, images.length - 1)];
    return Column(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 1 / 0.8,
                child: current == null
                    ? Image.asset('assets/images/product-image.jpg', fit: BoxFit.cover, width: double.infinity)
                    : AppNetworkImage(url: current, width: double.infinity, height: double.infinity),
              ),
            ),
            // Web: `top: 16px; right: 19px`.
            if (badge != null) PositionedDirectional(top: 16, end: 19, child: ProductBadge(content: badge!, large: true)),
          ],
        ),
        if (images.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: SizedBox(
              height: 86,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                separatorBuilder: (_, _) => const SizedBox(width: 16),
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => onSelect(index),
                  child: Opacity(
                    opacity: index == activeIndex ? 1 : 0.4,
                    child: SizedBox(
                      width: 70,
                      child: AppNetworkImage(url: images[index], borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final desc = product.description ?? product.short_description;
    final isBattery = product.type == 'battery';
    final tire = product.tire_spec;
    final battery = product.battery_spec;
    final cards = isBattery
        ? <(String, String, Color?, bool)>[
            (context.l10n.cca, '${battery?.cca ?? ''}', null, false),
            (context.l10n.countryOfOrigin, product.brand.country, null, false),
            (context.l10n.make, product.brand.name, null, false),
            (context.l10n.sizeCode, battery?.size_code ?? '', null, false),
            (context.l10n.manufactureYear, '${product.manufacture_year}', null, false),
            (context.l10n.batteryType, battery?.battery_type ?? '', null, false),
            (context.l10n.voltageAndCapacity, '${battery?.voltage} V (${battery?.ampere_hour} A/H)', null, true),
            (context.l10n.availability, product.in_stock ? context.l10n.availableNow : context.l10n.notAvailable,
              product.in_stock ? AppColors.green : AppColors.red, false),
          ]
        : <(String, String, Color?, bool)>[
            (context.l10n.size, tire?.size_string ?? '', null, false),
            (context.l10n.countryOfOrigin, product.brand.country, null, false),
            (context.l10n.make, product.brand.name, null, false),
            (context.l10n.treadPattern, product.pattern_name ?? '', null, false),
            (context.l10n.manufactureYear, '${product.manufacture_year}', null, false),
            (context.l10n.usageType, tire?.usage_type ?? '', null, false),
            (context.l10n.loadAndSpeed, '${tire?.load_index}(${tire?.speed_rating})', null, false),
            (context.l10n.availability, product.in_stock ? context.l10n.availableNow : context.l10n.notAvailable,
              product.in_stock ? AppColors.green : AppColors.red, false),
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          product.name,
          style: const TextStyle(fontSize: 16, height: 1, fontWeight: FontWeight.w700, color: AppColors.foregroundLight),
        ),
        const SizedBox(height: 16),
        Text(desc, style: const TextStyle(fontSize: 12, color: AppColors.foregroundLight)),
        const SizedBox(height: 16),
        // price card
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.gray4,
            borderRadius: BorderRadius.circular(16),
            border: const BorderDirectional(start: BorderSide(color: AppColors.primary, width: 4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: formatNumber(product.effective_price)),
                    TextSpan(text: ' ${context.l10n.iraqiDinar}', style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w400)),
                  ],
                ),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              Row(children: [
                Icon(Icons.check_circle_outline, size: 14, color: AppColors.primary),
                SizedBox(width: 8),
                Expanded(child: Text(context.l10n.priceIncludesInstallationAndBalancing, style: TextStyle(fontSize: 11, color: AppColors.foregroundLight))),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                Icon(Icons.local_shipping_outlined, size: 14, color: AppColors.primary),
                SizedBox(width: 8),
                Expanded(child: Text(context.l10n.shippingAvailableAllGovernorates, style: TextStyle(fontSize: 11, color: AppColors.foregroundLight))),
              ]),
            ],
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, c) {
            final w = (c.maxWidth - 11) / 2;
            return Wrap(
              spacing: 11,
              runSpacing: 11,
              children: [
                for (final (title, body, color, ltr) in cards)
                  SizedBox(width: w, child: _DetailCard(title: title, body: body, color: color, ltr: ltr)),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        Text(context.l10n.dualWarrantySystem, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.foregroundLight)),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, c) {
            final w = (c.maxWidth - 11) / 2;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (product.manufacturer_warranty_months > 0) ...[
                  SizedBox(
                    width: w,
                    child: _WarrantyCard(
                      border: AppColors.primary,
                      iconBg: const Color(0x33FDB604),
                      iconColor: const Color(0xFF7C5800),
                      icon: Icons.shield_outlined,
                      title: context.l10n.manufacturesWarranty,
                      body: '${context.l10n.manufacturesWarrantyDescription} ${product.manufacturer_warranty_months} ${context.l10n.months}',
                    ),
                  ),
                  const SizedBox(width: 11),
                ],
                SizedBox(
                  width: w,
                  child: _WarrantyCard(
                    border: Color(0xFFE5E7EB),
                    iconBg: Color(0xFFF4F4F5),
                    iconColor: Color(0xFF6B7280),
                    icon: Icons.storefront_outlined,
                    title: context.l10n.authorizedWarranty,
                    body: context.l10n.tireMaxExclusiveMaintenance,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.title, required this.body, this.color, this.ltr = false});

  final String title;
  final String body;
  final Color? color;
  final bool ltr;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: AppColors.gray4, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.gray2)),
          const SizedBox(height: 4),
          Directionality(
            textDirection: ltr ? TextDirection.ltr : Directionality.of(context),
            child: Text(body, style: TextStyle(fontWeight: FontWeight.w600, color: color ?? Colors.black)),
          ),
        ],
      ),
    );
  }
}

class _WarrantyCard extends StatelessWidget {
  const _WarrantyCard({
    required this.border,
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.title,
    required this.body,
  });

  final Color border;
  final Color iconBg;
  final Color iconColor;
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(border: Border.all(color: border, width: 2), borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 22,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(999)),
            child: Icon(icon, size: 14, color: iconColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.foregroundLight)),
                const SizedBox(height: 4),
                Text(body, style: const TextStyle(fontSize: 9, color: AppColors.gray2)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewsSection extends ConsumerWidget {
  const _ReviewsSection({required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(productReviewsProvider(productId));
    return reviewsAsync.when(
      loading: () => const ShimmerBox(width: double.infinity, height: 80),
      error: (error, _) => Text('$error', style: const TextStyle(color: AppColors.gray2)),
      data: (state) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.l10n.userReviews, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.foregroundLight)),
              Row(
                children: [
                  RatingBarIndicator(
                    rating: state.ratingAvg,
                    itemSize: 20,
                    itemBuilder: (_, _) => const Icon(Icons.star, color: Color(0xFFFFC107)),
                  ),
                  const SizedBox(width: 6),
                  Text('${state.ratingCount}', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.foregroundLight)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          for (final review in state.reviews)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(border: Border.all(color: AppColors.primary, width: 2), borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(review.customer.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.foregroundLight)),
                              const SizedBox(height: 4),
                              Text(
                                '${review.created_at.toLocal().month}/${review.created_at.toLocal().day}/${review.created_at.toLocal().year}',
                                style: const TextStyle(fontSize: 12, color: AppColors.gray2),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.primary, width: 2),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset('assets/images/testimonialUserAvatar.jpg', width: 48, height: 48, fit: BoxFit.cover),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(review.comment, style: const TextStyle(fontSize: 14, color: AppColors.gray2)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Web `Actions`: gray-4 bar at the bottom of the product sheet with the
/// total, context.l10n.commonAddToCart and a favorite button.
class _ActionsBar extends ConsumerWidget {
  const _ActionsBar({required this.product, required this.adding, required this.onAdd});

  final Product product;
  final bool adding;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fav = ref.watch(favoritesProvider).contains(product.id);
    return Container(
      color: AppColors.gray4,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.total, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.gray2)),
              Text(
                formatIqd(product.effective_price),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.foregroundLight),
              ),
            ],
          ),
          Row(
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: adding ? null : onAdd,
                icon: adding
                    ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.add_shopping_cart, size: 16),
                label: Text(context.l10n.addToCart, style: TextStyle(fontSize: 11)),
              ),
              const SizedBox(width: 12),
              IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => requireAuth(
                  context,
                  ref,
                  () => ref.read(favoritesProvider.notifier).toggle(product.id),
                ),
                icon: Icon(fav ? Icons.favorite : Icons.favorite_border, size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
