/// A row in the top/least selling product lists.
class ProductSalesEntity {
  final int rank;
  final String productName;
  final String category;
  final int unitsSold;
  final double revenue;

  const ProductSalesEntity({
    required this.rank,
    required this.productName,
    required this.category,
    required this.unitsSold,
    required this.revenue,
  });
}
