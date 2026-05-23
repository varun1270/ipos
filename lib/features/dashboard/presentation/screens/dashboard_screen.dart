import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/system_ui_overlay.dart';
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
  var _initialLoadScheduled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialLoadScheduled) return;
    _initialLoadScheduled = true;
    _scheduleInitialLoad();
  }

  void _scheduleInitialLoad() {
    final animation = ModalRoute.of(context)?.animation;
    if (animation == null || animation.isCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) loadDashboard(ref);
      });
      return;
    }

    void onStatus(AnimationStatus status) {
      if (status != AnimationStatus.completed) return;
      animation.removeStatusListener(onStatus);
      if (mounted) loadDashboard(ref);
    }

    animation.addStatusListener(onStatus);
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = ref.watch(dashboardControllerProvider);
    final showInitialLoading = dashboard.isLoading && dashboard.stats == null;

    return ThemedScreen(
      body: DashboardBackground(
        child: RefreshIndicator(
          color: context.adaptivePrimary,
          onRefresh: () => loadDashboard(ref),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              if (showInitialLoading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                SliverToBoxAdapter(
                  child: DashboardPageContent(
                    errorMessage: dashboard.errorMessage,
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
            ],
          ),
        ),
      ),
    );
  }
}
