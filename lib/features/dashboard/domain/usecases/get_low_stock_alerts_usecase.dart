import '../entities/dashboard_filter.dart';
import '../entities/low_stock_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetLowStockAlertsUseCase {
  final DashboardRepository repository;

  const GetLowStockAlertsUseCase(this.repository);

  Future<List<LowStockEntity>> call({required DashboardFilter filter}) {
    return repository.getLowStockAlerts(filter: filter);
  }
}
