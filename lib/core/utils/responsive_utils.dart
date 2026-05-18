import 'package:flutter/material.dart';

/// Layout buckets used across splash, onboarding, and auth flows.
enum AppScreenSize { compact, medium, expanded }

class Responsive {
  Responsive._();

  static const double mediumBreakpoint = 600;
  static const double expandedBreakpoint = 1024;

  static AppScreenSize sizeOf(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= expandedBreakpoint) return AppScreenSize.expanded;
    if (width >= mediumBreakpoint) return AppScreenSize.medium;
    return AppScreenSize.compact;
  }

  static bool isWide(BuildContext context) =>
      sizeOf(context) != AppScreenSize.compact;

  static bool isExpanded(BuildContext context) =>
      sizeOf(context) == AppScreenSize.expanded;

  static double scale(BuildContext context) {
    return switch (sizeOf(context)) {
      AppScreenSize.compact => 1,
      AppScreenSize.medium => 1.12,
      AppScreenSize.expanded => 1.28,
    };
  }
}

extension ResponsiveContext on BuildContext {
  AppScreenSize get screenSize => Responsive.sizeOf(this);

  bool get isWideScreen => Responsive.isWide(this);

  bool get isExpandedScreen => Responsive.isExpanded(this);

  double get layoutScale => Responsive.scale(this);

  T responsiveValue<T>({
    required T compact,
    required T medium,
    required T expanded,
  }) {
    return switch (screenSize) {
      AppScreenSize.compact => compact,
      AppScreenSize.medium => medium,
      AppScreenSize.expanded => expanded,
    };
  }
}
