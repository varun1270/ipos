/// A single bar/point on the revenue chart.
class RevenuePointEntity {
  final String label;
  final double revenue;
  final DateTime? date;

  const RevenuePointEntity({
    required this.label,
    required this.revenue,
    this.date,
  });
}
