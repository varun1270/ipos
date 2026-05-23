import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/revenue_point_entity.dart';
import '../../utils/dashboard_format_utils.dart';
import '../shared/dashboard_3d_styles.dart';

class RevenueChart extends StatefulWidget {
  final List<RevenuePointEntity> points;

  const RevenueChart({super.key, required this.points});

  @override
  State<RevenueChart> createState() => _RevenueChartState();
}

class _RevenueChartState extends State<RevenueChart>
    with TickerProviderStateMixin {
  static const _entryDuration = Duration(milliseconds: 480);
  static const _selectDuration = Duration(milliseconds: 160);
  static const _selectReverseDuration = Duration(milliseconds: 240);
  static const _tooltipGap = 10.0;
  static const _tooltipReserve = 44.0;

  late final AnimationController _entryController;
  late final AnimationController _selectionController;
  late List<RevenuePointEntity> _animatedPoints;

  int? _pressedIndex;
  int? _hoveredIndex;

  int? get _activeIndex => _pressedIndex ?? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    _animatedPoints = widget.points;
    _entryController = AnimationController(
      vsync: this,
      duration: _entryDuration,
    )..forward();
    _selectionController = AnimationController(
      vsync: this,
      duration: _selectDuration,
      reverseDuration: _selectReverseDuration,
    );
  }

  @override
  void didUpdateWidget(RevenueChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_pointsEqual(oldWidget.points, widget.points)) {
      _animatedPoints = widget.points;
      _pressedIndex = null;
      _hoveredIndex = null;
      _releaseSelection(immediate: true);
      _entryController
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    _selectionController.dispose();
    super.dispose();
  }

  bool _pointsEqual(
    List<RevenuePointEntity> a,
    List<RevenuePointEntity> b,
  ) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].label != b[i].label || a[i].revenue != b[i].revenue) {
        return false;
      }
    }
    return true;
  }

  void _onBarPressDown(int index) {
    if (_pressedIndex == index) return;

    HapticFeedback.lightImpact();
    setState(() => _pressedIndex = index);
    _activateSelection();
  }

  void _onBarPressEnd() {
    if (_pressedIndex == null) return;
    setState(() => _pressedIndex = null);
    _syncSelection();
  }

  void _onBarHoverEnter(int index) {
    if (_hoveredIndex == index) return;
    setState(() => _hoveredIndex = index);
    _activateSelection();
  }

  void _onBarHoverExit(int index) {
    if (_hoveredIndex != index) return;
    setState(() => _hoveredIndex = null);
    Future.microtask(_syncSelection);
  }

  void _activateSelection() {
    if (_activeIndex == null) return;
    if (_selectionController.status == AnimationStatus.reverse ||
        _selectionController.value < 1) {
      _selectionController.forward();
    }
  }

  void _syncSelection() {
    if (!mounted) return;
    if (_activeIndex != null) {
      _activateSelection();
    } else {
      _releaseSelection();
    }
  }

  void _releaseSelection({bool immediate = false}) {
    if (_activeIndex != null) return;

    if (immediate) {
      _selectionController.reset();
      return;
    }

    if (_selectionController.status == AnimationStatus.dismissed &&
        _selectionController.value == 0) {
      return;
    }

    _selectionController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final points = _animatedPoints;

    if (points.isEmpty) {
      return const Center(child: Text('No revenue data'));
    }

    final maxRevenue = points
        .map((point) => point.revenue)
        .reduce((a, b) => a > b ? a : b);

    final colors = context.appColors;
    final isDark = context.isDarkTheme;
    final hasSelection = _activeIndex != null;

    return Padding(
      padding: const EdgeInsets.only(top: _tooltipReserve),
      child: AnimatedBuilder(
        animation: Listenable.merge([_entryController, _selectionController]),
        builder: (context, _) {
          final selectionT = Curves.easeOutCubic.transform(
            _selectionController.value,
          );

          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: points.asMap().entries.map((entry) {
              final point = entry.value;
              final index = entry.key;
              final isActive = _activeIndex == index;
              final isSelected = isActive && selectionT > 0;

              final barProgress = Curves.easeOutCubic.transform(
                _staggeredProgress(index, points.length),
              );
              final labelProgress = Curves.easeOutCubic.transform(
                _labelProgress(index, points.length),
              );

              final heightFactor =
                  maxRevenue == 0 ? 0.0 : point.revenue / maxRevenue;
              final baseHeight =
                  (heightFactor.clamp(0.08, 1.0) * barProgress).clamp(
                    0.0,
                    1.0,
                  );
              final animatedHeight = isSelected
                  ? (baseHeight * (1 + 0.1 * selectionT)).clamp(0.0, 1.0)
                  : baseHeight;

              final barColor = Color.lerp(
                isDark ? AppColors.primaryOled : AppColors.primaryLight,
                isDark ? AppColors.primaryOledDim : AppColors.primaryDark,
                index / (points.length - 1).clamp(1, 999),
              )!;

              final dimOthers =
                  hasSelection && !isActive ? (1 - 0.35 * selectionT) : 1.0;

              return Expanded(
                child: MouseRegion(
                  onEnter: (_) => _onBarHoverEnter(index),
                  onExit: (_) => _onBarHoverExit(index),
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapDown: (_) => _onBarPressDown(index),
                    onTapUp: (_) => _onBarPressEnd(),
                    onTapCancel: _onBarPressEnd,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSelected ? 1 : 4,
                      ),
                      child: Opacity(
                        opacity: dimOthers,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final barHeight =
                                      constraints.maxHeight * animatedHeight;

                                  return Stack(
                                    clipBehavior: Clip.none,
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Transform.scale(
                                          scaleX: isSelected
                                              ? 1 + (0.14 * selectionT)
                                              : 1,
                                          scaleY: isSelected
                                              ? 1 + (0.04 * selectionT)
                                              : 1,
                                          alignment: Alignment.bottomCenter,
                                          child: SizedBox(
                                            height: barHeight,
                                            width: double.infinity,
                                            child: _BarShape(
                                              barColor: barColor,
                                              barProgress: barProgress,
                                              isDark: isDark,
                                              isSelected: isSelected,
                                              selectionT: selectionT,
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (isSelected)
                                        Positioned(
                                          bottom: barHeight + _tooltipGap,
                                          left: 0,
                                          right: 0,
                                          child: _ValueTooltip(
                                            value: formatDashboardCurrency(
                                              point.revenue,
                                            ),
                                            barColor: barColor,
                                            progress: selectionT,
                                            isDark: isDark,
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                            Opacity(
                              opacity: labelProgress,
                              child: Transform.translate(
                                offset: Offset(0, 6 * (1 - labelProgress)),
                                child: Text(
                                  point.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isSelected
                                        ? colors.textPrimary
                                        : colors.textTertiary,
                                    fontSize: 11,
                                    fontWeight: isSelected
                                        ? FontWeight.w800
                                        : FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 120),
                              opacity: isSelected
                                  ? (1 - selectionT).clamp(0.0, 1.0)
                                  : labelProgress,
                              child: Transform.translate(
                                offset: Offset(0, 4 * (1 - labelProgress)),
                                child: Text(
                                  formatDashboardCurrency(point.revenue),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: colors.textSecondary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  double _staggeredProgress(int index, int count) {
    final t = _entryController.value;
    if (count <= 1) return t;

    final stagger = 0.55 / count;
    final start = (index * stagger).clamp(0.0, 0.45);
    final end = (start + 0.55).clamp(start + 0.05, 1.0);
    return ((t - start) / (end - start)).clamp(0.0, 1.0);
  }

  double _labelProgress(int index, int count) {
    final bar = _staggeredProgress(index, count);
    return ((bar - 0.35) / 0.65).clamp(0.0, 1.0);
  }
}

class _BarShape extends StatelessWidget {
  final Color barColor;
  final double barProgress;
  final bool isDark;
  final bool isSelected;
  final double selectionT;

  const _BarShape({
    required this.barColor,
    required this.barProgress,
    required this.isDark,
    required this.isSelected,
    required this.selectionT,
  });

  @override
  Widget build(BuildContext context) {
    final glowStrength = isSelected ? 0.55 + (0.2 * selectionT) : 0.35;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? barColor : null,
        gradient: isDark ? null : Dashboard3DStyles.barGradient(barColor),
        borderRadius: BorderRadius.circular(isSelected ? 12 : 10),
        boxShadow: isDark
            ? isSelected
                ? [
                    BoxShadow(
                      color: barColor.withValues(alpha: 0.5 * selectionT),
                      blurRadius: 16,
                      spreadRadius: 1,
                    ),
                  ]
                : null
            : [
                BoxShadow(
                  color: barColor.withValues(alpha: glowStrength * barProgress),
                  blurRadius: isSelected ? 18 : 12,
                  spreadRadius: isSelected ? 1 : 0,
                  offset: Offset(0, isSelected ? 4 : 6),
                ),
              ],
        border: isDark
            ? isSelected
                ? Border.all(
                    color: Colors.white.withValues(alpha: 0.35 * selectionT),
                    width: 1.4,
                  )
                : null
            : Border(
                top: BorderSide(
                  color: Colors.white.withValues(
                    alpha: (0.45 + 0.2 * selectionT) * barProgress,
                  ),
                  width: isSelected ? 1.6 : 1.2,
                ),
              ),
      ),
    );
  }
}

class _ValueTooltip extends StatelessWidget {
  final String value;
  final Color barColor;
  final double progress;
  final bool isDark;

  const _ValueTooltip({
    required this.value,
    required this.barColor,
    required this.progress,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return IgnorePointer(
      child: Opacity(
        opacity: progress,
        child: Transform.scale(
          scale: 0.9 + (0.1 * progress),
          alignment: Alignment.bottomCenter,
          child: Transform.translate(
            offset: Offset(0, 6 * (1 - progress)),
            child: OverflowBox(
              maxWidth: 160,
              minWidth: 0,
              alignment: Alignment.bottomCenter,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: isDark ? colors.elevatedSurface : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: barColor.withValues(alpha: isDark ? 0.5 : 0.3),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: barColor.withValues(alpha: 0.3 * progress),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                    if (!isDark)
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: Text(
                    value,
                    softWrap: false,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark ? barColor : AppColors.primaryDark,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                      height: 1.1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
