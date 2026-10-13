import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/widgets/widgets.dart';
import '../../notifications/providers/notifications_provider.dart';
import '../../product/models/product.dart';
import '../../store/data/store_repository.dart';
import '../../store/presentation/widgets/tabs_filter_by.dart';
import '../models/home_res.dart';
import '../providers/home_provider.dart';

/// Mobile Home: compact app bar (favorites + notifications with unread
/// badge) with a search bar that opens Store, one vehicle/size finder card,
/// category/brand chips, Offers + Recommended carousels, a single promo banner
/// and quick actions. Fetches `GET /home`.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsync = ref.watch(homeProvider);
    final unread = ref.watch(unreadCountProvider).value ?? 0;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.page,
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(homeProvider.future),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: AppColors.chrome,
              foregroundColor: Colors.white,
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: false,
              title: Text(
                l10n.appTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              actions: [
                IconButton(
                  tooltip: l10n.favorites,
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () => context.push('/favorites'),
                ),
                IconButton(
                  tooltip: l10n.notifications,
                  icon: Badge(
                    isLabelVisible: unread > 0,
                    label: Text(unread > 99 ? '99+' : '$unread'),
                    child: const Icon(Icons.notifications_none),
                  ),
                  onPressed: () => context.push('/notifications'),
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(64),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.gutter,
                    0,
                    AppSpacing.gutter,
                    AppSpacing.md,
                  ),
                  child: _SearchBar(
                    hint: l10n.searchPlaceholder,
                    onTap: () => context.go('/store'),
                  ),
                ),
              ),
            ),
            ...homeAsync.when(
              data: (home) => _content(context, home),
              loading: () => const [_HomeSkeleton()],
              error: (error, _) => [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: ErrorState(
                    message: error.toString(),
                    onRetry: () => ref.invalidate(homeProvider),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _content(BuildContext context, HomeRes home) {
    final l10n = context.l10n;
    final offerIds = home.offers.map((p) => p.id).toSet();
    // A product can only own one Hero tag per screen.
    final recommended = home.featured
        .where((p) => !offerIds.contains(p.id))
        .toList();

    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.lg,
            AppSpacing.gutter,
            0,
          ),
          child: Text(
            l10n.homeGreeting,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.foregroundLight,
            ),
          ),
        ),
      ),
      const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.lg,
            AppSpacing.gutter,
            0,
          ),
          child: _FinderCard(),
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.lg),
          child: ChipRow(
            children: [
              AppChip(
                label: l10n.tires,
                icon: Icons.tire_repair,
                onTap: () => context.go(
                  '/store',
                  extra: const ProductFilters(type: 'tire'),
                ),
              ),
              AppChip(
                label: l10n.batteries,
                icon: Icons.battery_charging_full,
                onTap: () => context.go(
                  '/store',
                  extra: const ProductFilters(type: 'battery'),
                ),
              ),
              for (final b in home.brands)
                AppChip(
                  label: b.name,
                  onTap: () => context.go(
                    '/store',
                    extra: ProductFilters(brandId: b.id),
                  ),
                ),
            ],
          ),
        ),
      ),
      if (home.offers.isNotEmpty)
        SliverToBoxAdapter(
          child: _Carousel(
            title: l10n.recommendedOffersForYou,
            products: home.offers,
            onSeeAll: () =>
                context.go('/store?filter_products_badge=special_offer'),
          ),
        ),
      const SliverToBoxAdapter(child: _PromoBanner()),
      if (recommended.isNotEmpty)
        SliverToBoxAdapter(
          child: _Carousel(
            title: l10n.recommendedTiresForYou,
            products: recommended,
            onSeeAll: () => context.go('/store?filter_products_type=tire'),
          ),
        ),
      const SliverToBoxAdapter(child: _QuickActions()),
      const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
    ];
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.hint, required this.onTap});

  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: hint,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: SizedBox(
            height: 48,
            child: Row(
              children: [
                const SizedBox(width: AppSpacing.md),
                const Icon(Icons.search, color: AppColors.gray2),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    hint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.gray2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FinderCard extends StatefulWidget {
  const _FinderCard();

  @override
  State<_FinderCard> createState() => _FinderCardState();
}

class _FinderCardState extends State<_FinderCard> {
  ProductFilters _filters = const ProductFilters();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.findYourTireNow,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.foregroundLight,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TabsFilterBy(
            filters: _filters,
            onChanged: (f) => setState(() => _filters = f),
            submitLabel: context.l10n.findYourTireNow,
            onSubmit: () => context.go('/store', extra: _filters),
          ),
        ],
      ),
    );
  }
}

/// Horizontal product carousel with a section header.
class _Carousel extends StatelessWidget {
  const _Carousel({
    required this.title,
    required this.products,
    required this.onSeeAll,
  });

  final String title;
  final List<Product> products;
  final VoidCallback onSeeAll;

  static const double _cardWidth = 164;

  @override
  Widget build(BuildContext context) {
    final height = productCardExtent(context, _cardWidth) + AppSpacing.sm;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(
            title: title,
            actionLabel: context.l10n.showAll,
            onAction: onSeeAll,
          ),
          SizedBox(
            height: height,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                0,
                AppSpacing.gutter,
                AppSpacing.sm,
              ),
              itemCount: products.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
              itemBuilder: (_, i) => SizedBox(
                width: _cardWidth,
                child: ProductCard(product: products[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.lg,
        AppSpacing.gutter,
        0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 150,
          child: Material(
            color: AppColors.chrome,
            child: InkWell(
              onTap: () => context.go('/services'),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/maintenanceServicesBg.jpg',
                    fit: BoxFit.cover,
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Color(0xCC000000), Color(0x00000000)],
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    start: AppSpacing.lg,
                    end: AppSpacing.lg,
                    bottom: AppSpacing.lg,
                    child: Text(
                      context.l10n.maintenanceServices,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Widget tile(IconData icon, String label, String route) => Expanded(
      child: AppCard(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.md,
        ),
        onTap: () => context.push(route),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.foregroundLight,
              ),
            ),
          ],
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.lg,
        AppSpacing.gutter,
        0,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            tile(
              Icons.calendar_month_outlined,
              l10n.bookServiceNow,
              '/reservation',
            ),
            const SizedBox(width: AppSpacing.md),
            tile(
              Icons.local_shipping_outlined,
              l10n.trackOrder,
              '/track-order',
            ),
            const SizedBox(width: AppSpacing.md),
            tile(Icons.support_agent, l10n.contactUs, '/contact'),
          ],
        ),
      ),
    );
  }
}

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();

  @override
  Widget build(BuildContext context) {
    final cardHeight = productCardExtent(context, 164);
    return SliverPadding(
      padding: const EdgeInsets.all(AppSpacing.gutter),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const ShimmerBox(height: 28, width: 220),
          const SizedBox(height: AppSpacing.lg),
          const ShimmerBox(
            height: 180,
            width: double.infinity,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          const SizedBox(height: AppSpacing.lg),
          const ShimmerBox(
            height: 40,
            width: double.infinity,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: ShimmerBox(
                  height: cardHeight,
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: ShimmerBox(
                  height: cardHeight,
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
