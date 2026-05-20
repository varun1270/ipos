import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/revenue_point_entity.dart';
import '../../utils/dashboard_format_utils.dart';
import '../shared/dashboard_3d_styles.dart';

class RevenueChart extends StatelessWidget {
  final List<RevenuePointEntity> points;

  const RevenueChart({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return const Center(child: Text('No revenue data'));
    }

    final maxRevenue = points
        .map((point) => point.revenue)
        .reduce((a, b) => a > b ? a : b);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: points.asMap().entries.map((entry) {
            final point = entry.value;
            final index = entry.key;
            final heightFactor =
                maxRevenue == 0 ? 0.0 : point.revenue / maxRevenue;
            final barColor = Color.lerp(
              AppColors.primaryLight,
              AppColors.primaryDark,
              index / (points.length - 1).clamp(1, 999),
            )!;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: FractionallySizedBox(
                          heightFactor: heightFactor.clamp(0.08, 1.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: Dashboard3DStyles.barGradient(barColor),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: barColor.withValues(alpha: 0.35),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                              border: Border(
                                top: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.45),
                                  width: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      point.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatDashboardCurrency(point.revenue),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
