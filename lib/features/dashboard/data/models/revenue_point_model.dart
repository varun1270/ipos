import '../../domain/entities/revenue_point_entity.dart';

class RevenuePointModel extends RevenuePointEntity {
  const RevenuePointModel({
    required super.label,
    required super.revenue,
    super.date,
  });

  factory RevenuePointModel.fromJson(Map<String, dynamic> json) {
    return RevenuePointModel(
      label: json['label'] as String,
      revenue: (json['revenue'] as num).toDouble(),
      date: json['date'] == null
          ? null
          : DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'revenue': revenue,
      if (date != null) 'date': date!.toIso8601String(),
    };
  }
}
