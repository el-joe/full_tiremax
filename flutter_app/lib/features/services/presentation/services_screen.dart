import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../shared/widgets/shimmer_box.dart';
import '../data/services_repository.dart';
import '../models/service.dart';

/// Services list screen, mirroring `frontend/app/[locale]/services/page.tsx`.
/// Each card's "Book now" CTA navigates to the reservation route with
/// `service_id` pre-selected, mirroring the web's
/// `services/reservation?service_id=X` deep link.
class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, title: const Text('Services')),
      body: SafeArea(
        child: servicesAsync.when(
          data: (services) {
            if (services.isEmpty) {
              return const Center(child: Text('No services available.', style: TextStyle(color: AppColors.gray2)));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: services.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _ServiceCard(service: services[index]),
            );
          },
          loading: () => ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              ShimmerBox(height: 110, width: double.infinity),
              SizedBox(height: 12),
              ShimmerBox(height: 110, width: double.infinity),
            ],
          ),
          error: (error, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$error', style: const TextStyle(color: AppColors.gray2)),
                const SizedBox(height: 12),
                TextButton(onPressed: () => ref.invalidate(servicesProvider), child: const Text('Retry')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service});

  final Service service;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.gray3, borderRadius: AppRadii.radiusXl),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: const Icon(Icons.build, color: AppColors.onPrimary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.name, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                if (service.description != null && service.description!.isNotEmpty) ...[
                  Text(
                    service.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.gray2, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                ],
                Row(
                  children: [
                    Text('${service.price} EGP', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 10),
                    Text('${service.duration_minutes} min', style: const TextStyle(color: AppColors.gray2, fontSize: 12)),
                    const Spacer(),
                    TextButton(
                      onPressed: () => context.push('/reservation?service_id=${service.id}'),
                      child: const Text('Book now'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
