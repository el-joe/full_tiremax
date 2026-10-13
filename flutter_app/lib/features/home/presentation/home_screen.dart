import '../../../l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/shimmer_box.dart';
import '../../../shared/widgets/web_sheet.dart';
import '../../settings/data/public_settings_repository.dart';
import '../../store/data/store_repository.dart';
import '../../store/presentation/widgets/tabs_filter_by.dart';
import '../models/home_res.dart';
import '../providers/home_provider.dart';

const _black2 = Color(0xFF101828);

/// Home screen mirroring `frontend/app/[locale]/page.tsx`, in the same section
/// order: Hero, Recommended tires, Banners grid, Reservation, Recommended
/// offers, Why us (+ testimonials), Contact us. Fetches `GET /home`.
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
        const _HeroSection(),
        WebSheet(
          roundedBottom: true,
          child: Column(
            children: [
              SectionHeader(title: context.l10n.recommendedTiresForYou, showAllRoute: '/store?filter_products_type=tire'),
              ProductGrid(products: home.featured),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const _BannersGridSection(),
        const _ReservationSection(),
        WebSheet(
          roundedBottom: true,
          child: Column(
            children: [
              SectionHeader(title: context.l10n.recommendedOffersForYou, showAllRoute: '/store?filter_products_badge=special_offer'),
              ProductGrid(products: home.offers),
            ],
          ),
        ),
        const _WhyUsSection(),
        const _ContactUsSection(),
      ],
    );
  }
}

// ---------------------------------------------------------------- Hero

class _HeroSection extends StatefulWidget {
  const _HeroSection();

  @override
  State<_HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<_HeroSection> {
  ProductFilters _filters = const ProductFilters();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/images/heroBg.png', fit: BoxFit.cover)),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: AlignmentDirectional.centerStart,
                  end: AlignmentDirectional.centerEnd,
                  colors: const [Colors.black, Color(0x66000000), Color(0x00000000)],
                  stops: const [0, 0.5, 1],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 22, 16, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '${context.l10n.controlStartsWith} '),
                      TextSpan(text: context.l10n.theRightTire, style: TextStyle(color: AppColors.primary)),
                    ],
                  ),
                  style: const TextStyle(fontSize: 48, height: 1, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                const SizedBox(height: 18),
                Text(context.l10n.heroSubtitle, style: TextStyle(fontSize: 14, color: Colors.white)),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                      ),
                      onPressed: () => launchUrl(
                        Uri.parse('https://www.facebook.com/share/r/1JqGzYrFZD/'),
                        mode: LaunchMode.externalApplication,
                      ),
                      icon: const Icon(Icons.play_circle_outline, size: 20),
                      label: Text(context.l10n.watchVideo, style: TextStyle(fontSize: 14)),
                      iconAlignment: IconAlignment.end,
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15)),
                      onPressed: () => context.go('/store'),
                      icon: const Icon(Icons.arrow_forward, size: 18),
                      iconAlignment: IconAlignment.end,
                      label: Text(context.l10n.chooseYourTireNow, style: TextStyle(fontSize: 14)),
                    ),
                  ],
                ),
                const SizedBox(height: 44),
                TabsFilterBy(
                  filters: _filters,
                  onChanged: (f) => setState(() => _filters = f),
                  submitLabel: context.l10n.findYourTireNow,
                  onSubmit: () => context.go('/store', extra: _filters),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------- Banners

class _BannersGridSection extends StatelessWidget {
  const _BannersGridSection();

  @override
  Widget build(BuildContext context) {
    return WebSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.allInOneSolutionsForYourVehicle,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.foregroundLight),
          ),
          const SizedBox(height: 32),
          Text(context.l10n.allInOneDescription, style: TextStyle(fontSize: 18, color: AppColors.foregroundLight)),
          const SizedBox(height: 31),
          _BannerTile(image: 'maintenanceServicesBg.jpg', label: context.l10n.maintenanceServices, height: 258),
          const SizedBox(height: 12),
          _BannerTile(image: 'bookAtTheCenterBg.jpg', label: context.l10n.maintenanceServices, height: 185),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _BannerTile(image: 'battaryInstallationBg.jpg', label: context.l10n.batteryInstallation, height: 185, small: true)),
              SizedBox(width: 12),
              Expanded(child: _BannerTile(image: 'tireInstallationBg.jpg', label: context.l10n.tireInstallation, height: 185, small: true)),
            ],
          ),
        ],
      ),
    );
  }
}

class _BannerTile extends StatelessWidget {
  const _BannerTile({required this.image, required this.label, required this.height, this.small = false});

  final String image;
  final String label;
  final double height;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/$image', fit: BoxFit.cover),
            // Web: `absolute bottom-4 left-4`; mirrored via start in RTL.
            PositionedDirectional(
              start: small ? 8 : 16,
              bottom: 16,
              child: GestureDetector(
                onTap: () => context.go('/services'),
                child: Container(
                  padding: EdgeInsets.all(small ? 4 : 10),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    label,
                    style: TextStyle(fontSize: small ? 14 : 16, color: AppColors.foregroundLight),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- Reservation

class _ReservationSection extends ConsumerWidget {
  const _ReservationSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAr = ref.watch(localeProvider).languageCode == 'ar';
    Widget item(IconData icon, String text) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0x4DFFFFFF), borderRadius: BorderRadius.circular(14)),
                child: Icon(icon, size: 20, color: _black2),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(text, style: const TextStyle(fontSize: 18, color: AppColors.foregroundLight))),
            ],
          ),
        );

    return Padding(
      padding: const EdgeInsets.only(bottom: 21),
      child: WebSheet(
        color: AppColors.primary,
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
              decoration: BoxDecoration(
                color: const Color(0x33FFFFFF),
                border: Border.all(color: const Color(0x4DFFFFFF)),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome, size: 14, color: Colors.white),
                  SizedBox(width: 6),
                  Text(context.l10n.quickAndEasyBooking, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              context.l10n.bookYourCarService,
              style: TextStyle(fontSize: 48, height: 60 / 48, fontWeight: FontWeight.w700, color: AppColors.foregroundLight),
            ),
            Text(
              context.l10n.now,
              style: TextStyle(fontSize: 48, height: 60 / 48, fontWeight: FontWeight.w700, color: Colors.white),
            ),
            const SizedBox(height: 28),
            Text(context.l10n.bookServiceDescription, style: TextStyle(fontSize: 24, color: AppColors.foregroundLight)),
            const SizedBox(height: 30),
            item(Icons.check_circle_outline, context.l10n.smartBookingSystemWithoutConflicts),
            item(Icons.build_outlined, context.l10n.professionalMaintenanceBySpecializedTeam),
            item(Icons.calendar_month_outlined, context.l10n.chooseAppointmentAndBranch),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _black2,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              onPressed: () => context.go('/reservation'),
              icon: const Icon(Icons.calendar_month_outlined),
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(child: Text(context.l10n.bookServiceNow, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
            const SizedBox(height: 34),
            Image.asset(isAr ? 'assets/images/reservationSteps.png' : 'assets/images/reservationStepsEN.png'),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- Why us

class _WhyUsSection extends StatelessWidget {
  const _WhyUsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 80, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: context.l10n.whyChoosePrefix),
                TextSpan(text: context.l10n.tireMax, style: TextStyle(color: AppColors.primary)),
              ],
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          const SizedBox(height: 64),
          _WhyUsCard(image: 'whyUsBg1.png', heading: context.l10n.genuineWarranty, text: context.l10n.genuineWarrantyDescription),
          const SizedBox(height: 12),
          // Web reuses genuineWarrantyDescription for this card.
          _WhyUsCard(image: 'whyUsBg2.jpg', heading: context.l10n.routineMaintenance, text: context.l10n.genuineWarrantyDescription),
          const SizedBox(height: 12),
          _WhyUsCard(image: 'whyUsBg3.jpg', heading: context.l10n.quickTurnaround, text: context.l10n.fastServiceDescription),
          const SizedBox(height: 120),
          Text(
            context.l10n.whatOurCustomersSay,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Center(
            child: RatingBarIndicator(
              rating: 5,
              itemSize: 28,
              itemBuilder: (_, _) => const Icon(Icons.star, color: Color(0xFFFFC107)),
            ),
          ),
          const SizedBox(height: 64),
          for (final text in context.l10n.testimonials) ...[
            _ReviewCard(content: text),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _WhyUsCard extends StatelessWidget {
  const _WhyUsCard({required this.image, required this.heading, required this.text});

  final String image;
  final String heading;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(48),
      child: Container(
        height: 180,
        color: const Color(0xFF353534),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Opacity(opacity: 0.4, child: Image.asset('assets/images/$image', fit: BoxFit.cover)),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(heading, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(text, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.testimonialName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
                  Text(context.l10n.testimonialCity, style: TextStyle(fontSize: 12, color: Colors.black)),
                ],
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
          const SizedBox(height: 24),
          Text('"$content"', style: const TextStyle(fontSize: 12, color: AppColors.gray2)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------- Contact

class _ContactUsSection extends ConsumerWidget {
  const _ContactUsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(publicSettingsProvider).value ?? const PublicSettings();
    return WebSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.contactUs,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.foregroundLight),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.contactUsDescription,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.foregroundLight),
          ),
          const SizedBox(height: 8),
          Center(
            child: Container(
              height: 8,
              width: 96,
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          _ContactCard(
            icon: Icons.phone_in_talk_outlined,
            heading: context.l10n.customerServiceNumber,
            info: settings.sitePhone.isEmpty ? '+964 770 000 0000' : settings.sitePhone,
            ltr: true,
          ),
          const SizedBox(height: 9),
          _ContactCard(
            icon: Icons.mark_email_read_outlined,
            heading: context.l10n.email,
            info: settings.siteEmail.isEmpty ? 'info@iraqmaxtire.iq' : settings.siteEmail,
            ltr: true,
          ),
          const SizedBox(height: 9),
          _ContactCard(
            icon: Icons.location_on_outlined,
            heading: context.l10n.headOffice,
            info: settings.address.isEmpty ? '????' : settings.address,
          ),
          const SizedBox(height: 16),
          // The web embeds the contact form here; mobile opens the full form.
          ElevatedButton(
            onPressed: () => context.push('/contact'),
            child: Text(context.l10n.contactUs),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.foregroundLight),
            onPressed: () => context.push('/track-order'),
            child: Text(context.l10n.trackOrder),
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.icon, required this.heading, required this.info, this.ltr = false});

  final IconData icon;
  final String heading;
  final String info;
  final bool ltr;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(heading, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.gray2)),
                Directionality(
                  textDirection: ltr ? TextDirection.ltr : Directionality.of(context),
                  child: Text(info, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.foregroundLight)),
                ),
              ],
            ),
          ),
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
        ShimmerBox(height: 360, width: double.infinity, borderRadius: BorderRadius.all(Radius.circular(50))),
        SizedBox(height: 16),
        ShimmerBox(height: 260, width: double.infinity),
        SizedBox(height: 16),
        ShimmerBox(height: 260, width: double.infinity),
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
        Center(child: TextButton(onPressed: onRetry, child: Text(context.l10n.retry))),
      ],
    );
  }
}
