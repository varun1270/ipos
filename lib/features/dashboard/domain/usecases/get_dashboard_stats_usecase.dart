import '../entities/dashboard_filter.dart';
import '../entities/dashboard_stats_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardStatsUseCase {
  final DashboardRepository repository;

  const GetDashboardStatsUseCase(this.repository);

  Future<DashboardStatsEntity> call({required DashboardFilter filter}) {
    return repository.getStats(filter: filter);
  }
}
