import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/responsive_utils.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../providers/dashboard_providers.dart';
import '../shared/dashboard_3d_styles.dart';
import '../shared/dashboard_section_header.dart';
import 'category_donut_chart.dart';
import 'category_legend.dart';

class CategoryBreakdownSection extends ConsumerWidget {
  final bool inRow;
  final bool compact;

  const CategoryBreakdownSection({
    super.key,
    this.inRow = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(dashboardControllerProvider).categories;
    final useStackedLayout =
        compact || context.screenSize == AppScreenSize.compact;

    final panel = Dashboard3DSurface.panel(
      accent: context.adaptiveAccentPurple,
      child: categories.isEmpty
          ? SizedBox(
              height: context.responsiveValue(
                compact: 160,
                medium: 220,
                expanded: 320,
              ),
              child: const Center(child: CircularProgressIndicator()),
            )
          : useStackedLayout
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CategoryDonutChart(categories: categories),
                const SizedBox(height: 20),
                CategoryLegend(categories: categories),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CategoryDonutChart(categories: categories),
                SizedBox(
                  width: context.responsiveValue(
                    compact: 20,
                    medium: 24,
                    expanded: 28,
                  ),
                ),
                Expanded(child: CategoryLegend(categories: categories)),
              ],
            ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!inRow) const DashboardSectionHeader(title: 'Category Breakdown'),
        if (inRow)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Category Breakdown',
              style: TextStyle(
                color: context.appColors.textPrimary,
                fontSize: context.responsiveValue(
                  compact: 18,
                  medium: 19,
                  expanded: 20,
                ),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        panel,
      ],
    );
  }
}
