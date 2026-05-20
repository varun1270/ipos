import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/dashboard_stats_entity.dart';
import '../../providers/dashboard_providers.dart';
import '../../utils/dashboard_format_utils.dart';
import 'stat_card.dart';

class StatCardsGrid extends ConsumerWidget {
  const StatCardsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardControllerProvider);
    final dateRange = ref.watch(dateRangeFilterControllerProvider).selected;
    final stats = dashboard.stats;

    if (stats == null) {
      return const SizedBox(
        height: 220,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.35,
        children: stats.metrics
            .map(
              (metric) => StatCard(
                title: metric.title,
                value: _formatValue(metric, metric.valueFor(dateRange)),
                trendPercent: metric.trendFor(dateRange),
                subLabel: dateRange.comparisonLabel,
              ),
            )
            .toList(),
      ),
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
