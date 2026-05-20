import '../../domain/entities/product_sales_entity.dart';

class ProductSalesModel extends ProductSalesEntity {
  const ProductSalesModel({
    required super.rank,
    required super.productName,
    required super.category,
    required super.unitsSold,
    required super.revenue,
  });

  factory ProductSalesModel.fromJson(Map<String, dynamic> json) {
    return ProductSalesModel(
      rank: json['rank'] as int,
      productName: json['productName'] as String,
      category: json['category'] as String,
      unitsSold: json['unitsSold'] as int,
      revenue: (json['revenue'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'productName': productName,
      'category': category,
      'unitsSold': unitsSold,
      'revenue': revenue,
    };
  }
}
