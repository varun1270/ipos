import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class TrendIndicator extends StatelessWidget {
  final double trendPercent;

  const TrendIndicator({super.key, required this.trendPercent});

  @override
  Widget build(BuildContext context) {
    final isPositive = trendPercent >= 0;
    final color = isPositive ? AppColors.success : AppColors.error;
    final icon = isPositive ? Icons.arrow_upward : Icons.arrow_downward;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 2),
          Text(
            '${trendPercent.abs().toStringAsFixed(1)}%',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
