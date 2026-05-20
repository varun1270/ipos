import '../entities/category_breakdown_entity.dart';
import '../entities/dashboard_filter.dart';
import '../repositories/dashboard_repository.dart';

class GetCategoryBreakdownUseCase {
  final DashboardRepository repository;

  const GetCategoryBreakdownUseCase(this.repository);

  Future<List<CategoryBreakdownEntity>> call({required DashboardFilter filter}) {
    return repository.getCategoryBreakdown(filter: filter);
  }
}
