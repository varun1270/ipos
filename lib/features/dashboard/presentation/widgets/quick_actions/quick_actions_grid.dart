import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import 'quick_action_button.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.82,
        children: const [
          QuickActionButton(
            icon: Icons.point_of_sale_outlined,
            label: 'New Sale',
            color: AppColors.primary,
          ),
          QuickActionButton(
            icon: Icons.add_box_outlined,
            label: 'Add Product',
            color: AppColors.success,
          ),
          QuickActionButton(
            icon: Icons.receipt_long_outlined,
            label: 'View Orders',
            color: AppColors.info,
          ),
          QuickActionButton(
            icon: Icons.inventory_2_outlined,
            label: 'Low Stock',
            color: AppColors.warning,
          ),
        ],
      ),
    );
  }
}
