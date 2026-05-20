import '../entities/dashboard_filter.dart';
import '../entities/product_sales_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetTopSellingProductsUseCase {
  final DashboardRepository repository;

  const GetTopSellingProductsUseCase(this.repository);

  Future<List<ProductSalesEntity>> call({required DashboardFilter filter}) {
    return repository.getTopSellingProducts(filter: filter);
  }
}
