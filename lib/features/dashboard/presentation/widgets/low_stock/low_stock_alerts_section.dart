import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/responsive_utils.dart';
import '../../providers/dashboard_providers.dart';
import '../../utils/dashboard_responsive.dart';
import '../shared/dashboard_section_header.dart';
import 'low_stock_tile.dart';

class LowStockAlertsSection extends ConsumerWidget {
  const LowStockAlertsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alerts = ref.watch(dashboardControllerProvider).lowStockAlerts;
    final columns = DashboardResponsive.lowStockColumns(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const DashboardSectionHeader(
          title: 'Low Stock Alerts',
          actionLabel: 'View all',
        ),
        if (alerts.isEmpty)
          const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          )
        else if (columns == 1)
          Column(
            children: alerts
                .map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: LowStockTile(item: item),
                    ))
                .toList(),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: DashboardResponsive.columnGap(context),
              mainAxisSpacing: DashboardResponsive.columnGap(context),
              childAspectRatio: context.responsiveValue(
                compact: 2.8,
                medium: 3.0,
                expanded: 3.2,
              ),
            ),
            itemCount: alerts.length,
            itemBuilder: (context, index) =>
                LowStockTile(item: alerts[index], inGrid: true),
          ),
      ],
    );
  }
}
