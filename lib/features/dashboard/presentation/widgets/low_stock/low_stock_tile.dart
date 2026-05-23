import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/dark_ui_style.dart';
import '../../../domain/entities/low_stock_entity.dart';
import '../../../domain/enums/stock_alert_level.dart';
import '../shared/hard_3d_surface.dart';

class LowStockTile extends StatelessWidget {
  final LowStockEntity item;
  final bool inGrid;

  const LowStockTile({super.key, required this.item, this.inGrid = false});

  @override
  Widget build(BuildContext context) {
    final isCritical = item.alertLevel == StockAlertLevel.critical;
    final accentColor = isCritical
        ? context.adaptiveError
        : context.adaptiveWarning;

    if (context.isDarkTheme) {
      return _buildDark(context, isCritical, accentColor);
    }
    return _buildLight(context, isCritical, accentColor);
  }

  Widget _buildDark(
    BuildContext context,
    bool isCritical,
    Color accentColor,
  ) {
    final colors = context.appColors;

    return Hard3DSurface.light(
      color: colors.elevatedSurface,
      borderRadius: 18,
      depth: 3,
      padding: const EdgeInsets.all(14),
      expandWidth: true,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: DarkUiStyle.accentTint(accentColor),
              border: Border.all(color: accentColor.withValues(alpha: 0.28)),
            ),
            child: Icon(
              isCritical ? Icons.error_outline : Icons.warning_amber_rounded,
              color: accentColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.currentQuantity} ${item.unit} left · reorder at ${item.reorderLevel}',
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: DarkUiStyle.accentTint(accentColor),
            ),
            child: Text(
              item.alertLevel.label,
              style: TextStyle(
                color: accentColor,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLight(
    BuildContext context,
    bool isCritical,
    Color accentColor,
  ) {
    return Hard3DSurface(
      color: accentColor,
      borderRadius: 18,
      depth: 4,
      padding: const EdgeInsets.all(14),
      expandWidth: true,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
            ),
            child: Icon(
              isCritical ? Icons.error_outline : Icons.warning_amber_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.currentQuantity} ${item.unit} left · reorder at ${item.reorderLevel}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: Colors.black.withValues(alpha: 0.18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
            ),
            child: Text(
              item.alertLevel.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
