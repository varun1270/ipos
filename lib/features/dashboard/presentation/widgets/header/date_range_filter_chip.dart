import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/enums/date_range_filter.dart';
import '../../providers/dashboard_providers.dart';
import '../../utils/dashboard_load_utils.dart';
import '../shared/hard_3d_surface.dart';

class DateRangeFilterChip extends ConsumerWidget {
  const DateRangeFilterChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(dateRangeFilterControllerProvider).selected;

    return Hard3DSurface.light(
      borderRadius: 16,
      depth: 3,
      padding: const EdgeInsets.all(5),
      expandWidth: true,
      child: Row(
        children: DateRangeFilter.values.map((filter) {
          final isSelected = selected == filter;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Hard3DChip(
                label: filter.label,
                color: AppColors.primary,
                selected: isSelected,
                onTap: () async {
                  ref.read(dateRangeFilterControllerProvider).setFilter(filter);
                  await loadDashboard(ref);
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
