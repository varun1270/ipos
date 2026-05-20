/// Severity for a low-stock alert row.
enum StockAlertLevel {
  critical,
  warning;

  String get label => switch (this) {
    StockAlertLevel.critical => 'Critical',
    StockAlertLevel.warning => 'Low',
  };
}
