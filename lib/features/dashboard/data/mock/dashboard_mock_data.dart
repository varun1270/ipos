import '../../domain/enums/stock_alert_level.dart';
import '../models/category_breakdown_model.dart';
import '../models/dashboard_stats_model.dart';
import '../models/low_stock_model.dart';
import '../models/product_sales_model.dart';
import '../models/revenue_point_model.dart';

/// Hardcoded dashboard sample data for UI development and demos.
abstract final class DashboardMockData {
  static const shops = <Map<String, String>>[
    {'id': 'all', 'name': 'All Shops'},
    {'id': 'shop-1', 'name': 'IPOS Main Store'},
    {'id': 'shop-2', 'name': 'IPOS Satellite Branch'},
    {'id': 'shop-3', 'name': 'IPOS Express Counter'},
  ];

  static const stats = DashboardStatsModel(
    revenue: StatMetricModel(
      title: 'Revenue',
      todayValue: 72400,
      weekValue: 412500,
      monthValue: 1680000,
      todayTrendPercent: 12.4,
      weekTrendPercent: 8.6,
      monthTrendPercent: 15.2,
    ),
    orders: StatMetricModel(
      title: 'Orders',
      todayValue: 48,
      weekValue: 312,
      monthValue: 1280,
      todayTrendPercent: 6.8,
      weekTrendPercent: -2.1,
      monthTrendPercent: 9.5,
    ),
    avgOrderValue: StatMetricModel(
      title: 'Avg Order',
      todayValue: 1508,
      weekValue: 1322,
      monthValue: 1312,
      todayTrendPercent: 4.2,
      weekTrendPercent: 3.1,
      monthTrendPercent: 1.8,
    ),
    customers: StatMetricModel(
      title: 'Customers',
      todayValue: 39,
      weekValue: 248,
      monthValue: 965,
      todayTrendPercent: -3.5,
      weekTrendPercent: 5.4,
      monthTrendPercent: 11.7,
    ),
  );

  static const revenueChartDay = <RevenuePointModel>[
    RevenuePointModel(label: '9 AM', revenue: 4200),
    RevenuePointModel(label: '10 AM', revenue: 6800),
    RevenuePointModel(label: '11 AM', revenue: 9100),
    RevenuePointModel(label: '12 PM', revenue: 12400),
    RevenuePointModel(label: '1 PM', revenue: 9800),
    RevenuePointModel(label: '2 PM', revenue: 7600),
    RevenuePointModel(label: '3 PM', revenue: 8900),
    RevenuePointModel(label: '4 PM', revenue: 11200),
    RevenuePointModel(label: '5 PM', revenue: 13600),
  ];

  static const revenueChartWeek = <RevenuePointModel>[
    RevenuePointModel(label: 'Mon', revenue: 58200),
    RevenuePointModel(label: 'Tue', revenue: 61400),
    RevenuePointModel(label: 'Wed', revenue: 54800),
    RevenuePointModel(label: 'Thu', revenue: 67200),
    RevenuePointModel(label: 'Fri', revenue: 72800),
    RevenuePointModel(label: 'Sat', revenue: 84200),
    RevenuePointModel(label: 'Sun', revenue: 68900),
  ];

  static const revenueChartMonth = <RevenuePointModel>[
    RevenuePointModel(label: 'W1', revenue: 368000),
    RevenuePointModel(label: 'W2', revenue: 392500),
    RevenuePointModel(label: 'W3', revenue: 415800),
    RevenuePointModel(label: 'W4', revenue: 503700),
  ];

  static const categoryBreakdown = <CategoryBreakdownModel>[
    CategoryBreakdownModel(
      categoryName: 'Groceries',
      revenue: 588000,
      percentage: 35,
      colorHex: '#4F46E5',
    ),
    CategoryBreakdownModel(
      categoryName: 'Beverages',
      revenue: 369600,
      percentage: 22,
      colorHex: '#3B82F6',
    ),
    CategoryBreakdownModel(
      categoryName: 'Snacks',
      revenue: 302400,
      percentage: 18,
      colorHex: '#10B981',
    ),
    CategoryBreakdownModel(
      categoryName: 'Personal Care',
      revenue: 252000,
      percentage: 15,
      colorHex: '#F59E0B',
    ),
    CategoryBreakdownModel(
      categoryName: 'Others',
      revenue: 168000,
      percentage: 10,
      colorHex: '#7C3AED',
    ),
  ];

  static const topSellingProducts = <ProductSalesModel>[
    ProductSalesModel(
      rank: 1,
      productName: 'Amul Taaza Milk 1L',
      category: 'Dairy',
      unitsSold: 186,
      revenue: 16740,
    ),
    ProductSalesModel(
      rank: 2,
      productName: 'Maggi 2-Min Noodles',
      category: 'Snacks',
      unitsSold: 142,
      revenue: 9940,
    ),
    ProductSalesModel(
      rank: 3,
      productName: 'Britannia Good Day',
      category: 'Bakery',
      unitsSold: 118,
      revenue: 8260,
    ),
    ProductSalesModel(
      rank: 4,
      productName: 'Coca-Cola 750ml',
      category: 'Beverages',
      unitsSold: 96,
      revenue: 7680,
    ),
    ProductSalesModel(
      rank: 5,
      productName: 'Fortune Sunflower Oil 1L',
      category: 'Groceries',
      unitsSold: 74,
      revenue: 13320,
    ),
  ];

  static const leastSellingProducts = <ProductSalesModel>[
    ProductSalesModel(
      rank: 1,
      productName: 'Organic Quinoa 500g',
      category: 'Groceries',
      unitsSold: 3,
      revenue: 897,
    ),
    ProductSalesModel(
      rank: 2,
      productName: 'Imported Olive Oil',
      category: 'Groceries',
      unitsSold: 4,
      revenue: 1240,
    ),
    ProductSalesModel(
      rank: 3,
      productName: 'Sugar-Free Cookies',
      category: 'Bakery',
      unitsSold: 5,
      revenue: 450,
    ),
    ProductSalesModel(
      rank: 4,
      productName: 'Herbal Face Wash',
      category: 'Personal Care',
      unitsSold: 6,
      revenue: 1080,
    ),
    ProductSalesModel(
      rank: 5,
      productName: 'Sparkling Water 500ml',
      category: 'Beverages',
      unitsSold: 7,
      revenue: 420,
    ),
  ];

  static const lowStockAlerts = <LowStockModel>[
    LowStockModel(
      productId: 'prod-101',
      productName: 'Parle-G Gold 1kg',
      currentQuantity: 4,
      reorderLevel: 20,
      unit: 'pcs',
      alertLevel: StockAlertLevel.critical,
    ),
    LowStockModel(
      productId: 'prod-102',
      productName: 'Tata Salt 1kg',
      currentQuantity: 8,
      reorderLevel: 25,
      unit: 'pcs',
      alertLevel: StockAlertLevel.critical,
    ),
    LowStockModel(
      productId: 'prod-103',
      productName: 'Lay\'s Classic Salted',
      currentQuantity: 12,
      reorderLevel: 30,
      unit: 'pcs',
      alertLevel: StockAlertLevel.warning,
    ),
    LowStockModel(
      productId: 'prod-104',
      productName: 'Dettol Handwash 200ml',
      currentQuantity: 9,
      reorderLevel: 18,
      unit: 'pcs',
      alertLevel: StockAlertLevel.warning,
    ),
    LowStockModel(
      productId: 'prod-105',
      productName: 'Basmati Rice 5kg',
      currentQuantity: 3,
      reorderLevel: 10,
      unit: 'bags',
      alertLevel: StockAlertLevel.critical,
    ),
  ];
}
