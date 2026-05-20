import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../shared/trend_indicator.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final double trendPercent;
  final String subLabel;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.trendPercent,
    required this.subLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              TrendIndicator(trendPercent: trendPercent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  subLabel,
                  style: const TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
