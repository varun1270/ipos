import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/enums/revenue_chart_period.dart';
import '../shared/hard_3d_surface.dart';

class RevenueChartToggle extends StatelessWidget {
  final RevenueChartPeriod selectedPeriod;
  final ValueChanged<RevenueChartPeriod> onPeriodChanged;

  const RevenueChartToggle({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Hard3DSurface.light(
      borderRadius: 14,
      depth: 3,
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: RevenueChartPeriod.values.map((period) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Hard3DChip(
              label: period.label,
              color: AppColors.primary,
              selected: selectedPeriod == period,
              onTap: () => onPeriodChanged(period),
            ),
          );
        }).toList(),
      ),
    );
  }
}
