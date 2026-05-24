import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../shared/hard_3d_surface.dart';

class NotificationBell extends StatelessWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Hard3DSurface(
          color: context.adaptiveInfo,
          borderRadius: 14,
          depth: 3,
          padding: const EdgeInsets.all(10),
          onTap: () {
            // Handle notification bell tap
            context.pushNamed('notifications');
          },
          child: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 22),
        ),
        Positioned(
          top: 2,
          right: 2,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.error,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
