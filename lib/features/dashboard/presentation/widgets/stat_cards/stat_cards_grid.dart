import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/responsive_utils.dart';
import '../../../domain/entities/dashboard_stats_entity.dart';
import '../../providers/dashboard_providers.dart';
import '../../utils/dashboard_format_utils.dart';
import '../../utils/dashboard_responsive.dart';
import 'stat_card.dart';

class StatCardsGrid extends ConsumerWidget {
  const StatCardsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardControllerProvider);
    final dateRange = ref.watch(dateRangeFilterControllerProvider).selected;
    final stats = dashboard.stats;

    if (stats == null) {
      return SizedBox(
        height: context.responsiveValue(compact: 220, medium: 160, expanded: 150),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return GridView.count(
      crossAxisCount: DashboardResponsive.statCardColumns(context),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: DashboardResponsive.columnGap(context),
      crossAxisSpacing: DashboardResponsive.columnGap(context),
      childAspectRatio: DashboardResponsive.statCardAspectRatio(context),
      children: stats.metrics
          .toList()
          .asMap()
          .entries
          .map(
            (entry) => StatCard(
              index: entry.key,
              title: entry.value.title,
              value: _formatValue(
                entry.value,
                entry.value.valueFor(dateRange),
              ),
              trendPercent: entry.value.trendFor(dateRange),
              subLabel: dateRange.comparisonLabel,
            ),
          )
          .toList(),
    );
  }

  String _formatValue(StatMetricEntity metric, double value) {
    final isCurrency =
        metric.title == 'Revenue' || metric.title == 'Avg Order';

    if (isCurrency) {
      return formatDashboardCurrency(value);
    }

    return formatDashboardNumber(value.round());
  }
}
