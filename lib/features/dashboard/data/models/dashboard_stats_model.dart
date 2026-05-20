import '../../domain/entities/dashboard_stats_entity.dart';

class StatMetricModel extends StatMetricEntity {
  const StatMetricModel({
    required super.title,
    required super.todayValue,
    required super.weekValue,
    required super.monthValue,
    required super.todayTrendPercent,
    required super.weekTrendPercent,
    required super.monthTrendPercent,
  });

  factory StatMetricModel.fromJson(Map<String, dynamic> json) {
    return StatMetricModel(
      title: json['title'] as String,
      todayValue: (json['todayValue'] as num).toDouble(),
      weekValue: (json['weekValue'] as num).toDouble(),
      monthValue: (json['monthValue'] as num).toDouble(),
      todayTrendPercent: (json['todayTrendPercent'] as num).toDouble(),
      weekTrendPercent: (json['weekTrendPercent'] as num).toDouble(),
      monthTrendPercent: (json['monthTrendPercent'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'todayValue': todayValue,
      'weekValue': weekValue,
      'monthValue': monthValue,
      'todayTrendPercent': todayTrendPercent,
      'weekTrendPercent': weekTrendPercent,
      'monthTrendPercent': monthTrendPercent,
    };
  }
}

class DashboardStatsModel extends DashboardStatsEntity {
  const DashboardStatsModel({
    required super.revenue,
    required super.orders,
    required super.avgOrderValue,
    required super.customers,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      revenue: StatMetricModel.fromJson(json['revenue'] as Map<String, dynamic>),
      orders: StatMetricModel.fromJson(json['orders'] as Map<String, dynamic>),
      avgOrderValue: StatMetricModel.fromJson(
        json['avgOrderValue'] as Map<String, dynamic>,
      ),
      customers: StatMetricModel.fromJson(
        json['customers'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'revenue': (revenue as StatMetricModel).toJson(),
      'orders': (orders as StatMetricModel).toJson(),
      'avgOrderValue': (avgOrderValue as StatMetricModel).toJson(),
      'customers': (customers as StatMetricModel).toJson(),
    };
  }
}
