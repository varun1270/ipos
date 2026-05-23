import 'package:flutter/material.dart';

/// Theme-dependent semantic colors (light / dark).
@immutable
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  const AppColorScheme({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.elevatedSurface,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.border,
    required this.borderLight,
    required this.divider,
    required this.primaryVeryLight,
    required this.primaryUltraLight,
    required this.accentPurpleSoft,
    required this.successSoft,
    required this.shadowLight,
    required this.shadowMedium,
    required this.overlay,
  });

  final Color background;
  final Color surface;
  final Color surfaceVariant;
  /// Raised cards / 3D tracks (e.g. segmented control shell).
  final Color elevatedSurface;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color border;
  final Color borderLight;
  final Color divider;
  final Color primaryVeryLight;
  final Color primaryUltraLight;
  final Color accentPurpleSoft;
  final Color successSoft;
  final Color shadowLight;
  final Color shadowMedium;
  final Color overlay;

  static const light = AppColorScheme(
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFF9FAFB),
    surfaceVariant: Color(0xFFF3F4F6),
    elevatedSurface: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF111827),
    textSecondary: Color(0xFF6B7280),
    textTertiary: Color(0xFF9CA3AF),
    border: Color(0xFFE5E7EB),
    borderLight: Color(0xFFF3F4F6),
    divider: Color(0xFFE5E7EB),
    primaryVeryLight: Color(0xFFEEF2FF),
    primaryUltraLight: Color(0xFFF0F4FF),
    accentPurpleSoft: Color(0xFFF3E8FF),
    successSoft: Color(0xFFD1FAE5),
    shadowLight: Color(0x0A000000),
    shadowMedium: Color(0x1A000000),
    overlay: Color(0x40000000),
  );

  /// AMOLED-oriented: true black base, minimal lit pixels, soft text (not pure white).
  static const dark = AppColorScheme(
    background: Color(0xFF000000),
    surface: Color(0xFF000000),
    surfaceVariant: Color(0xFF0A0A0A),
    elevatedSurface: Color(0xFF121212),
    textPrimary: Color(0xFFE8E8ED),
    textSecondary: Color(0xFF98989D),
    textTertiary: Color(0xFF636366),
    border: Color(0xFF2C2C2E),
    borderLight: Color(0xFF1C1C1E),
    divider: Color(0xFF2C2C2E),
    primaryVeryLight: Color(0xFF1C1C28),
    primaryUltraLight: Color(0xFF000000),
    accentPurpleSoft: Color(0xFF1A1428),
    successSoft: Color(0xFF0A1A12),
    shadowLight: Color(0x00000000),
    shadowMedium: Color(0x00000000),
    overlay: Color(0x99000000),
  );

  @override
  AppColorScheme copyWith({
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? elevatedSurface,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? border,
    Color? borderLight,
    Color? divider,
    Color? primaryVeryLight,
    Color? primaryUltraLight,
    Color? accentPurpleSoft,
    Color? successSoft,
    Color? shadowLight,
    Color? shadowMedium,
    Color? overlay,
  }) {
    return AppColorScheme(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      elevatedSurface: elevatedSurface ?? this.elevatedSurface,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      border: border ?? this.border,
      borderLight: borderLight ?? this.borderLight,
      divider: divider ?? this.divider,
      primaryVeryLight: primaryVeryLight ?? this.primaryVeryLight,
      primaryUltraLight: primaryUltraLight ?? this.primaryUltraLight,
      accentPurpleSoft: accentPurpleSoft ?? this.accentPurpleSoft,
      successSoft: successSoft ?? this.successSoft,
      shadowLight: shadowLight ?? this.shadowLight,
      shadowMedium: shadowMedium ?? this.shadowMedium,
      overlay: overlay ?? this.overlay,
    );
  }

  @override
  AppColorScheme lerp(ThemeExtension<AppColorScheme>? other, double t) {
    if (other is! AppColorScheme) return this;
    return AppColorScheme(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      elevatedSurface:
          Color.lerp(elevatedSurface, other.elevatedSurface, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderLight: Color.lerp(borderLight, other.borderLight, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      primaryVeryLight:
          Color.lerp(primaryVeryLight, other.primaryVeryLight, t)!,
      primaryUltraLight:
          Color.lerp(primaryUltraLight, other.primaryUltraLight, t)!,
      accentPurpleSoft:
          Color.lerp(accentPurpleSoft, other.accentPurpleSoft, t)!,
      successSoft: Color.lerp(successSoft, other.successSoft, t)!,
      shadowLight: Color.lerp(shadowLight, other.shadowLight, t)!,
      shadowMedium: Color.lerp(shadowMedium, other.shadowMedium, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
    );
  }
}

/// Brand and semantic colors shared across light and dark themes.
abstract final class AppColors {
  AppColors._();

  // Primary — Indigo
  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFF6366F1);
  static const Color primaryDark = Color(0xFF4338CA);
  static const Color primaryExtraDark = Color(0xFF312E81);

  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Semantic
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  static const Color accentPurple = Color(0xFF7C3AED);

  /// Softer accents for AMOLED dark UI (readable on black, less halation).
  static const Color primaryOled = Color(0xFF818CF8);
  static const Color primaryOledDim = Color(0xFF6366F1);
  static const Color successOled = Color(0xFF34D399);
  static const Color warningOled = Color(0xFFFBBF24);
  static const Color errorOled = Color(0xFFF87171);
  static const Color infoOled = Color(0xFF60A5FA);
  static const Color accentPurpleOled = Color(0xFFA78BFA);

  static Color primaryAdaptive(BuildContext context) =>
      context.isDarkTheme ? primaryOled : primary;

  static Color successAdaptive(BuildContext context) =>
      context.isDarkTheme ? successOled : success;

  static Color warningAdaptive(BuildContext context) =>
      context.isDarkTheme ? warningOled : warning;

  static Color errorAdaptive(BuildContext context) =>
      context.isDarkTheme ? errorOled : error;

  static Color infoAdaptive(BuildContext context) =>
      context.isDarkTheme ? infoOled : info;

  static Color accentPurpleAdaptive(BuildContext context) =>
      context.isDarkTheme ? accentPurpleOled : accentPurple;

  /// Stat / chart accent by index — onboarding-muted in dark.
  static Color statAccentForIndex(BuildContext context, int index) {
    if (!context.isDarkTheme) {
      return switch (index) {
        0 => primary,
        1 => info,
        2 => success,
        _ => accentPurple,
      };
    }
    return switch (index) {
      0 => primaryOled,
      1 => infoOled,
      2 => successOled,
      _ => accentPurpleOled,
    };
  }

  // Shadows (brand-tinted)
  static const Color primaryShadow = Color(0x334F46E5);
  static const Color accentPurpleShadow = Color(0x337C3AED);
  static const Color successShadow = Color(0x3310B981);

  // Splash (always on primary brand background)
  static const Color splashBackground = primary;
  static const Color splashBlobLight = Color(0xFF6366F1);
  static const Color splashParticle = Color(0xFFFFFFFF);
  static const Color splashGlow = Color(0xFFFFFFFF);

  /// Resolves [AppColorScheme] from the current theme.
  static AppColorScheme of(BuildContext context) {
    return Theme.of(context).extension<AppColorScheme>() ?? AppColorScheme.light;
  }

  static Color getTextColorForBackground(
    BuildContext context,
    Color backgroundColor,
  ) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? of(context).textPrimary : textOnPrimary;
  }

  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }
}

/// Shorthand for [AppColors.of].
extension AppColorsContext on BuildContext {
  AppColorScheme get appColors => AppColors.of(this);

  bool get isDarkTheme => Theme.of(this).brightness == Brightness.dark;

  Color get adaptivePrimary => AppColors.primaryAdaptive(this);

  Color get adaptiveSuccess => AppColors.successAdaptive(this);

  Color get adaptiveWarning => AppColors.warningAdaptive(this);

  Color get adaptiveError => AppColors.errorAdaptive(this);

  Color get adaptiveInfo => AppColors.infoAdaptive(this);

  Color get adaptiveAccentPurple => AppColors.accentPurpleAdaptive(this);
}
