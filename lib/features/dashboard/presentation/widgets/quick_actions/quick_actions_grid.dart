import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../utils/dashboard_responsive.dart';
import 'quick_action_button.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: DashboardResponsive.quickActionColumns(context),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: DashboardResponsive.columnGap(context),
      crossAxisSpacing: DashboardResponsive.columnGap(context),
      childAspectRatio: DashboardResponsive.quickActionAspectRatio(context),
      children: [
        QuickActionButton(
          icon: Icons.point_of_sale_outlined,
          label: 'New Sale',
          color: context.adaptivePrimary,
        ),
        QuickActionButton(
          icon: Icons.add_box_outlined,
          label: 'Add Product',
          color: context.adaptiveSuccess,
        ),
        QuickActionButton(
          icon: Icons.receipt_long_outlined,
          label: 'View Orders',
          color: context.adaptiveInfo,
        ),
        QuickActionButton(
          icon: Icons.inventory_2_outlined,
          label: 'Low Stock',
          color: context.adaptiveWarning,
        ),
      ],
    );
  }
}
