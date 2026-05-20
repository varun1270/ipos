import '../entities/dashboard_filter.dart';
import '../entities/product_sales_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetLeastSellingProductsUseCase {
  final DashboardRepository repository;

  const GetLeastSellingProductsUseCase(this.repository);

  Future<List<ProductSalesEntity>> call({required DashboardFilter filter}) {
    return repository.getLeastSellingProducts(filter: filter);
  }
}
