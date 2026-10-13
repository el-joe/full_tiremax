import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/protected_action.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/widgets/widgets.dart';
import '../../cart/providers/cart_provider.dart';
import '../../favorites/providers/favorites_provider.dart';
import '../data/product_repository.dart';
import '../models/product.dart';

/// Product detail: swipeable full-bleed gallery (Hero from the card, page
/// dots) under a collapsing app bar with back / favorite / share, a price
/// block, collapsible Specs / Description / Warranty / Reviews sections and a
/// sticky bottom bar (price + Add to cart). Review writing lives in the web's
/// order flow, so it is not offered here.
class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailProvider(productId));

    return productAsync.when(
      data: (product) => _ProductDetailBody(product: product),
      loading: () => AppScaffold(
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            ShimmerBox(
              light: true,
              width: double.infinity,
              height: 300,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            SizedBox(height: AppSpacing.lg),
            ShimmerBox(
              light: true,
              width: double.infinity,
              height: 120,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            SizedBox(height: AppSpacing.lg),
            ShimmerBox(
              light: true,
              width: double.infinity,
              height: 64,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ],
        ),
      ),
      error: (error, _) => AppScaffold(
        body: ErrorState(
          message: error.toString(),
          onRetry: () => ref.invalidate(productDetailProvider(productId)),
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
  final _scroll = ScrollController();
  bool _adding = false;
  bool _collapsed = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  double get _expandedHeight =>
      (MediaQuery.sizeOf(context).width).clamp(260.0, 420.0);

  void _onScroll() {
    final collapsed =
        _scroll.hasClients &&
        _scroll.offset > _expandedHeight - kToolbarHeight - 24;
    if (collapsed != _collapsed) setState(() => _collapsed = collapsed);
  }

  Future<void> _addToCart() async {
    HapticFeedback.lightImpact();
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final router = GoRouter.maybeOf(context);
    setState(() => _adding = true);
    final error = await ref
        .read(cartProvider.notifier)
        .addProduct(widget.product.id, 1);
    if (!mounted) return;
    setState(() => _adding = false);
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

  void _share() {
    final p = widget.product;
    Clipboard.setData(
      ClipboardData(text: '${p.name} - ${formatIqd(p.effective_price)}'),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(context.l10n.productCopied)));
  }

  void _back() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/store');
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final l10n = context.l10n;
    final fav = ref.watch(favoritesProvider).contains(product.id);
    final images = [
      for (final i in product.images) i.url,
      if (product.images.isEmpty && product.primary_image != null)
        product.primary_image!,
    ];

    return Scaffold(
      backgroundColor: AppColors.page,
      bottomNavigationBar: StickyBottomBar(
        label: l10n.total,
        value: PriceText(
          price: product.effective_price,
          oldPrice: product.has_discount ? product.price : null,
        ),
        action: PrimaryButton(
          label: l10n.addToCart,
          icon: Icons.add_shopping_cart,
          loading: _adding,
          onPressed: product.in_stock && !_adding ? _addToCart : null,
        ),
      ),
      body: CustomScrollView(
        controller: _scroll,
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: _expandedHeight,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 1,
            automaticallyImplyLeading: false,
            leadingWidth: 56,
            leading: _RoundAction(
              icon: Icons.arrow_back,
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: _back,
            ),
            title: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _collapsed ? 1 : 0,
              child: Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.foregroundLight,
                ),
              ),
            ),
            actions: [
              _RoundAction(
                icon: fav ? Icons.favorite : Icons.favorite_border,
                color: fav ? AppColors.error : null,
                tooltip: fav
                    ? l10n.removeFromFavoritesLabel
                    : l10n.addToFavoritesLabel,
                onPressed: () => requireAuth(
                  context,
                  ref,
                  () => ref.read(favoritesProvider.notifier).toggle(product.id),
                ),
              ),
              _RoundAction(
                icon: Icons.ios_share,
                tooltip: l10n.shareProduct,
                onPressed: _share,
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: _Gallery(
                productId: product.id,
                images: images,
                badge: product.badges.isEmpty ? null : product.badges.first,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.gutter),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _PriceBlock(product: product),
                const SizedBox(height: AppSpacing.md),
                _Section(
                  title: l10n.sectionSpecs,
                  initiallyExpanded: true,
                  child: _SpecGrid(product: product),
                ),
                const SizedBox(height: AppSpacing.md),
                _Section(
                  title: l10n.sectionDescription,
                  initiallyExpanded: true,
                  child: _Description(
                    text: product.description ?? product.short_description,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _Section(
                  title: l10n.sectionWarranty,
                  child: _Warranty(product: product),
                ),
                const SizedBox(height: AppSpacing.md),
                _ReviewsSection(productId: product.id),
                const SizedBox(height: AppSpacing.lg),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.color,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: AppSpacing.sm),
        child: Material(
          color: Colors.white,
          shape: const CircleBorder(),
          elevation: 2,
          shadowColor: Colors.black38,
          child: InkResponse(
            onTap: onPressed,
            radius: 22,
            child: SizedBox(
              width: AppSpacing.minTap - 4,
              height: AppSpacing.minTap - 4,
              child: Tooltip(
                message: tooltip,
                child: Icon(
                  icon,
                  size: 20,
                  color: color ?? AppColors.foregroundLight,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Gallery extends StatefulWidget {
  const _Gallery({
    required this.productId,
    required this.images,
    required this.badge,
  });

  final int productId;
  final List<String> images;
  final String? badge;

  @override
  State<_Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<_Gallery> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.images.isEmpty ? <String?>[null] : widget.images;
    return ColoredBox(
      color: Colors.white,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            itemCount: images.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (_, i) {
              Widget img = SizedBox.expand(
                child: AppNetworkImage(url: images[i], fit: BoxFit.cover),
              );
              if (i == 0)
                img = Hero(tag: productHeroTag(widget.productId), child: img);
              return img;
            },
          ),
          if (widget.badge != null)
            PositionedDirectional(
              start: AppSpacing.lg,
              bottom: AppSpacing.lg,
              child: ProductBadge(content: widget.badge!, large: true),
            ),
          if (images.length > 1)
            Positioned(
              left: 0,
              right: 0,
              bottom: AppSpacing.md,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < images.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == _page ? 18 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: i == _page ? AppColors.primary : AppColors.gray,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _PriceBlock extends StatelessWidget {
  const _PriceBlock({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.brand.name.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: AppColors.gray2,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.25,
              color: AppColors.foregroundLight,
            ),
          ),
          if ((product.expert_rating ?? 0) > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            StarRating(rating: product.expert_rating!.toDouble(), size: 20),
          ],
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              PriceText(
                price: product.effective_price,
                oldPrice: product.has_discount ? product.price : null,
                fontSize: 22,
              ),
              StatusPill(
                label: product.in_stock ? l10n.availableNow : l10n.notAvailable,
                color: product.in_stock ? AppColors.green : AppColors.red,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _InfoRow(
            icon: Icons.check_circle_outline,
            text: l10n.priceIncludesInstallationAndBalancing,
          ),
          const SizedBox(height: AppSpacing.sm),
          _InfoRow(
            icon: Icons.local_shipping_outlined,
            text: l10n.shippingAvailableAllGovernorates,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.foregroundLight,
            ),
          ),
        ),
      ],
    );
  }
}

/// Card with a collapsible body (title row toggles).
class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
    this.trailing,
  });

  final String title;
  final Widget child;
  final bool initiallyExpanded;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          childrenPadding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
          shape: const Border(),
          collapsedShape: const Border(),
          iconColor: AppColors.foregroundLight,
          collapsedIconColor: AppColors.gray2,
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.foregroundLight,
            ),
          ),
          trailing: trailing,
          children: [child],
        ),
      ),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        height: 1.5,
        color: AppColors.foregroundLight,
      ),
    );
  }
}

class _SpecGrid extends StatelessWidget {
  const _SpecGrid({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tire = product.tire_spec;
    final battery = product.battery_spec;
    final isBattery = product.type == 'battery';
    final specs = isBattery
        ? <(String, String, bool)>[
            (l10n.cca, '${battery?.cca ?? ''}', false),
            (l10n.countryOfOrigin, product.brand.country, false),
            (l10n.make, product.brand.name, false),
            (l10n.sizeCode, battery?.size_code ?? '', false),
            (l10n.manufactureYear, '${product.manufacture_year}', false),
            (l10n.batteryType, battery?.battery_type ?? '', false),
            (
              l10n.voltageAndCapacity,
              '${battery?.voltage} V (${battery?.ampere_hour} A/H)',
              true,
            ),
          ]
        : <(String, String, bool)>[
            (l10n.size, tire?.size_string ?? '', true),
            (l10n.countryOfOrigin, product.brand.country, false),
            (l10n.make, product.brand.name, false),
            (l10n.treadPattern, product.pattern_name ?? '', false),
            (l10n.manufactureYear, '${product.manufacture_year}', false),
            (l10n.usageType, tire?.usage_type ?? '', false),
            (
              l10n.loadAndSpeed,
              '${tire?.load_index}(${tire?.speed_rating})',
              true,
            ),
          ];

    return LayoutBuilder(
      builder: (context, c) {
        final w = (c.maxWidth - AppSpacing.sm) / 2;
        return Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final (title, body, ltr) in specs)
              SizedBox(
                width: w,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.gray4,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.gray2,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Directionality(
                        textDirection: ltr
                            ? TextDirection.ltr
                            : Directionality.of(context),
                        child: Text(
                          body.isEmpty ? '-' : body,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.foregroundLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _Warranty extends StatelessWidget {
  const _Warranty({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Widget item(
      IconData icon,
      String title,
      String body, {
      bool highlight = false,
    }) => Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlight ? AppColors.primary : AppColors.gray,
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 22,
            color: highlight ? AppColors.onPrimary : AppColors.gray2,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.foregroundLight,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  body,
                  style: const TextStyle(fontSize: 12, color: AppColors.gray2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.dualWarrantySystem,
          style: const TextStyle(fontSize: 12, color: AppColors.gray2),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (product.manufacturer_warranty_months > 0) ...[
          item(
            Icons.shield_outlined,
            l10n.manufacturesWarranty,
            '${l10n.manufacturesWarrantyDescription} ${product.manufacturer_warranty_months} ${l10n.months}',
            highlight: true,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        item(
          Icons.storefront_outlined,
          l10n.authorizedWarranty,
          l10n.tireMaxExclusiveMaintenance,
        ),
      ],
    );
  }
}

class _ReviewsSection extends ConsumerWidget {
  const _ReviewsSection({required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final reviewsAsync = ref.watch(productReviewsProvider(productId));
    return reviewsAsync.when(
      loading: () => const ShimmerBox(
        light: true,
        width: double.infinity,
        height: 64,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      error: (error, _) => _Section(
        title: l10n.userReviews,
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton(
            onPressed: () => ref.invalidate(productReviewsProvider(productId)),
            child: Text(l10n.retry),
          ),
        ),
      ),
      data: (state) => _Section(
        title: l10n.userReviews,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, size: 18, color: Color(0xFFFFC107)),
            const SizedBox(width: AppSpacing.xs),
            Text(
              '${state.ratingCount}',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.foregroundLight,
              ),
            ),
            const Icon(Icons.expand_more, color: AppColors.gray2),
          ],
        ),
        child: state.reviews.isEmpty
            ? Text(
                l10n.noReviews,
                style: const TextStyle(fontSize: 14, color: AppColors.gray2),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final review in state.reviews)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.gray4,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    review.customer.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.foregroundLight,
                                    ),
                                  ),
                                ),
                                Text(
                                  formatDateLocalized(
                                    'd/M/y',
                                    review.created_at.toLocal(),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.gray2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              review.comment,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.foregroundLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
