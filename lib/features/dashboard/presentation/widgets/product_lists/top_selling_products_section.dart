import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/dashboard_providers.dart';
import '../shared/dashboard_section_header.dart';
import 'product_rank_tile.dart';

class TopSellingProductsSection extends ConsumerWidget {
  const TopSellingProductsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(dashboardControllerProvider).topProducts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DashboardSectionHeader(title: 'Top Selling Products'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: products.isEmpty
              ? const SizedBox(
                  height: 120,
                  child: Center(child: CircularProgressIndicator()),
                )
              : Column(
                  children: products
                      .map(
                        (product) => ProductRankTile(
                          product: product,
                          highlightRank: product.rank <= 3,
                        ),
                      )
                      .toList(),
                ),
        ),
      ],
    );
  }
}
