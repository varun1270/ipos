import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../shared/hard_3d_surface.dart';

class UserAvatar extends StatelessWidget {
  final String initials;

  const UserAvatar({super.key, this.initials = 'U'});

  @override
  Widget build(BuildContext context) {
    return Hard3DSurface(
      color: AppColors.primary,
      borderRadius: 999,
      depth: 3,
      padding: const EdgeInsets.all(10),
      onTap: () {},
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 14,
        ),
      ),
    );
  }
}
