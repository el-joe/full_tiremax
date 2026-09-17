import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../shared/widgets/product_card.dart';
import '../../../shared/widgets/shimmer_box.dart';
import '../../product/models/product.dart';
import '../models/home_res.dart';
import '../providers/home_provider.dart';

/// Home screen: hero banner, recommended products, banners, reservation CTA,
/// recommended offers, why-us, contact-us — mirroring
/// `frontend/app/[locale]/page.tsx`. Fetches `GET /home`.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsync = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(homeProvider.future),
          child: homeAsync.when(
            data: (home) => _HomeContent(home: home),
            loading: () => const _HomeLoading(),
            error: (error, _) => _HomeError(
              message: error.toString(),
              onRetry: () => ref.invalidate(homeProvider),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.home});

  final HomeRes home;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 140),
      children: [
        const _HeroBanner(),
        _Section(
          title: 'Recommended',
          child: _ProductCarousel(products: home.featured),
        ),
        const _BannersGrid(),
        const _ReservationCta(),
        _Section(
          title: 'Recommended Offers',
          child: _ProductCarousel(products: home.offers),
        ),
        _Section(
          title: 'Best Sellers',
          child: _ProductCarousel(products: home.best_sellers),
        ),
        _Section(
          title: 'New Arrivals',
          child: _ProductCarousel(products: home.new_arrivals),
        ),
        const _WhyUsSection(),
        const _ContactUsSection(),
      ],
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFFB98200)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadii.radiusXxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Tires. Your Journey.',
            style: TextStyle(color: AppColors.onPrimary, fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          const Text(
            'Shop premium tires and batteries at the best prices.',
            style: TextStyle(color: AppColors.onPrimary, fontSize: 13),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.background,
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: AppRadii.radiusFull),
            ),
            onPressed: () => context.go('/store'),
            child: const Text('Shop Now'),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _ProductCarousel extends StatelessWidget {
  const _ProductCarousel({required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text('No products yet.', style: TextStyle(color: AppColors.gray2)),
      );
    }
    return SizedBox(
      height: 272,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: products.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) => ProductCard(product: products[index]),
      ),
    );
  }
}

class _BannersGrid extends StatelessWidget {
  const _BannersGrid();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _BannerTile(label: 'Tires', icon: Icons.trip_origin, onTap: () => context.go('/store'))),
          const SizedBox(width: 12),
          Expanded(child: _BannerTile(label: 'Batteries', icon: Icons.battery_charging_full, onTap: () => context.go('/store'))),
        ],
      ),
    );
  }
}

class _BannerTile extends StatelessWidget {
  const _BannerTile({required this.label, required this.icon, required this.onTap});

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        decoration: BoxDecoration(color: AppColors.gray3, borderRadius: AppRadii.radiusXl),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _ReservationCta extends StatelessWidget {
  const _ReservationCta();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.gray3, borderRadius: AppRadii.radiusXl),
      child: Row(
        children: [
          const Icon(Icons.event_available, color: AppColors.primary, size: 32),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Book a service appointment at your nearest branch',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: () => context.go('/reservation'),
            child: const Text('Book Now', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}

class _WhyUsSection extends StatelessWidget {
  const _WhyUsSection();

  static const _items = [
    (icon: Icons.verified_outlined, title: 'Genuine Products', subtitle: 'Only authentic, warrantied parts.'),
    (icon: Icons.local_shipping_outlined, title: 'Fast Delivery', subtitle: 'Nationwide shipping & fitting.'),
    (icon: Icons.support_agent_outlined, title: 'Expert Support', subtitle: 'Advice from certified technicians.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Why Us', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          for (final item in _items)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                    child: Icon(item.icon, color: AppColors.onPrimary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        Text(item.subtitle, style: const TextStyle(color: AppColors.gray2, fontSize: 12)),
                      ],
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

class _ContactUsSection extends StatelessWidget {
  const _ContactUsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.gray3, borderRadius: AppRadii.radiusXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Need help?', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
          SizedBox(height: 8),
          Row(children: [
            Icon(Icons.phone, color: AppColors.primary, size: 16),
            SizedBox(width: 8),
            Text('19XXX (Hotline)', style: TextStyle(color: AppColors.gray2, fontSize: 13)),
          ]),
          SizedBox(height: 4),
          Row(children: [
            Icon(Icons.email_outlined, color: AppColors.primary, size: 16),
            SizedBox(width: 8),
            Text('support@tiremax.com', style: TextStyle(color: AppColors.gray2, fontSize: 13)),
          ]),
        ],
      ),
    );
  }
}

class _HomeLoading extends StatelessWidget {
  const _HomeLoading();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ShimmerBox(height: 160, width: double.infinity),
        SizedBox(height: 16),
        ShimmerBox(height: 220, width: double.infinity),
        SizedBox(height: 16),
        ShimmerBox(height: 90, width: double.infinity),
      ],
    );
  }
}

class _HomeError extends StatelessWidget {
  const _HomeError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 100),
        const Icon(Icons.error_outline, color: AppColors.error, size: 48),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.gray2)),
        ),
        const SizedBox(height: 12),
        Center(child: TextButton(onPressed: onRetry, child: const Text('Retry'))),
      ],
    );
  }
}
