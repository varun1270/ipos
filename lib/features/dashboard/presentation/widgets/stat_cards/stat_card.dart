import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
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
    if (context.isDarkTheme) {
      return _buildPlainCard(context);
    }
    return _build3DCard(context);
  }

  Widget _buildPlainCard(BuildContext context) {
    final colors = context.appColors;
    final accent = Dashboard3DStyles.statAccentForIndex(context, index);
    final icon = Dashboard3DStyles.statIconForIndex(index);

    final padding = context.responsiveValue(
      compact: 14.0,
      medium: 12.0,
      expanded: 16.0,
    );
    final iconSize = context.responsiveValue(
      compact: 38.0,
      medium: 32.0,
      expanded: 38.0,
    );
    final sectionGap = context.responsiveValue(
      compact: 12.0,
      medium: 8.0,
      expanded: 12.0,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: colors.elevatedSurface,
        borderRadius: BorderRadius.circular(Dashboard3DStyles.cardRadius),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: accent.withValues(alpha: 0.14),
                ),
                child: Icon(
                  icon,
                  color: accent,
                  size: iconSize * 0.52,
                ),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: context.responsiveValue(
                      compact: 13,
                      medium: 12,
                      expanded: 13,
                    ),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: sectionGap),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: context.responsiveValue(
                compact: 22,
                medium: 20,
                expanded: 26,
              ),
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: sectionGap),
          Row(
            children: [
              TrendIndicator(trendPercent: trendPercent),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  subLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.textTertiary,
                    fontSize: context.responsiveValue(
                      compact: 12,
                      medium: 11,
                      expanded: 12,
                    ),
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

  Widget _build3DCard(BuildContext context) {
    final accent = Dashboard3DStyles.statAccentForIndex(context, index);
    final icon = Dashboard3DStyles.statIconForIndex(index);

    final padding = context.responsiveValue(
      compact: 14.0,
      medium: 12.0,
      expanded: 16.0,
    );
    final iconSize = context.responsiveValue(
      compact: 38.0,
      medium: 32.0,
      expanded: 38.0,
    );
    final sectionGap = context.responsiveValue(
      compact: 12.0,
      medium: 8.0,
      expanded: 12.0,
    );

    const depth = 4.0;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white.withValues(alpha: 0.18),
                border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: iconSize * 0.52,
              ),
            ),
            const Spacer(),
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.88),
                  fontSize: context.responsiveValue(
                    compact: 13,
                    medium: 12,
                    expanded: 13,
                  ),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: sectionGap),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: context.responsiveValue(
              compact: 22,
              medium: 20,
              expanded: 26,
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
        SizedBox(height: sectionGap),
        Row(
          children: [
            TrendIndicator(
              trendPercent: trendPercent,
              onDarkBackground: true,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                subLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.78),
                  fontSize: context.responsiveValue(
                    compact: 12,
                    medium: 11,
                    expanded: 12,
                  ),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );

    return Hard3DSurface(
      color: accent,
      borderRadius: Dashboard3DStyles.cardRadius,
      depth: depth,
      padding: EdgeInsets.all(padding),
      expandWidth: true,
      child: content,
    );
  }
}
