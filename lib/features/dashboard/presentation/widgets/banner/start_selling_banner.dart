import 'package:flutter/material.dart';

import '../../../../../core/utils/responsive_utils.dart';
import '../../../../../core/theme/app_colors.dart';
import '../shared/hard_3d_surface.dart';

class StartSellingBanner extends StatelessWidget {
  final bool inRow;

  const StartSellingBanner({super.key, this.inRow = false});

  @override
  Widget build(BuildContext context) {
    final isWide = context.isWideScreen;

    if (context.isDarkTheme) {
      return _buildPlainBanner(context, isWide);
    }

    return Hard3DSurface(
      color: AppColors.primary,
      borderRadius: 24,
      depth: 6,
      padding: EdgeInsets.all(context.responsiveValue(
        compact: 22,
        medium: 24,
        expanded: 26,
      )),
      expandWidth: true,
      child: isWide ? _buildWideContent(context) : _buildCompactContent(context),
    );
  }

  Widget _buildPlainBanner(BuildContext context, bool isWide) {
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.responsiveValue(
        compact: 22,
        medium: 24,
        expanded: 26,
      )),
      decoration: BoxDecoration(
        color: colors.elevatedSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.border),
      ),
      child: isWide ? _buildWideContent(context, plain: true) : _buildCompactContent(context, plain: true),
    );
  }

  Widget _buildWideContent(BuildContext context, {bool plain = false}) {
    return Row(
      children: [
        Expanded(flex: 3, child: _buildTextBlock(context, plain: plain)),
        const SizedBox(width: 20),
        _buildIconOrb(context, plain: plain),
      ],
    );
  }

  Widget _buildCompactContent(BuildContext context, {bool plain = false}) {
    return Row(
      children: [
        Expanded(child: _buildTextBlock(context, plain: plain)),
        const SizedBox(width: 12),
        _buildIconOrb(context, plain: plain),
      ],
    );
  }

  Widget _buildTextBlock(BuildContext context, {bool plain = false}) {
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ready to start selling?',
          style: TextStyle(
            color: plain ? colors.textPrimary : AppColors.textOnPrimary,
            fontSize: context.responsiveValue(
              compact: 20,
              medium: 22,
              expanded: 24,
            ),
            fontWeight: FontWeight.w800,
            shadows: plain
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
            color: plain
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
        if (plain)
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: context.adaptivePrimary,
              foregroundColor: AppColors.textOnPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Start Selling',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
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

  Widget _buildIconOrb(BuildContext context, {bool plain = false}) {
    final size = context.responsiveValue(
      compact: 72.0,
      medium: 80.0,
      expanded: 88.0,
    );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: plain
            ? context.adaptivePrimary.withValues(alpha: 0.14)
            : Colors.white.withValues(alpha: 0.16),
        border: Border.all(
          color: plain
              ? context.adaptivePrimary.withValues(alpha: 0.35)
              : Colors.white.withValues(alpha: 0.35),
        ),
        boxShadow: plain
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
        color: plain ? context.adaptivePrimary : AppColors.textOnPrimary,
        size: size * 0.5,
      ),
    );
  }
}
