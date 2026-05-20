import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/theme/app_colors.dart';

abstract final class Hard3DColors {
  static Color lighten(Color color, [double amount = 0.08]) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  static Color darken(Color color, [double amount = 0.06]) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }
}

/// Physical push-button 3D surface — same technique as [AuthButton].
class Hard3DSurface extends StatefulWidget {
  final Color color;
  final double borderRadius;
  final double depth;
  final EdgeInsetsGeometry padding;
  final Widget child;
  final VoidCallback? onTap;
  final bool enabled;
  final bool expandWidth;

  const Hard3DSurface({
    super.key,
    required this.color,
    required this.child,
    this.borderRadius = 18,
    this.depth = 5,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.enabled = true,
    this.expandWidth = false,
  });

  factory Hard3DSurface.light({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
    double borderRadius = 20,
    double depth = 4,
    VoidCallback? onTap,
    bool expandWidth = false,
  }) {
    return Hard3DSurface(
      key: key,
      color: Colors.white,
      borderRadius: borderRadius,
      depth: depth,
      padding: padding,
      onTap: onTap,
      expandWidth: expandWidth,
      child: child,
    );
  }

  @override
  State<Hard3DSurface> createState() => _Hard3DSurfaceState();
}

class _Hard3DSurfaceState extends State<Hard3DSurface>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;
  late final Animation<double> _press;

  bool get _interactive => widget.enabled && widget.onTap != null;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 220),
    );
    _press = CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    if (!_interactive) return;
    HapticFeedback.lightImpact();
    _pressController.forward();
  }

  Future<void> _onTapUp(TapUpDetails _) async {
    if (!_interactive) return;
    await _pressController.forward();
    await _pressController.reverse();
    if (mounted) widget.onTap?.call();
  }

  void _onTapCancel() => _pressController.reverse();

  @override
  Widget build(BuildContext context) {
    final faceColor =
        widget.enabled ? widget.color : widget.color.withValues(alpha: 0.55);
    final baseColor = Hard3DColors.darken(faceColor, 0.22);
    final faceTop = Hard3DColors.lighten(faceColor, 0.08);
    final faceBottom = Hard3DColors.darken(faceColor, 0.06);
    final sizedChild = Padding(padding: widget.padding, child: widget.child);

    final body = AnimatedBuilder(
      animation: _press,
      builder: (context, child) {
        final t = _press.value;
        final faceOffset = widget.depth * t;
        final shadowBlur = 18 - (10 * t);
        final shadowSpread = -6 + (4 * t);
        final shadowYOffset = 10 - (6 * t);
        final glowOpacity = widget.enabled ? 0.35 - (0.15 * t) : 0.14;

        return Transform.translate(
          offset: Offset(0, faceOffset),
          child: Transform.scale(
            scale: 1 - (0.015 * t),
            alignment: Alignment.topCenter,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [faceTop, faceColor, faceBottom],
                  stops: const [0.0, 0.45, 1.0],
                ),
                border: Border.all(
                  color: Hard3DColors.darken(
                    faceColor,
                    0.12,
                  ).withValues(alpha: 0.45),
                ),
                boxShadow: [
                  BoxShadow(
                    color: baseColor.withValues(alpha: 0.95),
                    blurRadius: 0,
                    offset: Offset(0, widget.depth),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: faceColor.withValues(alpha: 0.22),
                    blurRadius: 24,
                    offset: Offset(0, 14 + widget.depth),
                    spreadRadius: -10,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.22),
                    blurRadius: shadowBlur,
                    offset: Offset(0, shadowYOffset),
                    spreadRadius: shadowSpread,
                  ),
                  BoxShadow(
                    color: faceColor.withValues(alpha: glowOpacity),
                    blurRadius: 20 - (8 * t),
                    offset: Offset(0, 6 - (4 * t)),
                    spreadRadius: -4,
                  ),
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.14),
                    blurRadius: 6,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: Stack(
                  fit: StackFit.passthrough,
                  children: [
                    const Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 48,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0x3DFFFFFF),
                              Color(0x00FFFFFF),
                            ],
                          ),
                        ),
                      ),
                    ),
                    child!,
                  ],
                ),
              ),
            ),
          ),
        );
      },
      child: sizedChild,
    );

    return Padding(
      padding: EdgeInsets.only(bottom: widget.depth),
      child: _interactive
          ? GestureDetector(
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              onTapCancel: _onTapCancel,
              child: body,
            )
          : body,
    );
  }
}

class Hard3DChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback? onTap;

  const Hard3DChip({
    super.key,
    required this.label,
    required this.color,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!selected) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Hard3DSurface(
      color: color,
      borderRadius: 12,
      depth: 3,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      onTap: onTap,
      expandWidth: true,
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 13,
            shadows: [
              Shadow(
                color: Colors.black26,
                offset: Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
