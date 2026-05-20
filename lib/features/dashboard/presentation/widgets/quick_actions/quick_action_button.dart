import 'package:flutter/material.dart';

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
    final iconSize = context.responsiveValue(
      compact: 42.0,
      medium: 36.0,
      expanded: 42.0,
    );
    final verticalPadding = context.responsiveValue(
      compact: 12.0,
      medium: 10.0,
      expanded: 12.0,
    );
    final labelGap = context.responsiveValue(
      compact: 8.0,
      medium: 6.0,
      expanded: 8.0,
    );

    return Hard3DSurface(
      color: color,
      borderRadius: 18,
      depth: 4,
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: 8,
      ),
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
                fontSize: context.responsiveValue(
                  compact: 12,
                  medium: 11,
                  expanded: 12,
                ),
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
}
