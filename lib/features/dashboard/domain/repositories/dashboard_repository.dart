import '../entities/category_breakdown_entity.dart';
import '../entities/dashboard_filter.dart';
import '../entities/dashboard_stats_entity.dart';
import '../entities/low_stock_entity.dart';
import '../entities/product_sales_entity.dart';
import '../entities/revenue_point_entity.dart';
import '../enums/revenue_chart_period.dart';

abstract class DashboardRepository {
  Future<DashboardStatsEntity> getStats({required DashboardFilter filter});

  Future<List<RevenuePointEntity>> getRevenueChart({
    required RevenueChartPeriod period,
    DashboardFilter? filter,
  });

  Future<List<CategoryBreakdownEntity>> getCategoryBreakdown({
    required DashboardFilter filter,
  });

  Future<List<ProductSalesEntity>> getTopSellingProducts({
    required DashboardFilter filter,
  });

  Future<List<ProductSalesEntity>> getLeastSellingProducts({
    required DashboardFilter filter,
  });

  Future<List<LowStockEntity>> getLowStockAlerts({
    required DashboardFilter filter,
  });
}
