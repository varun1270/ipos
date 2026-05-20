import '../../domain/enums/revenue_chart_period.dart';
import '../dto/dashboard_filter_dto.dart';
import '../mock/dashboard_mock_data.dart';
import '../models/category_breakdown_model.dart';
import '../models/dashboard_stats_model.dart';
import '../models/low_stock_model.dart';
import '../models/product_sales_model.dart';
import '../models/revenue_point_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardStatsModel> getStats(DashboardFilterDto filter);

  Future<List<RevenuePointModel>> getRevenueChart({
    required RevenueChartPeriod period,
    DashboardFilterDto? filter,
  });

  Future<List<CategoryBreakdownModel>> getCategoryBreakdown(
    DashboardFilterDto filter,
  );

  Future<List<ProductSalesModel>> getTopSellingProducts(
    DashboardFilterDto filter,
  );

  Future<List<ProductSalesModel>> getLeastSellingProducts(
    DashboardFilterDto filter,
  );

  Future<List<LowStockModel>> getLowStockAlerts(DashboardFilterDto filter);
}

class MockDashboardRemoteDataSource implements DashboardRemoteDataSource {
  static const _mockDelay = Duration(milliseconds: 300);

  @override
  Future<DashboardStatsModel> getStats(DashboardFilterDto filter) async {
    await Future.delayed(_mockDelay);
    return DashboardMockData.stats;
  }

  @override
  Future<List<RevenuePointModel>> getRevenueChart({
    required RevenueChartPeriod period,
    DashboardFilterDto? filter,
  }) async {
    await Future.delayed(_mockDelay);

    return switch (period) {
      RevenueChartPeriod.day => DashboardMockData.revenueChartDay,
      RevenueChartPeriod.week => DashboardMockData.revenueChartWeek,
      RevenueChartPeriod.month => DashboardMockData.revenueChartMonth,
    };
  }

  @override
  Future<List<CategoryBreakdownModel>> getCategoryBreakdown(
    DashboardFilterDto filter,
  ) async {
    await Future.delayed(_mockDelay);
    return DashboardMockData.categoryBreakdown;
  }

  @override
  Future<List<ProductSalesModel>> getTopSellingProducts(
    DashboardFilterDto filter,
  ) async {
    await Future.delayed(_mockDelay);
    return DashboardMockData.topSellingProducts;
  }

  @override
  Future<List<ProductSalesModel>> getLeastSellingProducts(
    DashboardFilterDto filter,
  ) async {
    await Future.delayed(_mockDelay);
    return DashboardMockData.leastSellingProducts;
  }

  @override
  Future<List<LowStockModel>> getLowStockAlerts(
    DashboardFilterDto filter,
  ) async {
    await Future.delayed(_mockDelay);
    return DashboardMockData.lowStockAlerts;
  }
}