import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/category_breakdown_entity.dart';
import '../../utils/dashboard_format_utils.dart';

class CategoryLegend extends StatelessWidget {
  final List<CategoryBreakdownEntity> categories;

  const CategoryLegend({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: categories.map((category) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: colorFromHex(category.colorHex),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  category.categoryName,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                '${category.percentage.toStringAsFixed(0)}%',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
