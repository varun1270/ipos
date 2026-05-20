import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasource/dashboard_remote_datasource.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/usecases/get_category_breakdown_usecase.dart';
import '../../domain/usecases/get_dashboard_stats_usecase.dart';
import '../../domain/usecases/get_least_selling_products_usecase.dart';
import '../../domain/usecases/get_low_stock_alerts_usecase.dart';
import '../../domain/usecases/get_revenue_chart_usecase.dart';
import '../../domain/usecases/get_top_selling_products_usecase.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/date_range_filter_controller.dart';
import '../controllers/revenue_chart_controller.dart';
import '../controllers/shop_selector_controller.dart';

final dashboardRemoteDataSourceProvider =
    Provider<DashboardRemoteDataSource>((ref) {
      return MockDashboardRemoteDataSource();
    });

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(
    remoteDataSource: ref.watch(dashboardRemoteDataSourceProvider),
  );
});

final getDashboardStatsUseCaseProvider = Provider<GetDashboardStatsUseCase>((
  ref,
) {
  return GetDashboardStatsUseCase(ref.watch(dashboardRepositoryProvider));
});

final getRevenueChartUseCaseProvider = Provider<GetRevenueChartUseCase>((ref) {
  return GetRevenueChartUseCase(ref.watch(dashboardRepositoryProvider));
});

final getCategoryBreakdownUseCaseProvider =
    Provider<GetCategoryBreakdownUseCase>((ref) {
      return GetCategoryBreakdownUseCase(ref.watch(dashboardRepositoryProvider));
    });

final getTopSellingProductsUseCaseProvider =
    Provider<GetTopSellingProductsUseCase>((ref) {
      return GetTopSellingProductsUseCase(
        ref.watch(dashboardRepositoryProvider),
      );
    });

final getLeastSellingProductsUseCaseProvider =
    Provider<GetLeastSellingProductsUseCase>((ref) {
      return GetLeastSellingProductsUseCase(
        ref.watch(dashboardRepositoryProvider),
      );
    });

final getLowStockAlertsUseCaseProvider = Provider<GetLowStockAlertsUseCase>((
  ref,
) {
  return GetLowStockAlertsUseCase(ref.watch(dashboardRepositoryProvider));
});

final dateRangeFilterControllerProvider =
    ChangeNotifierProvider<DateRangeFilterController>((ref) {
      return DateRangeFilterController();
    });

final shopSelectorControllerProvider =
    ChangeNotifierProvider<ShopSelectorController>((ref) {
      return ShopSelectorController();
    });

final revenueChartControllerProvider =
    ChangeNotifierProvider<RevenueChartController>((ref) {
      return RevenueChartController();
    });

final dashboardControllerProvider =
    ChangeNotifierProvider<DashboardController>((ref) {
      return DashboardController(
        getDashboardStatsUseCase: ref.watch(getDashboardStatsUseCaseProvider),
        getRevenueChartUseCase: ref.watch(getRevenueChartUseCaseProvider),
        getCategoryBreakdownUseCase: ref.watch(
          getCategoryBreakdownUseCaseProvider,
        ),
        getTopSellingProductsUseCase: ref.watch(
          getTopSellingProductsUseCaseProvider,
        ),
        getLeastSellingProductsUseCase: ref.watch(
          getLeastSellingProductsUseCaseProvider,
        ),
        getLowStockAlertsUseCase: ref.watch(getLowStockAlertsUseCaseProvider),
      );
    });
