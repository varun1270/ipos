import '../enums/stock_alert_level.dart';

/// A row in the low stock alerts list.
class LowStockEntity {
  final String productId;
  final String productName;
  final int currentQuantity;
  final int reorderLevel;
  final String unit;
  final StockAlertLevel alertLevel;

  const LowStockEntity({
    required this.productId,
    required this.productName,
    required this.currentQuantity,
    required this.reorderLevel,
    required this.unit,
    required this.alertLevel,
  });
}
