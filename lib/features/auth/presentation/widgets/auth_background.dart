import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;
  final bool wideLayout;

  const AuthBackground({
    super.key,
    required this.child,
    this.wideLayout = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final isDark = context.isDarkTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isDark ? colors.background : null,
        gradient: isDark
            ? null
            : LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: wideLayout
                    ? [
                        colors.background,
                        colors.surface,
                        colors.surface,
                      ]
                    : [
                        colors.primaryUltraLight,
                        colors.background,
                        colors.surface,
                      ],
              ),
      ),
      child: child,
    );
  }
}
