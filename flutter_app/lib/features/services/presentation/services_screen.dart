import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/services_repository.dart';
import '../models/service.dart';

/// Services tab: compact list of bookable services (`GET /services`), each
/// with a Book now action that opens the reservation flow with `service_id`
/// pre-selected, plus a single "book appointment" CTA at the end.
class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider);
    final l10n = context.l10n;

    return AppScaffold(
      title: l10n.navServices,
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(servicesProvider.future),
        child: servicesAsync.when(
          loading: () => const SkeletonList(itemHeight: 112),
          error: (error, _) => _Scrollable(
            child: ErrorState(
              message: error.toString(),
              onRetry: () => ref.invalidate(servicesProvider),
            ),
          ),
          data: (services) => services.isEmpty
              ? _Scrollable(
                  child: EmptyState(
                    icon: Icons.build_outlined,
                    title: l10n.completeVehicleServices,
                  ),
                )
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(AppSpacing.gutter),
                  itemCount: services.length + 2,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, i) {
                    if (i == 0) {
                      return Text(
                        l10n.completeVehicleServices,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.foregroundLight,
                        ),
                      );
                    }
                    if (i == services.length + 1) {
                      return Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.sm),
                        child: PrimaryButton(
                          label: l10n.bookYourAppointmentNow,
                          icon: Icons.calendar_month_outlined,
                          onPressed: () => context.push('/reservation'),
                        ),
                      );
                    }
                    return _ServiceCard(service: services[i - 1]);
                  },
                ),
        ),
      ),
    );
  }
}

/// Lets empty/error states stay pull-to-refresh friendly.
class _Scrollable extends StatelessWidget {
  const _Scrollable({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(height: c.maxHeight, child: child),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service});

  final Service service;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hasImage = service.image_url != null && service.image_url!.isNotEmpty;
    final description = service.description ?? '';
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      onTap: () => context.push('/reservation?service_id=${service.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 88,
                  height: 88,
                  child: hasImage
                      ? AppNetworkImage(
                          url: service.image_url,
                          width: 88,
                          height: 88,
                        )
                      : Image.asset(
                          'assets/images/serviceImage.jpg',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.foregroundLight,
                      ),
                    ),
                    if (description.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.gray2,
                        ),
                      ),
                    ],
                    if (service.duration_minutes > 0) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule,
                            size: 14,
                            color: AppColors.gray2,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Flexible(
                            child: Text(
                              l10n.durationMinutes(service.duration_minutes),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.gray2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SecondaryButton(
            label: l10n.bookNow,
            onPressed: () =>
                context.push('/reservation?service_id=${service.id}'),
          ),
        ],
      ),
    );
  }
}
