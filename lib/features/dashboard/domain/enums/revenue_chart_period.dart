/// Granularity for the revenue chart (separate from the header date filter).
enum RevenueChartPeriod {
  day,
  week,
  month;

  String get label => switch (this) {
    RevenueChartPeriod.day => 'Day',
    RevenueChartPeriod.week => 'Week',
    RevenueChartPeriod.month => 'Month',
  };
}
