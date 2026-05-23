import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/dark_ui_style.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../shared/hard_3d_surface.dart';

class StartSellingBanner extends StatelessWidget {
  final bool inRow;

  const StartSellingBanner({super.key, this.inRow = false});

  @override
  Widget build(BuildContext context) {
    final isWide = context.isWideScreen;
    final padding = EdgeInsets.all(context.responsiveValue(
      compact: 22,
      medium: 24,
      expanded: 26,
    ));

    if (context.isDarkTheme) {
      return Hard3DSurface.light(
        color: context.appColors.elevatedSurface,
        borderRadius: 24,
        depth: 3,
        padding: padding,
        expandWidth: true,
        child: isWide ? _buildWideContent(context, dark: true) : _buildCompactContent(context, dark: true),
      );
    }

    return Hard3DSurface(
      color: AppColors.primary,
      borderRadius: 24,
      depth: 6,
      padding: padding,
      expandWidth: true,
      child: isWide ? _buildWideContent(context) : _buildCompactContent(context),
    );
  }

  Widget _buildWideContent(BuildContext context, {bool dark = false}) {
    return Row(
      children: [
        Expanded(flex: 3, child: _buildTextBlock(context, dark: dark)),
        const SizedBox(width: 20),
        _buildIconOrb(context, dark: dark),
      ],
    );
  }

  Widget _buildCompactContent(BuildContext context, {bool dark = false}) {
    return Row(
      children: [
        Expanded(child: _buildTextBlock(context, dark: dark)),
        const SizedBox(width: 12),
        _buildIconOrb(context, dark: dark),
      ],
    );
  }

  Widget _buildTextBlock(BuildContext context, {bool dark = false}) {
    final colors = context.appColors;
    final accent = context.adaptivePrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ready to start selling?',
          style: TextStyle(
            color: dark ? colors.textPrimary : AppColors.textOnPrimary,
            fontSize: context.responsiveValue(
              compact: 20,
              medium: 22,
              expanded: 24,
            ),
            fontWeight: FontWeight.w800,
            shadows: dark
                ? null
                : const [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Open the POS and process your first order today.',
          style: TextStyle(
            color: dark
                ? colors.textSecondary
                : AppColors.textOnPrimary.withValues(alpha: 0.92),
            fontSize: context.responsiveValue(
              compact: 13,
              medium: 14,
              expanded: 15,
            ),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),
        if (dark)
          Hard3DSurface(
            color: accent,
            borderRadius: 14,
            depth: 3,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            onTap: () {},
            child: Text(
              'Start Selling',
              style: TextStyle(
                color: AppColors.textOnPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          )
        else
          Hard3DSurface(
            color: Colors.white,
            borderRadius: 14,
            depth: 4,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            onTap: () {},
            child: const Text(
              'Start Selling',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildIconOrb(BuildContext context, {bool dark = false}) {
    final size = context.responsiveValue(
      compact: 72.0,
      medium: 80.0,
      expanded: 88.0,
    );
    final accent = context.adaptivePrimary;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: dark
            ? DarkUiStyle.accentTint(accent)
            : Colors.white.withValues(alpha: 0.16),
        border: Border.all(
          color: dark
              ? accent.withValues(alpha: 0.28)
              : Colors.white.withValues(alpha: 0.35),
        ),
        boxShadow: dark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Icon(
        Icons.storefront_rounded,
        color: dark ? accent : AppColors.textOnPrimary,
        size: size * 0.5,
      ),
    );
  }
}
