import '../enums/date_range_filter.dart';

/// One stat card metric with values for each date range.
class StatMetricEntity {
  final String title;
  final double todayValue;
  final double weekValue;
  final double monthValue;
  final double todayTrendPercent;
  final double weekTrendPercent;
  final double monthTrendPercent;

  const StatMetricEntity({
    required this.title,
    required this.todayValue,
    required this.weekValue,
    required this.monthValue,
    required this.todayTrendPercent,
    required this.weekTrendPercent,
    required this.monthTrendPercent,
  });

  double valueFor(DateRangeFilter filter) => switch (filter) {
    DateRangeFilter.today => todayValue,
    DateRangeFilter.week => weekValue,
    DateRangeFilter.month => monthValue,
  };

  double trendFor(DateRangeFilter filter) => switch (filter) {
    DateRangeFilter.today => todayTrendPercent,
    DateRangeFilter.week => weekTrendPercent,
    DateRangeFilter.month => monthTrendPercent,
  };
}

/// Domain entity for the 2x2 stat cards section.
class DashboardStatsEntity {
  final StatMetricEntity revenue;
  final StatMetricEntity orders;
  final StatMetricEntity avgOrderValue;
  final StatMetricEntity customers;

  const DashboardStatsEntity({
    required this.revenue,
    required this.orders,
    required this.avgOrderValue,
    required this.customers,
  });

  List<StatMetricEntity> get metrics => [
    revenue,
    orders,
    avgOrderValue,
    customers,
  ];
}
