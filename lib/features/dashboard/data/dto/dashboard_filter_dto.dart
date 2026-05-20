import '../../domain/entities/dashboard_filter.dart';
import '../../domain/enums/date_range_filter.dart';

/// Filters sent with dashboard data requests.
class DashboardFilterDto {
  final String? shopId;
  final bool allShops;
  final DateRangeFilter dateRange;

  const DashboardFilterDto({
    this.shopId,
    this.allShops = true,
    this.dateRange = DateRangeFilter.today,
  });

  DashboardFilterDto copyWith({
    String? shopId,
    bool? allShops,
    DateRangeFilter? dateRange,
  }) {
    return DashboardFilterDto(
      shopId: shopId ?? this.shopId,
      allShops: allShops ?? this.allShops,
      dateRange: dateRange ?? this.dateRange,
    );
  }

  factory DashboardFilterDto.fromDomain(DashboardFilter filter) {
    return DashboardFilterDto(
      shopId: filter.shopId,
      allShops: filter.allShops,
      dateRange: filter.dateRange,
    );
  }
}
