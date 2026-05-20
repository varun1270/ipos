import '../../domain/entities/category_breakdown_entity.dart';

class CategoryBreakdownModel extends CategoryBreakdownEntity {
  const CategoryBreakdownModel({
    required super.categoryName,
    required super.revenue,
    required super.percentage,
    required super.colorHex,
  });

  factory CategoryBreakdownModel.fromJson(Map<String, dynamic> json) {
    return CategoryBreakdownModel(
      categoryName: json['categoryName'] as String,
      revenue: (json['revenue'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
      colorHex: json['colorHex'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryName': categoryName,
      'revenue': revenue,
      'percentage': percentage,
      'colorHex': colorHex,
    };
  }
}
