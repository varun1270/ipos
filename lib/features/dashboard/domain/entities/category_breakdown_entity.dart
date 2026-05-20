/// One slice of the category breakdown donut chart.
class CategoryBreakdownEntity {
  final String categoryName;
  final double revenue;
  final double percentage;
  final String colorHex;

  const CategoryBreakdownEntity({
    required this.categoryName,
    required this.revenue,
    required this.percentage,
    required this.colorHex,
  });
}
