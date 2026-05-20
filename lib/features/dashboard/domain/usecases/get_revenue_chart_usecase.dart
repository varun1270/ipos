import '../entities/dashboard_filter.dart';
import '../entities/revenue_point_entity.dart';
import '../enums/revenue_chart_period.dart';
import '../repositories/dashboard_repository.dart';

class GetRevenueChartUseCase {
  final DashboardRepository repository;

  const GetRevenueChartUseCase(this.repository);

  Future<List<RevenuePointEntity>> call({
    required RevenueChartPeriod period,
    DashboardFilter? filter,
  }) {
    return repository.getRevenueChart(period: period, filter: filter);
  }
}
