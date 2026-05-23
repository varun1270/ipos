import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Onboarding-aligned dark UI: black base, muted accents, subtle 3D glow.
abstract final class DarkUiStyle {
  DarkUiStyle._();

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  /// Soft accent halo (matches onboarding outer circle ~20%).
  static Color accentTint(Color accent, {double alpha = 0.20}) =>
      accent.withValues(alpha: alpha);

  /// Muted 3D face — accent blended into elevated surface, not a solid block.
  static Color face3D(BuildContext context, Color accent) {
    if (!isDark(context)) return accent;
    final surface = AppColors.of(context).elevatedSurface;
    return Color.lerp(surface, accent, 0.46)!;
  }

  static double glowOpacity({required bool enabled, required double pressT}) {
    if (!enabled) return 0.06;
    return 0.10 - (0.04 * pressT);
  }

  static double coloredShadowAlpha = 0.08;

  static double topSheenAlpha = 0.06;
}
