import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';

/// Elevated form surface for tablet/desktop auth layouts.
class AuthFormCard extends StatelessWidget {
  final Widget child;

  const AuthFormCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Material(
      color: colors.elevatedSurface.withValues(alpha: 0.98),
      elevation: context.isDarkTheme ? 0 : 16,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: EdgeInsets.all(
          context.responsiveValue(compact: 24, medium: 28, expanded: 32),
        ),
        child: child,
      ),
    );
  }
}
