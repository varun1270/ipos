import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../domain/entities/category_breakdown_entity.dart';
import '../../utils/dashboard_format_utils.dart';

class CategoryDonutChart extends StatelessWidget {
  final List<CategoryBreakdownEntity> categories;

  const CategoryDonutChart({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 168,
      height: 168,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _CategoryDonutPainter(categories: categories),
        child: Center(
          child: Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.white.withValues(alpha: 0.88),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
                Text(
                  formatDashboardCurrency(
                    categories.fold(0.0, (sum, item) => sum + item.revenue),
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
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
    const strokeWidth = 26.0;
    final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);

    var startAngle = -math.pi / 2;

    for (final category in categories) {
      final sweepAngle = 2 * math.pi * (category.percentage / 100);
      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorFromHex(category.colorHex).withValues(alpha: 0.95),
            colorFromHex(category.colorHex),
          ],
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _CategoryDonutPainter oldDelegate) {
    return oldDelegate.categories != categories;
  }
}
