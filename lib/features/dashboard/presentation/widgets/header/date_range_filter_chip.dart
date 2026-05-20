import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/enums/date_range_filter.dart';
import '../../providers/dashboard_providers.dart';
import '../../utils/dashboard_load_utils.dart';

class DateRangeFilterChip extends ConsumerWidget {
  const DateRangeFilterChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(dateRangeFilterControllerProvider).selected;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: DateRangeFilter.values.map((filter) {
          final isSelected = selected == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 4),
            child: ChoiceChip(
              label: Text(filter.label),
              selected: isSelected,
              onSelected: (_) async {
                ref.read(dateRangeFilterControllerProvider).setFilter(filter);
                await loadDashboard(ref);
              },
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
