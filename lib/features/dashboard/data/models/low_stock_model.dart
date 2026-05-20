import '../../domain/entities/low_stock_entity.dart';
import '../../domain/enums/stock_alert_level.dart';

class LowStockModel extends LowStockEntity {
  const LowStockModel({
    required super.productId,
    required super.productName,
    required super.currentQuantity,
    required super.reorderLevel,
    required super.unit,
    required super.alertLevel,
  });

  factory LowStockModel.fromJson(Map<String, dynamic> json) {
    return LowStockModel(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      currentQuantity: json['currentQuantity'] as int,
      reorderLevel: json['reorderLevel'] as int,
      unit: json['unit'] as String,
      alertLevel: StockAlertLevel.values.byName(json['alertLevel'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'currentQuantity': currentQuantity,
      'reorderLevel': reorderLevel,
      'unit': unit,
      'alertLevel': alertLevel.name,
    };
  }
}
