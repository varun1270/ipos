import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OnboardingIcon extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final Color innerColor;
  final Color outerColor;

  const OnboardingIcon({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.innerColor,
    required this.outerColor,
  });

  @override
  State<OnboardingIcon> createState() => _OnboardingIconState();
}

class _OnboardingIconState extends State<OnboardingIcon>
    with SingleTickerProviderStateMixin {
  static const double _floatTop = -30;
  static const double _floatBottom = 18;
  static const double _groundTime = 0.50;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1550),
    );

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 0 = on the ground, 1 = highest point in the bounce.
  double _elevation(double t) {
    final distanceFromGround = (t - _groundTime).abs() / _groundTime;
    final easedDistance = Curves.easeOutCubic.transform(
      distanceFromGround.clamp(0.0, 1.0),
    );

    return easedDistance.clamp(0.0, 1.0);
  }

  double _bounceY(double t) {
    final elevation = _elevation(t);
    return _floatBottom + (_floatTop - _floatBottom) * elevation;
  }

  double _swayX(double t) {
    return math.sin(t * math.pi * 2) * 2.4;
  }

  double _impactAmount(double t) {
    const impactWindow = 0.16;
    final distanceFromGround = (t - _groundTime).abs();

    if (distanceFromGround > impactWindow) {
      return 0;
    }

    final progress = 1 - distanceFromGround / impactWindow;
    final smoothProgress =
        progress * progress * progress * (10 + progress * (6 * progress - 15));
    return smoothProgress * 0.38;
  }

  double _motionScale(double t) {
    const scaleAmount = 0.018;

    if (t < _groundTime) {
      final fallProgress = (t / _groundTime).clamp(0.0, 1.0);
      final easedFall = Curves.easeInOutSine.transform(fallProgress);
      return easedFall * scaleAmount;
    }

    final riseProgress = ((t - _groundTime) / (1 - _groundTime)).clamp(
      0.0,
      1.0,
    );
    final easedRise = Curves.easeInOutSine.transform(1 - riseProgress);
    return -easedRise * scaleAmount;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
          height: 230,
          width: 230,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final t = _controller.value;
              final y = _bounceY(t);
              final x = _swayX(t);
              final elevation = _elevation(t);
              final proximity = 1 - elevation;
              final impact = _impactAmount(t);
              final motionScale = _motionScale(t);

              final groundOpacity = 0.06 + proximity * 0.16 + impact * 0.08;
              final groundBlur = 10 + proximity * 24 + impact * 6;
              final groundSpread = proximity * 7 + impact * 3;
              final groundScaleX = 0.70 + proximity * 0.38 + impact * 0.12;
              final groundScaleY = 0.16 + proximity * 0.12 + impact * 0.05;

              final dropBlur = 8 + proximity * 24;
              final dropOffsetY = 6 + proximity * 16;
              final dropOpacity = 0.06 + proximity * 0.14;

              final groundBlend = Curves.easeInOut.transform(proximity);
              final travelScale = motionScale * (1 - impact * groundBlend);
              final sphereScaleX = 1 + travelScale + impact * 0.018;
              final sphereScaleY = 1 + travelScale - impact * 0.022;
              final tiltX = (elevation - 0.5) * 0.10;
              final tiltZ = x * 0.012 + impact * 0.002;

              final ambientOpacity = 0.18 + elevation * 0.22;
              final ambientBlur = 26 + elevation * 22;

              return Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    bottom: 20,
                    child: Transform.translate(
                      offset: Offset(x * 0.6, 0),
                      child: Transform.scale(
                        scaleX: groundScaleX,
                        scaleY: groundScaleY,
                        child: Container(
                          width: 152,
                          height: 46,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: groundOpacity,
                                ),
                                blurRadius: groundBlur,
                                spreadRadius: groundSpread,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(x, y),
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.0015)
                        ..rotateX(tiltX)
                        ..rotateZ(tiltZ),
                      child: Transform.scale(
                        alignment: Alignment.bottomCenter,
                        scaleX: sphereScaleX,
                        scaleY: sphereScaleY,
                        child: _IconSphere(
                          icon: widget.icon,
                          iconColor: widget.iconColor,
                          innerColor: widget.innerColor,
                          outerColor: widget.outerColor,
                          dropBlur: dropBlur,
                          dropOffsetY: dropOffsetY,
                          dropOpacity: dropOpacity,
                          ambientBlur: ambientBlur,
                          ambientOpacity: ambientOpacity,
                          elevation: elevation,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        )
        .animate()
        .scale(duration: 600.ms, curve: Curves.easeOutBack)
        .fadeIn(duration: 500.ms);
  }
}

class _IconSphere extends StatelessWidget {
  const _IconSphere({
    required this.icon,
    required this.iconColor,
    required this.innerColor,
    required this.outerColor,
    required this.dropBlur,
    required this.dropOffsetY,
    required this.dropOpacity,
    required this.ambientBlur,
    required this.ambientOpacity,
    required this.elevation,
  });

  final IconData icon;
  final Color iconColor;
  final Color innerColor;
  final Color outerColor;
  final double dropBlur;
  final double dropOffsetY;
  final double dropOpacity;
  final double ambientBlur;
  final double ambientOpacity;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final specularOpacity = 0.55 + elevation * 0.25;

    return SizedBox(
      height: 184,
      width: 184,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 184,
            width: 184,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: innerColor.withValues(alpha: ambientOpacity),
                  blurRadius: ambientBlur,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          Container(
            height: 180,
            width: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: const Alignment(-0.30, -0.40),
                radius: 1.10,
                colors: [
                  _lighten(outerColor, 0.06).withValues(alpha: 0.95),
                  outerColor,
                  _darken(outerColor, 0.06),
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
          ),
          Container(
            height: 180,
            width: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0),
                  Colors.black.withValues(alpha: 0.06),
                ],
              ),
            ),
          ),
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: dropOpacity),
                  blurRadius: dropBlur,
                  offset: Offset(0, dropOffsetY),
                  spreadRadius: elevation * 0.6,
                ),
                BoxShadow(
                  color: _lighten(innerColor, 0.10).withValues(alpha: 0.35),
                  blurRadius: 14,
                  offset: Offset(-3, -5 * elevation - 2),
                ),
              ],
            ),
            child: ClipOval(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(-0.35, -0.45),
                        radius: 1.0,
                        colors: [
                          _lighten(innerColor, 0.18),
                          innerColor,
                          _darken(innerColor, 0.10),
                        ],
                        stops: const [0.0, 0.50, 1.0],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0),
                          Colors.black.withValues(alpha: 0.10),
                        ],
                        stops: const [0.55, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    left: 16,
                    child: Container(
                      width: 88,
                      height: 18,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.elliptical(44, 9),
                        ),
                        gradient: RadialGradient(
                          center: const Alignment(0, 0.6),
                          radius: 0.9,
                          colors: [
                            Colors.white.withValues(alpha: 0.10),
                            Colors.white.withValues(alpha: 0),
                          ],
                          stops: const [0.0, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 18,
                    left: 28,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(
                          alpha: 0.85 * specularOpacity,
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    icon,
                    color: iconColor,
                    size: 54,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.16),
                        offset: Offset(0, 2 + (1 - elevation) * 2),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
}
