import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/enums/date_range_filter.dart';
import '../../providers/dashboard_providers.dart';
import '../../utils/dashboard_load_utils.dart';
import '../shared/hard_3d_surface.dart';

class DateRangeFilterChip extends ConsumerWidget {
  const DateRangeFilterChip({super.key});

  static const _segmentPadding = 3.0;
  static const _segmentHeight = 40.0;
  static const _pillDuration = Duration(milliseconds: 280);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(dateRangeFilterControllerProvider).selected;
    final selectedIndex = DateRangeFilter.values.indexOf(selected);
    final segmentCount = DateRangeFilter.values.length;
    final colors = context.appColors;

    return Hard3DSurface.light(
      color: colors.elevatedSurface,
      borderRadius: 16,
      depth: 3,
      padding: const EdgeInsets.all(5),
      expandWidth: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final segmentWidth = (constraints.maxWidth -
                  _segmentPadding * 2 * segmentCount) /
              segmentCount;
          final pillLeft =
              selectedIndex * (segmentWidth + _segmentPadding * 2) +
                  _segmentPadding;

          return SizedBox(
            height: _segmentHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedPositioned(
                  duration: _pillDuration,
                  curve: Curves.easeOutCubic,
                  left: pillLeft,
                  width: segmentWidth,
                  top: 0,
                  bottom: 0,
                  child: Hard3DSurface(
                    color: context.adaptivePrimary,
                    borderRadius: 12,
                    depth: 3,
                    padding: EdgeInsets.zero,
                    expandWidth: true,
                    child: const SizedBox.shrink(),
                  ),
                ),
                Row(
                  children: DateRangeFilter.values.map((filter) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: _segmentPadding,
                        ),
                        child: _SegmentTapTarget(
                          label: filter.label,
                          selected: selected == filter,
                          onTap: () => _onSegmentTap(ref, filter),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _onSegmentTap(WidgetRef ref, DateRangeFilter filter) async {
    final controller = ref.read(dateRangeFilterControllerProvider);
    if (controller.selected == filter) return;

    HapticFeedback.selectionClick();
    controller.setFilter(filter);
    await loadDashboard(ref);
  }
}

class _SegmentTapTarget extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SegmentTapTarget({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  static const _labelDuration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: _labelDuration,
              curve: Curves.easeOutCubic,
              style: TextStyle(
                color: selected ? Colors.white : context.appColors.textSecondary,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                fontSize: 13,
                shadows: selected
                    ? const [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Text(label),
            ),
          ),
        ),
      ),
    );
  }
}
