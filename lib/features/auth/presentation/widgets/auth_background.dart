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
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: wideLayout
              ? const [
                  AppColors.background,
                  AppColors.surface,
                  AppColors.surface,
                ]
              : const [
                  AppColors.primaryUltraLight,
                  AppColors.background,
                  AppColors.surface,
                ],
        ),
      ),
      child: wideLayout ? child : SafeArea(child: child),
    );
  }
}
