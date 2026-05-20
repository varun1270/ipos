import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/dashboard_providers.dart';
import '../shared/dashboard_section_header.dart';
import 'product_rank_tile.dart';

class LeastSellingProductsSection extends ConsumerWidget {
  final bool inRow;

  const LeastSellingProductsSection({super.key, this.inRow = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(dashboardControllerProvider).leastProducts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DashboardSectionHeader(
          title: 'Least Selling Products',
          actionLabel: inRow ? null : 'View all',
        ),
        products.isEmpty
            ? const SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              )
            : Column(
                children: products
                    .map((product) => ProductRankTile(product: product))
                    .toList(),
              ),
      ],
    );
  }
}
