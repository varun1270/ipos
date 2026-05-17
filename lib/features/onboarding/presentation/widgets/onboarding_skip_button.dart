import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class OnboardingSkipButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const OnboardingSkipButton({super.key, this.label = 'Skip', this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
      child: Text(label),
    );
  }
}
