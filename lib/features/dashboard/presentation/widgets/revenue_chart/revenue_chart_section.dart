import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../providers/dashboard_providers.dart';
import '../../utils/dashboard_load_utils.dart';
import 'revenue_chart.dart';
import 'revenue_chart_toggle.dart';

class RevenueChartSection extends ConsumerWidget {
  const RevenueChartSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardControllerProvider);
    final chartPeriod = ref.watch(revenueChartControllerProvider).selectedPeriod;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Revenue Chart',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                RevenueChartToggle(
                  selectedPeriod: chartPeriod,
                  onPeriodChanged: (period) async {
                    ref.read(revenueChartControllerProvider).setPeriod(period);
                    await loadDashboard(ref);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (dashboard.isLoading && dashboard.revenuePoints.isEmpty)
              const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              )
            else
              RevenueChart(points: dashboard.revenuePoints),
          ],
        ),
      ),
    );
  }
}
