import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import 'hard_3d_surface.dart';

abstract final class Dashboard3DStyles {
  static const cardRadius = 20.0;
  static const panelRadius = 24.0;

  static LinearGradient barGradient(Color base) {
    final top = Hard3DColors.lighten(base, 0.1);
    final bottom = Hard3DColors.darken(base, 0.08);
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [top, base, bottom],
      stops: const [0.0, 0.5, 1.0],
    );
  }

  /// Onboarding-muted indigo in dark, brand primary in light.
  static Color brandPrimary(BuildContext context) => context.adaptivePrimary;

  static Color statAccentForIndex(BuildContext context, int index) =>
      AppColors.statAccentForIndex(context, index);

  static IconData statIconForIndex(int index) {
    return switch (index) {
      0 => Icons.currency_rupee_rounded,
      1 => Icons.receipt_long_rounded,
      2 => Icons.shopping_bag_rounded,
      _ => Icons.people_alt_rounded,
    };
  }
}

class Dashboard3DSurface extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? accent;
  final double radius;
  final bool expandWidth;

  const Dashboard3DSurface({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.accent,
    this.radius = Dashboard3DStyles.panelRadius,
    this.expandWidth = false,
  });

  factory Dashboard3DSurface.panel({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? accent,
    double radius = Dashboard3DStyles.panelRadius,
    bool expandWidth = false,
  }) {
    return Dashboard3DSurface(
      key: key,
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      accent: accent,
      radius: radius,
      expandWidth: expandWidth,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Hard3DSurface.light(
        color: context.appColors.elevatedSurface,
        borderRadius: radius,
        depth: 4,
        padding: padding ?? const EdgeInsets.all(16),
        expandWidth: expandWidth,
        child: child,
      ),
    );
  }
}

class DashboardBackground extends StatelessWidget {
  final Widget child;

  const DashboardBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.appColors.background,
      child: child,
    );
  }
}
