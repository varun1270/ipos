import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/responsive_utils.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/enums/revenue_chart_period.dart';
import '../../providers/dashboard_providers.dart';
import '../../utils/dashboard_load_utils.dart';
import '../shared/dashboard_3d_styles.dart';
import 'revenue_chart.dart';
import 'revenue_chart_toggle.dart';

class RevenueChartSection extends ConsumerWidget {
  final bool inRow;

  const RevenueChartSection({super.key, this.inRow = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardControllerProvider);
    final chartPeriod = ref.watch(revenueChartControllerProvider).selectedPeriod;
    final chartHeight = context.responsiveValue(
      compact: 210.0,
      medium: 240.0,
      expanded: 280.0,
    );

    return Dashboard3DSurface.panel(
      accent: AppColors.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, ref, chartPeriod),
          const SizedBox(height: 16),
          if (dashboard.isLoading && dashboard.revenuePoints.isEmpty)
            SizedBox(
              height: chartHeight,
              child: const Center(child: CircularProgressIndicator()),
            )
          else
            SizedBox(
              height: chartHeight,
              child: RevenueChart(points: dashboard.revenuePoints),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    RevenueChartPeriod chartPeriod,
  ) {
    final stackHeader = context.responsiveValue(
      compact: true,
      medium: false,
      expanded: false,
    );

    if (stackHeader) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(context),
          const SizedBox(height: 12),
          RevenueChartToggle(
            selectedPeriod: chartPeriod,
            onPeriodChanged: (period) => _onPeriodChanged(ref, period),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: _title(context)),
        RevenueChartToggle(
          selectedPeriod: chartPeriod,
          onPeriodChanged: (period) => _onPeriodChanged(ref, period),
        ),
      ],
    );
  }

  Widget _title(BuildContext context) {
    return Text(
      'Revenue Chart',
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: context.responsiveValue(compact: 18, medium: 19, expanded: 20),
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Future<void> _onPeriodChanged(
    WidgetRef ref,
    RevenueChartPeriod period,
  ) async {
    ref.read(revenueChartControllerProvider).setPeriod(period);
    await loadDashboard(ref);
  }
}
