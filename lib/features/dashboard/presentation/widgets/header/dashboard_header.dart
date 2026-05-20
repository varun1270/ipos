import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import 'date_range_filter_chip.dart';
import 'notification_bell.dart';
import 'shop_selector_dropdown.dart';
import 'user_avatar.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'IPOS',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(child: ShopSelectorDropdown()),
              const NotificationBell(),
              const SizedBox(width: 4),
              const UserAvatar(initials: 'NB'),
            ],
          ),
          const SizedBox(height: 16),
          const DateRangeFilterChip(),
        ],
      ),
    );
  }
}
