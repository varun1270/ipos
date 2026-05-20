import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../domain/entities/category_breakdown_entity.dart';
import '../../utils/dashboard_format_utils.dart';

class CategoryDonutChart extends StatelessWidget {
  final List<CategoryBreakdownEntity> categories;

  const CategoryDonutChart({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 160,
      child: CustomPaint(
        painter: _CategoryDonutPainter(categories: categories),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                formatDashboardCurrency(
                  categories.fold(0.0, (sum, item) => sum + item.revenue),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryDonutPainter extends CustomPainter {
  final List<CategoryBreakdownEntity> categories;

  _CategoryDonutPainter({required this.categories});

  @override
  void paint(Canvas canvas, Size size) {
    if (categories.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    const strokeWidth = 24.0;
    final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);

    var startAngle = -math.pi / 2;

    for (final category in categories) {
      final sweepAngle = 2 * math.pi * (category.percentage / 100);
      final paint = Paint()
        ..color = colorFromHex(category.colorHex)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _CategoryDonutPainter oldDelegate) {
    return oldDelegate.categories != categories;
  }
}
