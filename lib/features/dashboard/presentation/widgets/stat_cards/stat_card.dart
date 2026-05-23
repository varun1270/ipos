import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/dark_ui_style.dart';
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
    final isDark = context.isDarkTheme;

    final colors = context.appColors;
    final accent = Dashboard3DStyles.statAccentForIndex(context, index);
    final icon = Dashboard3DStyles.statIconForIndex(index);

    final padding = _padding(context);
    final iconSize = _iconSize(context);
    final sectionGap = _sectionGap(context);

    final titleColor = isDark
        ? colors.textSecondary
        : Colors.white.withValues(alpha: 0.88);

    final valueColor =
        isDark ? colors.textPrimary : Colors.white;

    final subLabelColor = isDark
        ? colors.textTertiary
        : Colors.white.withValues(alpha: 0.78);

    final iconBackground = isDark
        ? DarkUiStyle.accentTint(accent)
        : Colors.white.withValues(alpha: 0.18);

    final iconBorder = isDark
        ? accent.withValues(alpha: 0.28)
        : Colors.white.withValues(alpha: 0.28);

    final iconColor = isDark ? accent : Colors.white;

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
                color: iconBackground,
                border: Border.all(color: iconBorder),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: iconSize * 0.52,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: _titleSize(context),
                    fontWeight:
                        isDark ? FontWeight.w600 : FontWeight.w700,
                  ),
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
            color: valueColor,
            fontSize: _valueSize(context),
            fontWeight: FontWeight.w800,
            shadows: isDark
                ? null
                : const [
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
              onDarkBackground: !isDark,
            ),
          ],
        ),
      ],
    );

    if (isDark) {
      return Hard3DSurface.light(
        color: colors.elevatedSurface,
        borderRadius: Dashboard3DStyles.cardRadius,
        depth: 3,
        padding: EdgeInsets.all(padding),
        expandWidth: true,
        child: content,
      );
    }

    return Hard3DSurface(
      color: accent,
      borderRadius: Dashboard3DStyles.cardRadius,
      depth: 4,
      padding: EdgeInsets.all(padding),
      expandWidth: true,
      child: content,
    );
  }

  double _padding(BuildContext context) => context.responsiveValue(
        compact: 14.0,
        medium: 12.0,
        expanded: 16.0,
      );

  double _iconSize(BuildContext context) => context.responsiveValue(
        compact: 38.0,
        medium: 32.0,
        expanded: 38.0,
      );

  double _sectionGap(BuildContext context) => context.responsiveValue(
        compact: 12.0,
        medium: 8.0,
        expanded: 12.0,
      );

  double _titleSize(BuildContext context) => context.responsiveValue(
        compact: 13,
        medium: 12,
        expanded: 13,
      );

  double _valueSize(BuildContext context) => context.responsiveValue(
        compact: 22,
        medium: 20,
        expanded: 26,
      );

  double _subLabelSize(BuildContext context) => context.responsiveValue(
        compact: 12,
        medium: 11,
        expanded: 12,
      );
}