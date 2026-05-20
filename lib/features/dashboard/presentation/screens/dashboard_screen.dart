import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/dashboard_providers.dart';
import '../utils/dashboard_load_utils.dart';
import '../widgets/dashboard_page_content.dart';
import '../widgets/shared/dashboard_3d_styles.dart';

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
      body: DashboardBackground(
        child: SafeArea(
          child: dashboard.isLoading && dashboard.stats == null
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () => loadDashboard(ref),
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: [
                      SliverToBoxAdapter(
                        child: DashboardPageContent(
                          errorMessage: dashboard.errorMessage,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
