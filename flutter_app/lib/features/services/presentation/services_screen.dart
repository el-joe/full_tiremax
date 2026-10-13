import '../../../l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/shimmer_box.dart';
import '../../../shared/widgets/web_sheet.dart';
import '../data/services_repository.dart';
import '../models/service.dart';

const _fg = AppColors.foregroundLight;

/// Services page mirroring `frontend/app/[locale]/services/page.tsx`:
/// heading, services grid (+ context.l10n.modernTechnology banner card), 4-step journey,
/// "Why choose", dedicated-support features and the reservation CTA banner.
/// context.l10n.headerBookNow opens the reservation flow with `service_id` pre-selected.
class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, title: Text(context.l10n.navServices)),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(servicesProvider.future),
          child: ListView(
            padding: const EdgeInsets.only(top: 8),
            children: [
              WebSheet(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 24, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      context.l10n.completeVehicleServices,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: _fg),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      context.l10n.completeVehicleServicesDescription,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: _fg),
                    ),
                    const SizedBox(height: 44),
                    servicesAsync.when(
                      loading: () => const _ServicesSkeleton(),
                      error: (error, _) => Column(
                        children: [
                          Text('$error', textAlign: TextAlign.center, style: const TextStyle(color: AppColors.gray2)),
                          TextButton(onPressed: () => ref.invalidate(servicesProvider), child: Text(context.l10n.retry)),
                        ],
                      ),
                      data: (services) => _ServicesList(services: services),
                    ),
                    const SizedBox(height: 34),
                    const _ServiceSteps(),
                    const _WhyChoose(),
                    const _FeaturesSection(),
                    const _ReservationBanner(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServicesSkeleton extends StatelessWidget {
  const _ServicesSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: ShimmerBox(height: 260, borderRadius: BorderRadius.all(Radius.circular(24)))),
        SizedBox(width: 16),
        Expanded(child: ShimmerBox(height: 260, borderRadius: BorderRadius.all(Radius.circular(24)))),
      ],
    );
  }
}

class _ServicesList extends StatelessWidget {
  const _ServicesList({required this.services});

  final List<Service> services;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      for (final s in services) _ServiceCard(service: s),
      const _TechBannerCard(),
    ];
    final rows = <Widget>[];
    for (var i = 0; i < items.length; i += 2) {
      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: i + 2 < items.length ? 16 : 0),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: items[i]),
                const SizedBox(width: 16),
                Expanded(child: i + 1 < items.length ? items[i + 1] : const SizedBox.shrink()),
              ],
            ),
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service});

  final Service service;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 40, offset: Offset(0, 10), spreadRadius: -10)],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 140,
            child: service.image_url == null || service.image_url!.isEmpty
                ? Image.asset('assets/images/serviceImage.jpg', fit: BoxFit.cover)
                : AppNetworkImage(url: service.image_url, width: double.infinity, height: 140),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _fg)),
                  const SizedBox(height: 8),
                  Text(service.description ?? '', style: const TextStyle(fontSize: 14, color: AppColors.gray2)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 8),
            child: SizedBox(
              height: 36,
              child: ElevatedButton(
                onPressed: () => context.push('/reservation?service_id=${service.id}'),
                child: Text(context.l10n.bookNow, style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TechBannerCard extends StatelessWidget {
  const _TechBannerCard();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        constraints: const BoxConstraints(minHeight: 400),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/serviceBanner.png', fit: BoxFit.cover),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xE6000000), Color(0x66000000), Color(0x00000000)],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.modernTechnology, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  SizedBox(height: 8),
                  Text(context.l10n.modernTechnologyDescription, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  const _IconBox({required this.icon, required this.bg, required this.color});

  final IconData icon;
  final Color bg;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, size: 18, color: color),
    );
  }
}

class _ServiceSteps extends StatelessWidget {
  const _ServiceSteps();

  static const _icons = [Icons.touch_app_outlined, Icons.calendar_today_outlined, Icons.directions_car_outlined, Icons.verified_user_outlined];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 22),
      decoration: const BoxDecoration(
        color: Color(0xCCF9FAFB),
        borderRadius: BorderRadius.vertical(top: Radius.circular(48)),
      ),
      child: Column(
        children: [
          Text(
            context.l10n.serviceJourneyTitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: _fg),
          ),
          const SizedBox(height: 22),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < context.l10n.journey.length; i++)
                Expanded(
                  child: Column(
                    children: [
                      _IconBox(icon: _icons[i], bg: AppColors.primary, color: Colors.white),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.journey[i].$1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: _fg),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.journey[i].$2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 9, color: AppColors.gray2),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WhyChoose extends StatelessWidget {
  const _WhyChoose();

  static const _icons = [Icons.trip_origin, Icons.verified_user_outlined, Icons.speed, Icons.handyman, Icons.verified_user_outlined];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: const BoxDecoration(
        border: Border.symmetric(horizontal: BorderSide(color: Color(0xFFE4E4E7))),
      ),
      child: Column(
        children: [
          Text(context.l10n.whyChooseTireMaxServices, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: _fg)),
          const SizedBox(height: 22),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < context.l10n.whyChoose.length; i++)
                Expanded(
                  child: Column(
                    children: [
                      _IconBox(icon: _icons[i], bg: const Color(0xFFF9FAFB), color: AppColors.primary),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.whyChoose[i].$1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: _fg),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.whyChoose[i].$2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 8, color: AppColors.gray2),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeaturesSection extends StatelessWidget {
  const _FeaturesSection();

  static const _icons = [Icons.notifications_active_outlined, Icons.support_agent, Icons.add_moderator_outlined, Icons.verified_outlined];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: const Color(0x1AFFB800), borderRadius: BorderRadius.circular(16)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.handshake_outlined, size: 14, color: AppColors.primary),
                  SizedBox(width: 6),
                  Text(context.l10n.dedicatedSupport, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 286),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: context.l10n.ongoingAssistancePrefix),
                  TextSpan(text: context.l10n.dedicatedSupportDescriptionHighlight, style: TextStyle(color: AppColors.primary)),
                ],
              ),
              style: TextStyle(fontSize: 28, height: 48 / 28, fontWeight: FontWeight.w700, color: _fg),
            ),
          ),
          const SizedBox(height: 8),
          Text(context.l10n.customerCareDescription, style: TextStyle(fontSize: 14, color: AppColors.gray2)),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, c) {
              final w = (c.maxWidth - 11) / 2;
              return Wrap(
                spacing: 11,
                runSpacing: 11,
                children: [
                  for (var i = 0; i < context.l10n.features.length; i++)
                    SizedBox(
                      width: w,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _IconBox(icon: _icons[i], bg: AppColors.gray4, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(context.l10n.features[i].$1, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _fg)),
                                Text(context.l10n.features[i].$2, style: const TextStyle(fontSize: 11, color: AppColors.gray2)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 32),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Image.asset('assets/images/servicesFeatureSectionImage.png', width: double.infinity, fit: BoxFit.fitWidth),
              PositionedDirectional(
                bottom: -10,
                start: 0,
                child: Container(
                  width: 102,
                  height: 62,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [BoxShadow(color: Color(0x40000000), blurRadius: 50, offset: Offset(0, 25), spreadRadius: -12)],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                        child: const Icon(Icons.stars_outlined, size: 18, color: Colors.white),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(context.l10n.customerSatisfaction, maxLines: 2, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: AppColors.gray2)),
                            Text('100%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: _fg)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Web ReservationBanner bleeds to the sheet edges (`mx:-16px; mb:-24px`).
class _ReservationBanner extends StatelessWidget {
  const _ReservationBanner();

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset.zero,
      child: Container(
        margin: const EdgeInsetsDirectional.fromSTEB(-16, 0, -16, 0),
        height: 320,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/servicesReserveBanner.png', fit: BoxFit.cover),
            const ColoredBox(color: Color(0x99000000)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    child: Text(
                      context.l10n.ctaTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, height: 1, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    context.l10n.ctaDescription,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Color(0xFFD1D5DB)),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 290,
                    height: 72,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(shadowColor: const Color(0x66FFB800), elevation: 12),
                      onPressed: () => context.push('/reservation'),
                      child: Text(context.l10n.bookYourAppointmentNow, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
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
