import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/dashboard_providers.dart';
import '../shared/dashboard_section_header.dart';
import 'product_rank_tile.dart';

class LeastSellingProductsSection extends ConsumerWidget {
  const LeastSellingProductsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(dashboardControllerProvider).leastProducts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DashboardSectionHeader(title: 'Least Selling Products'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: products.isEmpty
              ? const SizedBox(
                  height: 120,
                  child: Center(child: CircularProgressIndicator()),
                )
              : Column(
                  children: products
                      .map((product) => ProductRankTile(product: product))
                      .toList(),
                ),
        ),
      ],
    );
  }
}
