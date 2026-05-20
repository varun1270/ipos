import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/dashboard_providers.dart';
import '../shared/dashboard_section_header.dart';
import 'low_stock_tile.dart';

class LowStockAlertsSection extends ConsumerWidget {
  const LowStockAlertsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alerts = ref.watch(dashboardControllerProvider).lowStockAlerts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DashboardSectionHeader(
          title: 'Low Stock Alerts',
          actionLabel: 'View all',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: alerts.isEmpty
              ? const SizedBox(
                  height: 120,
                  child: Center(child: CircularProgressIndicator()),
                )
              : Column(
                  children: alerts
                      .map((item) => LowStockTile(item: item))
                      .toList(),
                ),
        ),
      ],
    );
  }
}
