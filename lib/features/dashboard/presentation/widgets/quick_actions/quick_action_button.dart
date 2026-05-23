import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/dark_ui_style.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../shared/hard_3d_surface.dart';

class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (context.isDarkTheme) {
      return _buildDark(context);
    }
    return _buildLight(context);
  }

  Widget _buildDark(BuildContext context) {
    final colors = context.appColors;
    final iconSize = _iconSize(context);
    final verticalPadding = _verticalPadding(context);
    final labelGap = _labelGap(context);

    return Hard3DSurface.light(
      color: colors.elevatedSurface,
      borderRadius: 18,
      depth: 3,
      padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: 8),
      onTap: onTap,
      expandWidth: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              color: DarkUiStyle.accentTint(color),
              border: Border.all(color: color.withValues(alpha: 0.28)),
            ),
            child: Icon(icon, color: color, size: iconSize * 0.52),
          ),
          SizedBox(height: labelGap),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: _labelSize(context),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLight(BuildContext context) {
    final iconSize = _iconSize(context);
    final verticalPadding = _verticalPadding(context);
    final labelGap = _labelGap(context);

    return Hard3DSurface(
      color: color,
      borderRadius: 18,
      depth: 4,
      padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: 8),
      onTap: onTap,
      expandWidth: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              color: Colors.white.withValues(alpha: 0.18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
            ),
            child: Icon(icon, color: Colors.white, size: iconSize * 0.52),
          ),
          SizedBox(height: labelGap),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                color: Colors.white,
                fontSize: _labelSize(context),
                fontWeight: FontWeight.w800,
                shadows: const [
                  Shadow(
                    color: Colors.black26,
                    offset: Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _iconSize(BuildContext context) => context.responsiveValue(
        compact: 42.0,
        medium: 36.0,
        expanded: 42.0,
      );

  double _verticalPadding(BuildContext context) => context.responsiveValue(
        compact: 12.0,
        medium: 10.0,
        expanded: 12.0,
      );

  double _labelGap(BuildContext context) => context.responsiveValue(
        compact: 8.0,
        medium: 6.0,
        expanded: 8.0,
      );

  double _labelSize(BuildContext context) => context.responsiveValue(
        compact: 12,
        medium: 11,
        expanded: 12,
      );
}
