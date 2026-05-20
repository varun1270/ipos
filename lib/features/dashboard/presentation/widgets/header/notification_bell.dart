import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class NotificationBell extends StatelessWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: () {},
          tooltip: 'Notifications',
          icon: const Icon(Icons.notifications_none),
          color: AppColors.textPrimary,
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.error,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
