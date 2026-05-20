import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/dashboard_providers.dart';
import '../utils/dashboard_load_utils.dart';
import '../widgets/banner/start_selling_banner.dart';
import '../widgets/category_breakdown/category_breakdown_section.dart';
import '../widgets/header/dashboard_header.dart';
import '../widgets/low_stock/low_stock_alerts_section.dart';
import '../widgets/product_lists/least_selling_products_section.dart';
import '../widgets/product_lists/top_selling_products_section.dart';
import '../widgets/quick_actions/quick_actions_grid.dart';
import '../widgets/revenue_chart/revenue_chart_section.dart';
import '../widgets/stat_cards/stat_cards_grid.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadDashboard(ref));
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = ref.watch(dashboardControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: dashboard.isLoading && dashboard.stats == null
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () => loadDashboard(ref),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    const SliverToBoxAdapter(child: DashboardHeader()),
                    if (dashboard.errorMessage != null)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            dashboard.errorMessage!,
                            style: const TextStyle(color: AppColors.error),
                          ),
                        ),
                      ),
                    const SliverToBoxAdapter(child: StatCardsGrid()),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    const SliverToBoxAdapter(child: QuickActionsGrid()),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    const SliverToBoxAdapter(child: StartSellingBanner()),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    const SliverToBoxAdapter(child: RevenueChartSection()),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                    const SliverToBoxAdapter(
                      child: CategoryBreakdownSection(),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                    const SliverToBoxAdapter(
                      child: TopSellingProductsSection(),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                    const SliverToBoxAdapter(
                      child: LeastSellingProductsSection(),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                    const SliverToBoxAdapter(child: LowStockAlertsSection()),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                ),
              ),
      ),
    );
  }
}
