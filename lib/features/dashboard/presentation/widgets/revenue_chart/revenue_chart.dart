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
  static const _tooltipReserve = 44.0;

  late final AnimationController _entryController;
  late final AnimationController _selectionController;
  late List<RevenuePointEntity> _animatedPoints;

  final _chartKey = GlobalKey();

  int? _pressedIndex;
  int? _hoveredIndex;
  bool _isTrackingPointer = false;
  int? _lastHapticIndex;

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
      _isTrackingPointer = false;
      _lastHapticIndex = null;
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

  int? _indexForPointer(PointerEvent event, int barCount) {
    final box = _chartKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || barCount == 0) return null;

    final local = box.globalToLocal(event.position);
    if (local.dx < 0 ||
        local.dx > box.size.width ||
        local.dy < 0 ||
        local.dy > box.size.height) {
      return null;
    }

    final index = (local.dx / box.size.width * barCount).floor();
    return index.clamp(0, barCount - 1);
  }

  void _focusBar(
    int index, {
    bool fromPointer = false,
    bool haptic = false,
  }) {
    final current = fromPointer ? _pressedIndex : _hoveredIndex;
    if (current == index) return;

    setState(() {
      if (fromPointer) {
        _pressedIndex = index;
      } else {
        _hoveredIndex = index;
      }
    });

    if (haptic && _lastHapticIndex != index) {
      HapticFeedback.selectionClick();
      _lastHapticIndex = index;
    }
    _activateSelection();
  }

  void _onPointerDown(PointerDownEvent event, int barCount) {
    final index = _indexForPointer(event, barCount);
    if (index == null) return;

    _isTrackingPointer = true;
    _focusBar(index, fromPointer: true, haptic: true);
  }

  void _onPointerMove(PointerMoveEvent event, int barCount) {
    if (!_isTrackingPointer) return;

    final index = _indexForPointer(event, barCount);
    if (index == null || index == _pressedIndex) return;

    _focusBar(index, fromPointer: true, haptic: true);
  }

  void _onPointerUp(int barCount) {
    if (!_isTrackingPointer) return;

    _isTrackingPointer = false;
    _lastHapticIndex = null;
    setState(() => _pressedIndex = null);
    _syncSelection();
  }

  void _onPointerHover(PointerHoverEvent event, int barCount) {
    if (_isTrackingPointer) return;

    final index = _indexForPointer(event, barCount);
    if (index == null) {
      if (_hoveredIndex == null) return;
      setState(() => _hoveredIndex = null);
      _syncSelection();
      return;
    }

    _focusBar(index);
  }

  void _onPointerExit() {
    if (_isTrackingPointer) return;

    if (_hoveredIndex == null) return;
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final chartWidth = constraints.maxWidth;

        return AnimatedBuilder(
          animation: Listenable.merge([_entryController, _selectionController]),
          builder: (context, _) {
            final selectionT = Curves.easeOutCubic.transform(
              _selectionController.value,
            );

            final barCount = points.length;
            final activeIndex = _activeIndex;
            final showValue = activeIndex != null;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: _tooltipReserve),
                  child: MouseRegion(
                    onExit: (_) => _onPointerExit(),
                    cursor: SystemMouseCursors.click,
                    child: Listener(
                      key: _chartKey,
                      behavior: HitTestBehavior.opaque,
                      onPointerDown: (e) => _onPointerDown(e, barCount),
                      onPointerMove: (e) => _onPointerMove(e, barCount),
                      onPointerUp: (_) => _onPointerUp(barCount),
                      onPointerCancel: (_) => _onPointerUp(barCount),
                      onPointerHover: (e) => _onPointerHover(e, barCount),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: points.asMap().entries.map((entry) {
              final point = entry.value;
              final index = entry.key;
              final isActive = activeIndex == index;
              final isSelected = isActive;
              final selectionStrength = isActive ? selectionT.clamp(0.0, 1.0) : 0.0;

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
                  ? (baseHeight * (1 + 0.1 * selectionStrength)).clamp(0.0, 1.0)
                  : baseHeight;

              final barColor = Color.lerp(
                isDark ? AppColors.primaryOled : AppColors.primaryLight,
                isDark ? AppColors.primaryOledDim : AppColors.primaryDark,
                index / (points.length - 1).clamp(1, 999),
              )!;

              final dimOthers = hasSelection && !isActive
                  ? (1 - 0.35 * selectionStrength)
                  : 1.0;

              return Expanded(
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

                                  return Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Transform.scale(
                                      scaleX: isSelected
                                          ? 1 + (0.14 * selectionStrength)
                                          : 1,
                                      scaleY: isSelected
                                          ? 1 + (0.04 * selectionStrength)
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
                                          selectionT: selectionStrength,
                                        ),
                                      ),
                                    ),
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
                                  ? (1 - selectionStrength).clamp(0.0, 1.0)
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
              );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                if (showValue)
                  Positioned(
                    top: 0,
                    left: _barCenterX(activeIndex, barCount, chartWidth) - 72,
                    width: 144,
                    child: _ValueTooltip(
                      value: formatDashboardCurrency(
                        points[activeIndex].revenue,
                      ),
                      barColor: Color.lerp(
                        isDark ? AppColors.primaryOled : AppColors.primaryLight,
                        isDark
                            ? AppColors.primaryOledDim
                            : AppColors.primaryDark,
                        activeIndex / (barCount - 1).clamp(1, 999),
                      )!,
                      progress: selectionT.clamp(0.35, 1.0),
                      isDark: isDark,
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  double _barCenterX(int index, int barCount, double chartWidth) {
    final segment = chartWidth / barCount;
    return segment * index + segment / 2;
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
          scale: 0.92 + (0.08 * progress),
          alignment: Alignment.center,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isDark ? colors.elevatedSurface : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: barColor.withValues(alpha: isDark ? 0.55 : 0.35),
                width: 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: barColor.withValues(alpha: 0.32 * progress),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
                if (!isDark)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                value,
                maxLines: 1,
                softWrap: false,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? barColor : AppColors.primaryDark,
                  fontSize: 13,
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
    );
  }
}
