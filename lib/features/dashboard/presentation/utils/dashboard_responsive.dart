import 'package:flutter/material.dart';

import '../../../../core/utils/responsive_utils.dart';

abstract final class DashboardResponsive {
  static double horizontalPadding(BuildContext context) {
    return context.responsiveValue(compact: 16.0, medium: 24.0, expanded: 32.0);
  }

  static double sectionSpacing(BuildContext context) {
    return context.responsiveValue(compact: 20.0, medium: 24.0, expanded: 28.0);
  }

  static double columnGap(BuildContext context) {
    return context.responsiveValue(compact: 12.0, medium: 16.0, expanded: 20.0);
  }

  static EdgeInsets pagePadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: horizontalPadding(context),
      vertical: context.responsiveValue(compact: 8.0, medium: 12.0, expanded: 16.0),
    );
  }

  static int statCardColumns(BuildContext context) {
    return context.responsiveValue(compact: 2, medium: 4, expanded: 4);
  }

  static double statCardAspectRatio(BuildContext context) {
    return context.responsiveValue(
      compact: 1.2,
      medium: 1.45,
      expanded: 1.65,
    );
  }

  static int quickActionColumns(BuildContext context) {
    return context.responsiveValue(compact: 4, medium: 4, expanded: 4);
  }

  static double quickActionAspectRatio(BuildContext context) {
    return context.responsiveValue(
      compact: 0.82,
      medium: 1.2,
      expanded: 1.45,
    );
  }

  static int lowStockColumns(BuildContext context) {
    return context.responsiveValue(compact: 1, medium: 2, expanded: 3);
  }

  static bool useSplitAnalyticsRow(BuildContext context) {
    return context.isWideScreen;
  }

  static bool useSplitProductLists(BuildContext context) {
    return context.isWideScreen;
  }

  static bool useInlineHeaderFilters(BuildContext context) {
    return context.isWideScreen;
  }
}

class DashboardHorizontalPadding extends StatelessWidget {
  final Widget child;
  final bool includeVertical;

  const DashboardHorizontalPadding({
    super.key,
    required this.child,
    this.includeVertical = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: includeVertical
          ? DashboardResponsive.pagePadding(context)
          : EdgeInsets.symmetric(
              horizontal: DashboardResponsive.horizontalPadding(context),
            ),
      child: child,
    );
  }
}
