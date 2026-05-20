import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../providers/dashboard_providers.dart';
import '../shared/dashboard_section_header.dart';
import 'category_donut_chart.dart';
import 'category_legend.dart';

class CategoryBreakdownSection extends ConsumerWidget {
  const CategoryBreakdownSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(dashboardControllerProvider).categories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DashboardSectionHeader(title: 'Category Breakdown'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: categories.isEmpty
                ? const SizedBox(
                    height: 160,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CategoryDonutChart(categories: categories),
                      const SizedBox(width: 20),
                      Expanded(child: CategoryLegend(categories: categories)),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
