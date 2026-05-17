import 'package:flutter/material.dart';

/// Core color palette for the IPOS application
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary Colors - Indigo
  static const Color primary = Color(0xFF4F46E5); // Main indigo
  static const Color primaryLight = Color(0xFF6366F1); // Light indigo
  static const Color primaryDark = Color(0xFF4338CA); // Dark indigo
  static const Color primaryExtraDark = Color(0xFF312E81); // Extra dark indigo
  static const Color primaryVeryLight = Color(0xFFEEF2FF); // Very light indigo
  static const Color primaryUltraLight = Color(0xFFF0F4FF); // Ultra light indigo

  // Background
  static const Color background = Color(0xFFFFFFFF); // White
  static const Color surface = Color(0xFFF9FAFB); // Light gray
  static const Color surfaceVariant = Color(0xFFF3F4F6); // Medium light gray

  // Text Colors
  static const Color textPrimary = Color(0xFF111827); // Almost black
  static const Color textSecondary = Color(0xFF6B7280); // Gray
  static const Color textTertiary = Color(0xFF9CA3AF); // Light gray
  static const Color textOnPrimary = Color(0xFFFFFFFF); // White on primary

  // Semantic Colors
  static const Color success = Color(0xFF10B981); // Green
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color error = Color(0xFFEF4444); // Red
  static const Color info = Color(0xFF3B82F6); // Blue
  static const Color accentPurple = Color(0xFF7C3AED); // Violet
  static const Color accentPurpleSoft = Color(0xFFF3E8FF); // Light violet
  static const Color successSoft = Color(0xFFD1FAE5); // Light green

  // Onboarding icon shadows
  static const Color primaryShadow = Color(0x334F46E5); // 20% indigo
  static const Color accentPurpleShadow = Color(0x337C3AED); // 20% violet
  static const Color successShadow = Color(0x3310B981); // 20% green

  // Borders & Dividers
  static const Color border = Color(0xFFE5E7EB); // Light border
  static const Color borderLight = Color(0xFFF3F4F6); // Very light border
  static const Color divider = Color(0xFFE5E7EB); // Divider

  // Shadow & Overlay
  static const Color shadowLight = Color(0x0A000000); // Very subtle shadow
  static const Color shadowMedium = Color(0x1A000000); // Medium shadow
  static const Color overlay = Color(0x40000000); // 25% black overlay

  // Splash Screen specific
  static const Color splashBackground = primary; // Main indigo
  static const Color splashBlobLight = Color(0xFF6366F1); // Light indigo blob
  static const Color splashParticle = Color(0xFFFFFFFF); // White particles
  static const Color splashGlow = Color(0xFFFFFFFF); // White glow

  /// Get contrasting text color based on background color
  static Color getTextColorForBackground(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? textPrimary : textOnPrimary;
  }

  /// Get a semi-transparent version of a color
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }
}
