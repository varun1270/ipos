import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class UserAvatar extends StatelessWidget {
  final String initials;

  const UserAvatar({super.key, this.initials = 'U'});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(999),
        child: CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.primaryVeryLight,
          child: Text(
            initials,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
