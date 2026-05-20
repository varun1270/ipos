import '../enums/date_range_filter.dart';

/// Active shop + date filters for dashboard queries.
class DashboardFilter {
  final String? shopId;
  final bool allShops;
  final DateRangeFilter dateRange;

  const DashboardFilter({
    this.shopId,
    this.allShops = true,
    this.dateRange = DateRangeFilter.today,
  });

  DashboardFilter copyWith({
    String? shopId,
    bool? allShops,
    DateRangeFilter? dateRange,
  }) {
    return DashboardFilter(
      shopId: shopId ?? this.shopId,
      allShops: allShops ?? this.allShops,
      dateRange: dateRange ?? this.dateRange,
    );
  }
}
