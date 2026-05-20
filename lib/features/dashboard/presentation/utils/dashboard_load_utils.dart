import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/dashboard_filter.dart';
import '../providers/dashboard_providers.dart';

DashboardFilter readDashboardFilter(WidgetRef ref) {
  final shopId = ref.read(shopSelectorControllerProvider).selectedShopId;
  final dateRange = ref.read(dateRangeFilterControllerProvider).selected;

  return DashboardFilter(
    shopId: shopId == 'all' ? null : shopId,
    allShops: shopId == 'all',
    dateRange: dateRange,
  );
}

Future<void> loadDashboard(WidgetRef ref) {
  return ref.read(dashboardControllerProvider).load(
    filter: readDashboardFilter(ref),
    chartPeriod: ref.read(revenueChartControllerProvider).selectedPeriod,
  );
}
