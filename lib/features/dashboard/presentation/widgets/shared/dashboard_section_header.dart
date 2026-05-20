import 'package:flutter/material.dart';

import '../../../../../core/utils/responsive_utils.dart';
import '../../../../../core/theme/app_colors.dart';

class DashboardSectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const DashboardSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: context.responsiveValue(compact: 12, medium: 14, expanded: 16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: context.responsiveValue(
                  compact: 18,
                  medium: 19,
                  expanded: 20,
                ),
                fontWeight: FontWeight.w800,
                shadows: const [
                  Shadow(
                    color: Color(0x1A4F46E5),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),
          if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              child: Text(
                actionLabel!,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
        ],
      ),
    );
  }
}
