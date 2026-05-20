import 'package:flutter/foundation.dart';

import '../../domain/entities/category_breakdown_entity.dart';
import '../../domain/entities/dashboard_filter.dart';
import '../../domain/entities/dashboard_stats_entity.dart';
import '../../domain/entities/low_stock_entity.dart';
import '../../domain/entities/product_sales_entity.dart';
import '../../domain/entities/revenue_point_entity.dart';
import '../../domain/enums/revenue_chart_period.dart';
import '../../domain/usecases/get_category_breakdown_usecase.dart';
import '../../domain/usecases/get_dashboard_stats_usecase.dart';
import '../../domain/usecases/get_least_selling_products_usecase.dart';
import '../../domain/usecases/get_low_stock_alerts_usecase.dart';
import '../../domain/usecases/get_revenue_chart_usecase.dart';
import '../../domain/usecases/get_top_selling_products_usecase.dart';

class DashboardController extends ChangeNotifier {
  final GetDashboardStatsUseCase _getDashboardStatsUseCase;
  final GetRevenueChartUseCase _getRevenueChartUseCase;
  final GetCategoryBreakdownUseCase _getCategoryBreakdownUseCase;
  final GetTopSellingProductsUseCase _getTopSellingProductsUseCase;
  final GetLeastSellingProductsUseCase _getLeastSellingProductsUseCase;
  final GetLowStockAlertsUseCase _getLowStockAlertsUseCase;

  DashboardController({
    required GetDashboardStatsUseCase getDashboardStatsUseCase,
    required GetRevenueChartUseCase getRevenueChartUseCase,
    required GetCategoryBreakdownUseCase getCategoryBreakdownUseCase,
    required GetTopSellingProductsUseCase getTopSellingProductsUseCase,
    required GetLeastSellingProductsUseCase getLeastSellingProductsUseCase,
    required GetLowStockAlertsUseCase getLowStockAlertsUseCase,
  }) : _getDashboardStatsUseCase = getDashboardStatsUseCase,
       _getRevenueChartUseCase = getRevenueChartUseCase,
       _getCategoryBreakdownUseCase = getCategoryBreakdownUseCase,
       _getTopSellingProductsUseCase = getTopSellingProductsUseCase,
       _getLeastSellingProductsUseCase = getLeastSellingProductsUseCase,
       _getLowStockAlertsUseCase = getLowStockAlertsUseCase;

  bool isLoading = false;
  String? errorMessage;

  DashboardStatsEntity? stats;
  List<RevenuePointEntity> revenuePoints = [];
  List<CategoryBreakdownEntity> categories = [];
  List<ProductSalesEntity> topProducts = [];
  List<ProductSalesEntity> leastProducts = [];
  List<LowStockEntity> lowStockAlerts = [];

  DashboardFilter? _lastFilter;
  RevenueChartPeriod? _lastChartPeriod;

  Future<void> load({
    required DashboardFilter filter,
    required RevenueChartPeriod chartPeriod,
  }) async {
    _lastFilter = filter;
    _lastChartPeriod = chartPeriod;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _getDashboardStatsUseCase(filter: filter),
        _getRevenueChartUseCase(period: chartPeriod, filter: filter),
        _getCategoryBreakdownUseCase(filter: filter),
        _getTopSellingProductsUseCase(filter: filter),
        _getLeastSellingProductsUseCase(filter: filter),
        _getLowStockAlertsUseCase(filter: filter),
      ]);

      stats = results[0] as DashboardStatsEntity;
      revenuePoints = results[1] as List<RevenuePointEntity>;
      categories = results[2] as List<CategoryBreakdownEntity>;
      topProducts = results[3] as List<ProductSalesEntity>;
      leastProducts = results[4] as List<ProductSalesEntity>;
      lowStockAlerts = results[5] as List<LowStockEntity>;
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    final filter = _lastFilter;
    final chartPeriod = _lastChartPeriod;

    if (filter == null || chartPeriod == null) return;

    await load(filter: filter, chartPeriod: chartPeriod);
  }
}
