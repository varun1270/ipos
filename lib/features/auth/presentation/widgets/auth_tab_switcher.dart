import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/dark_ui_style.dart';

class AuthTabSwitcher extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const AuthTabSwitcher({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  static const double _tabHeight = 48;
  static const double _depth = 4;
  static const double _padding = 4;
  static const double _radius = 14;
  static const Duration _duration = Duration(milliseconds: 280);

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth = constraints.maxWidth;
        final pillWidth = (trackWidth - _padding * 2) / 2;

        return SizedBox(
          height: _tabHeight + _depth + _padding * 2,
          width: trackWidth,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surfaceVariant,
              borderRadius: BorderRadius.circular(_radius + 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(_padding),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedPositioned(
                    duration: _duration,
                    curve: Curves.easeOutCubic,
                    left: selectedIndex == 0 ? 0 : pillWidth,
                    top: 0,
                    width: pillWidth,
                    height: _tabHeight + _depth,
                    child: const _SlidingPill(
                      height: _tabHeight,
                      depth: _depth,
                      radius: _radius,
                    ),
                  ),
                  Row(
                    children: [
                      _TabItem(
                        label: 'Login',
                        isSelected: selectedIndex == 0,
                        height: _tabHeight,
                        depth: _depth,
                        onTap: () => _onTap(0),
                      ),
                      _TabItem(
                        label: 'Register',
                        isSelected: selectedIndex == 1,
                        height: _tabHeight,
                        depth: _depth,
                        onTap: () => _onTap(1),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onTap(int index) {
    if (index == selectedIndex) return;
    HapticFeedback.selectionClick();
    onChanged(index);
  }
}

class _SlidingPill extends StatelessWidget {
  final double height;
  final double depth;
  final double radius;

  const _SlidingPill({
    required this.height,
    required this.depth,
    required this.radius,
  });

  Color _lighten(Color c, double a) =>
      HSLColor.fromColor(c).withLightness(
        (HSLColor.fromColor(c).lightness + a).clamp(0.0, 1.0),
      ).toColor();

  Color _darken(Color c, double a) =>
      HSLColor.fromColor(c).withLightness(
        (HSLColor.fromColor(c).lightness - a).clamp(0.0, 1.0),
      ).toColor();

  @override
  Widget build(BuildContext context) {
    final isDark = DarkUiStyle.isDark(context);
    final brand = context.adaptivePrimary;
    final color =
        isDark ? DarkUiStyle.face3D(context, brand) : AppColors.primary;
    final base = _darken(color, isDark ? 0.14 : 0.2);
    final glowAlpha = isDark ? DarkUiStyle.coloredShadowAlpha : 0.35;

    return SizedBox(
      height: height + depth,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 2,
            right: 2,
            top: depth,
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: base,
                borderRadius: BorderRadius.circular(radius),
              ),
            ),
          ),
          Positioned(
            left: 2,
            right: 2,
            top: 0,
            child: Container(
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _lighten(color, 0.1),
                    color,
                    _darken(color, 0.06),
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: color.withValues(alpha: glowAlpha),
                    blurRadius: isDark ? 6 : 10,
                    offset: const Offset(0, 2),
                    spreadRadius: -2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (!isDark)
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: height * 0.4,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withValues(alpha: 0.28),
                                Colors.white.withValues(alpha: 0),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final double height;
  final double depth;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.height,
    required this.depth,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            height: height + depth,
            child: Padding(
              padding: EdgeInsets.only(bottom: depth),
              child: Center(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                        isSelected ? FontWeight.w800 : FontWeight.w600,
                    letterSpacing: isSelected ? 0.25 : 0,
                    color: isSelected
                        ? AppColors.textOnPrimary
                        : colors.textSecondary,
                    shadows: isSelected
                        ? [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              offset: const Offset(0, 1),
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
        ),
      ),
    );
  }
}
