import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../shared/hard_3d_surface.dart';

class TrendIndicator extends StatelessWidget {
  final double trendPercent;
  final bool onDarkBackground;

  const TrendIndicator({
    super.key,
    required this.trendPercent,
    this.onDarkBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = trendPercent >= 0;
    final color = isPositive ? AppColors.success : AppColors.error;
    final icon = isPositive ? Icons.arrow_upward : Icons.arrow_downward;

    if (onDarkBackground) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: Colors.black.withValues(alpha: 0.18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color == AppColors.success
                ? const Color(0xFF6EE7B7)
                : const Color(0xFFFCA5A5)),
            const SizedBox(width: 2),
            Text(
              '${trendPercent.abs().toStringAsFixed(1)}%',
              style: TextStyle(
                color: color == AppColors.success
                    ? const Color(0xFF6EE7B7)
                    : const Color(0xFFFCA5A5),
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      );
    }

    return Hard3DSurface(
      color: color,
      borderRadius: 999,
      depth: 2,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 2),
          Text(
            '${trendPercent.abs().toStringAsFixed(1)}%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
