import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/product_sales_entity.dart';
import '../../utils/dashboard_format_utils.dart';
import '../shared/hard_3d_surface.dart';

class ProductRankTile extends StatelessWidget {
  final ProductSalesEntity product;
  final bool highlightRank;

  const ProductRankTile({
    super.key,
    required this.product,
    this.highlightRank = false,
  });

  @override
  Widget build(BuildContext context) {
    final accent =
        highlightRank ? context.adaptivePrimary : context.adaptiveInfo;
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Hard3DSurface.light(
        color: colors.elevatedSurface,
        borderRadius: 18,
        depth: 3,
        padding: const EdgeInsets.all(14),
        expandWidth: true,
        child: Row(
          children: [
            Hard3DSurface(
              color: accent,
              borderRadius: 12,
              depth: 3,
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: 16,
                child: Center(
                  child: Text(
                    '${product.rank}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
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
                    '${product.category} · ${product.unitsSold} sold',
                    style: TextStyle(
                      color: colors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              formatDashboardCurrency(product.revenue),
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
