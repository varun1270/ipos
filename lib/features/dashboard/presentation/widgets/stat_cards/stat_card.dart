import 'package:flutter/material.dart';

import '../../../../../core/utils/responsive_utils.dart';
import '../shared/dashboard_3d_styles.dart';
import '../shared/hard_3d_surface.dart';
import '../shared/trend_indicator.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final double trendPercent;
  final String subLabel;
  final int index;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.trendPercent,
    required this.subLabel,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final accent = Dashboard3DStyles.statAccentForIndex(index);
    final icon = Dashboard3DStyles.statIconForIndex(index);

    return Hard3DSurface(
      color: accent,
      borderRadius: Dashboard3DStyles.cardRadius,
      depth: 5,
      padding: const EdgeInsets.all(16),
      expandWidth: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white.withValues(alpha: 0.18),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const Spacer(),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.88),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: context.responsiveValue(
                compact: 22,
                medium: 24,
                expanded: 28,
              ),
              fontWeight: FontWeight.w800,
              shadows: const [
                Shadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              TrendIndicator(
                trendPercent: trendPercent,
                onDarkBackground: true,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  subLabel,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
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
