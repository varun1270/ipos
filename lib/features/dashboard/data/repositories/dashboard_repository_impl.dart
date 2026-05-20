import '../../domain/entities/category_breakdown_entity.dart';
import '../../domain/entities/dashboard_filter.dart';
import '../../domain/entities/dashboard_stats_entity.dart';
import '../../domain/entities/low_stock_entity.dart';
import '../../domain/entities/product_sales_entity.dart';
import '../../domain/entities/revenue_point_entity.dart';
import '../../domain/enums/revenue_chart_period.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasource/dashboard_remote_datasource.dart';
import '../dto/dashboard_filter_dto.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  const DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DashboardStatsEntity> getStats({required DashboardFilter filter}) {
    return remoteDataSource.getStats(_toDto(filter));
  }

  @override
  Future<List<RevenuePointEntity>> getRevenueChart({
    required RevenueChartPeriod period,
    DashboardFilter? filter,
  }) {
    return remoteDataSource.getRevenueChart(
      period: period,
      filter: filter == null ? null : _toDto(filter),
    );
  }

  @override
  Future<List<CategoryBreakdownEntity>> getCategoryBreakdown({
    required DashboardFilter filter,
  }) {
    return remoteDataSource.getCategoryBreakdown(_toDto(filter));
  }

  @override
  Future<List<ProductSalesEntity>> getTopSellingProducts({
    required DashboardFilter filter,
  }) {
    return remoteDataSource.getTopSellingProducts(_toDto(filter));
  }

  @override
  Future<List<ProductSalesEntity>> getLeastSellingProducts({
    required DashboardFilter filter,
  }) {
    return remoteDataSource.getLeastSellingProducts(_toDto(filter));
  }

  @override
  Future<List<LowStockEntity>> getLowStockAlerts({
    required DashboardFilter filter,
  }) {
    return remoteDataSource.getLowStockAlerts(_toDto(filter));
  }

  DashboardFilterDto _toDto(DashboardFilter filter) {
    return DashboardFilterDto.fromDomain(filter);
  }
}
