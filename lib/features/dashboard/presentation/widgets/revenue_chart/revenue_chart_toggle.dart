import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/enums/revenue_chart_period.dart';

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
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: RevenueChartPeriod.values.map((period) {
          final isSelected = selectedPeriod == period;

          return Padding(
            padding: const EdgeInsets.only(right: 4),
            child: ChoiceChip(
              label: Text(period.label),
              selected: isSelected,
              onSelected: (_) => onPeriodChanged(period),
              selectedColor: AppColors.background,
              backgroundColor: Colors.transparent,
              labelStyle: TextStyle(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 13,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }
}
