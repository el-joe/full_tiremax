import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/product_card.dart';
import '../../../shared/widgets/shimmer_box.dart';
import '../data/offers_repository.dart';
import '../models/flash_sale.dart';

class FlashSaleDetailScreen extends ConsumerWidget {
  const FlashSaleDetailScreen({super.key, required this.flashSale});

  final FlashSale flashSale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(flashSaleProductsProvider(flashSale.id));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, title: Text(flashSale.title)),
      body: SafeArea(
        child: productsAsync.when(
          data: (products) {
            if (products.isEmpty) {
              return const Center(child: Text('No products in this flash sale.', style: TextStyle(color: AppColors.gray2)));
            }
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.58,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) => ProductCard(product: products[index], width: double.infinity),
            );
          },
          loading: () => GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.58,
            ),
            itemCount: 6,
            itemBuilder: (context, index) => const ShimmerBox(width: double.infinity, height: double.infinity),
          ),
          error: (error, _) => Center(child: Text('$error', style: const TextStyle(color: AppColors.gray2))),
        ),
      ),
    );
  }
}
