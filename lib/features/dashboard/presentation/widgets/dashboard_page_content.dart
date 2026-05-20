import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../utils/dashboard_responsive.dart';
import 'banner/start_selling_banner.dart';
import 'category_breakdown/category_breakdown_section.dart';
import 'header/dashboard_header.dart';
import 'low_stock/low_stock_alerts_section.dart';
import 'product_lists/least_selling_products_section.dart';
import 'product_lists/top_selling_products_section.dart';
import 'quick_actions/quick_actions_grid.dart';
import 'revenue_chart/revenue_chart_section.dart';
import 'stat_cards/stat_cards_grid.dart';

class DashboardPageContent extends StatelessWidget {
  final String? errorMessage;

  const DashboardPageContent({super.key, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    final gap = DashboardResponsive.sectionSpacing(context);
    final columnGap = DashboardResponsive.columnGap(context);

    return DashboardHorizontalPadding(
      includeVertical: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DashboardHeader(),
          if (errorMessage != null) ...[
            SizedBox(height: gap * 0.5),
            Text(
              errorMessage!,
              style: const TextStyle(color: AppColors.error),
            ),
          ],
          SizedBox(height: gap),
          const StatCardsGrid(),
          SizedBox(height: gap),
          const QuickActionsGrid(),
          SizedBox(height: gap),
          if (DashboardResponsive.useSplitAnalyticsRow(context))
            _AnalyticsRow(columnGap: columnGap)
          else ...[
            const StartSellingBanner(),
            SizedBox(height: gap),
            const RevenueChartSection(inRow: false),
            SizedBox(height: gap),
            const CategoryBreakdownSection(inRow: false),
          ],
          SizedBox(height: gap),
          if (DashboardResponsive.useSplitProductLists(context))
            _ProductListsRow(columnGap: columnGap)
          else ...[
            const TopSellingProductsSection(inRow: false),
            SizedBox(height: gap),
            const LeastSellingProductsSection(inRow: false),
          ],
          SizedBox(height: gap),
          const LowStockAlertsSection(),
          SizedBox(height: gap),
        ],
      ),
    );
  }
}

class _AnalyticsRow extends StatelessWidget {
  final double columnGap;

  const _AnalyticsRow({required this.columnGap});

  @override
  Widget build(BuildContext context) {
    final useSideBySide = MediaQuery.sizeOf(context).width >= 900;

    if (useSideBySide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: const [
                StartSellingBanner(inRow: true),
                SizedBox(height: 20),
                RevenueChartSection(inRow: true),
              ],
            ),
          ),
          SizedBox(width: columnGap),
          const Expanded(
            flex: 2,
            child: CategoryBreakdownSection(
              inRow: true,
              compact: true,
            ),
          ),
        ],
      );
    }

    return Column(
      children: const [
        StartSellingBanner(inRow: false),
        SizedBox(height: 20),
        RevenueChartSection(inRow: false),
        SizedBox(height: 20),
        CategoryBreakdownSection(inRow: false),
      ],
    );
  }
}

class _ProductListsRow extends StatelessWidget {
  final double columnGap;

  const _ProductListsRow({required this.columnGap});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(child: TopSellingProductsSection(inRow: true)),
        SizedBox(width: columnGap),
        const Expanded(child: LeastSellingProductsSection(inRow: true)),
      ],
    );
  }
}
