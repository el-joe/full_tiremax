import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../shared/widgets/shimmer_box.dart';
import '../data/offers_repository.dart';
import '../models/flash_sale.dart';
import 'flash_sale_detail_screen.dart';

/// Offers / flash sales list, mirroring
/// `frontend/app/[locale]/(productsView)/offers/**`.
class OffersScreen extends ConsumerWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flashSalesAsync = ref.watch(flashSalesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, title: const Text('Offers')),
      body: SafeArea(
        child: flashSalesAsync.when(
          data: (sales) {
            if (sales.isEmpty) {
              return const Center(child: Text('No active offers right now.', style: TextStyle(color: AppColors.gray2)));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: sales.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _FlashSaleCard(flashSale: sales[index]),
            );
          },
          loading: () => ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              ShimmerBox(height: 100, width: double.infinity),
              SizedBox(height: 12),
              ShimmerBox(height: 100, width: double.infinity),
            ],
          ),
          error: (error, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$error', style: const TextStyle(color: AppColors.gray2)),
                const SizedBox(height: 12),
                TextButton(onPressed: () => ref.invalidate(flashSalesProvider), child: const Text('Retry')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FlashSaleCard extends StatefulWidget {
  const _FlashSaleCard({required this.flashSale});

  final FlashSale flashSale;

  @override
  State<_FlashSaleCard> createState() => _FlashSaleCardState();
}

class _FlashSaleCardState extends State<_FlashSaleCard> {
  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final endsAt = widget.flashSale.ends_at;
    if (endsAt == null) return;
    final end = DateTime.tryParse(endsAt);
    if (end == null) return;
    final remaining = end.difference(DateTime.now());
    if (mounted) {
      setState(() => _remaining = remaining.isNegative ? Duration.zero : remaining);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _format(Duration d) {
    final days = d.inDays;
    final hours = d.inHours % 24;
    final minutes = d.inMinutes % 60;
    final seconds = d.inSeconds % 60;
    if (days > 0) return '${days}d ${hours}h ${minutes}m';
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final sale = widget.flashSale;
    final ended = sale.ends_at != null && _remaining == Duration.zero;

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => FlashSaleDetailScreen(flashSale: sale)),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [AppColors.gray3, Color(0xFF1B1B1B)]),
          borderRadius: AppRadii.radiusXl,
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              child: const Icon(Icons.bolt, color: AppColors.onPrimary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(sale.title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text('${sale.discount_percent}% OFF', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(
                    ended ? 'Ended' : 'Ends in ${_format(_remaining)}',
                    style: const TextStyle(color: AppColors.gray2, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.gray2),
          ],
        ),
      ),
    );
  }
}
