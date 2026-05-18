import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/utils/responsive_utils.dart';

class OnboardingButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final Color color;

  const OnboardingButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.color,
  });

  @override
  State<OnboardingButton> createState() => _OnboardingButtonState();
}

class _OnboardingButtonState extends State<OnboardingButton>
    with SingleTickerProviderStateMixin {
  static const double _height = 62;
  static const double _depth = 5;
  static const double _radius = 22;

  late final AnimationController _pressController;
  late final Animation<double> _press;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
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
    HapticFeedback.lightImpact();
    _pressController.forward();
  }

  void _onTapUp(TapUpDetails _) {
    _pressController.reverse().then((_) {
      if (mounted) widget.onPressed();
    });
  }

  void _onTapCancel() {
    _pressController.reverse();
  }

  Color _lighten(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).height < 700;
    final maxWidth = context.responsiveValue(
      compact: double.infinity,
      medium: 520.0,
      expanded: 560.0,
    );
    final buttonHeight = isCompact ? 52.0 : _height;
    final buttonDepth = isCompact ? 4.0 : _depth;
    final buttonRadius = isCompact ? 18.0 : _radius;
    final textSize = isCompact ? 18.0 : 20.0;
    final baseColor = _darken(widget.color, 0.22);
    final faceTop = _lighten(widget.color, 0.08);
    final faceBottom = _darken(widget.color, 0.06);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _press,
        builder: (context, child) {
          final t = _press.value;
          final faceOffset = buttonDepth * t;
          final shadowBlur = 18 - (10 * t);
          final shadowSpread = -6 + (4 * t);
          final shadowYOffset = 10 - (6 * t);
          final glowOpacity = 0.35 - (0.15 * t);
          final foregroundColor = Colors.white.withValues(
            alpha: 0.95 - (0.1 * t),
          );

          return SizedBox(
            height: buttonHeight + buttonDepth,
            width: double.infinity,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: buttonDepth,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: buttonHeight,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: BorderRadius.circular(buttonRadius),
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withValues(alpha: 0.22),
                          blurRadius: 24,
                          offset: const Offset(0, 14),
                          spreadRadius: -10,
                        ),
                      ],
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, faceOffset),
                  child: Transform.scale(
                    scale: 1 - (0.015 * t),
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: buttonHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(buttonRadius),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [faceTop, widget.color, faceBottom],
                          stops: const [0.0, 0.45, 1.0],
                        ),
                        border: Border.all(
                          color: _darken(
                            widget.color,
                            0.12,
                          ).withValues(alpha: 0.45),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.22),
                            blurRadius: shadowBlur,
                            offset: Offset(0, shadowYOffset),
                            spreadRadius: shadowSpread,
                          ),
                          BoxShadow(
                            color: widget.color.withValues(alpha: glowOpacity),
                            blurRadius: 20 - (8 * t),
                            offset: Offset(0, 6 - (4 * t)),
                            spreadRadius: -4,
                          ),
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.12),
                            blurRadius: 6,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(buttonRadius),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              height: buttonHeight * 0.42,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.white.withValues(alpha: 0.22),
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
                ),
                Positioned(
                  top: faceOffset,
                  left: 0,
                  right: 0,
                  height: buttonHeight,
                  child: Transform.scale(
                    scale: 1 - (0.015 * t),
                    alignment: Alignment.topCenter,
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.text,
                            style: TextStyle(
                              color: foregroundColor,
                              fontSize: textSize,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.2,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.24),
                                  offset: const Offset(0, 1.5),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Transform.translate(
                            offset: Offset(2 * t, 0),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: foregroundColor,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  offset: const Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
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
        },
      ),
        ),
      ),
    );
  }
}
