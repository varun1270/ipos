import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OnboardingIcon extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final Color innerColor;
  final Color outerColor;
  final double size;

  const OnboardingIcon({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.innerColor,
    required this.outerColor,
    this.size = 230,
  });

  @override
  State<OnboardingIcon> createState() => _OnboardingIconState();
}

class _OnboardingIconState extends State<OnboardingIcon>
    with SingleTickerProviderStateMixin {
  static const double _floatTop = -30;
  static const double _floatBottom = 18;
  static const double _groundTime = 0.54;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2700),
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
    if (t < _groundTime) {
      final fallProgress = (t / _groundTime).clamp(0.0, 1.0);
      final acceleratedFall = math.pow(fallProgress, 1.75).toDouble();
      return (1 - acceleratedFall).clamp(0.0, 1.0);
    }

    final riseProgress = ((t - _groundTime) / (1 - _groundTime)).clamp(
      0.0,
      1.0,
    );

    final weightedRise = 1 - math.pow(1 - riseProgress, 1.55);
    return weightedRise.clamp(0.0, 1.0).toDouble();
  }

  double _bounceY(double t) {
    final elevation = _elevation(t);
    return _floatBottom + (_floatTop - _floatBottom) * elevation;
  }

  double _swayX(double t) {
    final residual = _residualMotion(t);
    final organicDrift =
        math.sin(t * math.pi * 2) * 2.1 + math.sin(t * math.pi * 5.4) * 0.18;

    return organicDrift + residual * 0.34;
  }

  double _impactAmount(double t) {
    const impactWindow = 0.14;
    final distanceFromGround = (t - _groundTime).abs();

    if (distanceFromGround > impactWindow) {
      return 0;
    }

    final progress = 1 - distanceFromGround / impactWindow;
    final smoothProgress =
        progress * progress * progress * (10 + progress * (6 * progress - 15));
    return smoothProgress * 0.30;
  }

  double _residualMotion(double t) {
    const settleWindow = 0.30;

    if (t < _groundTime || t > _groundTime + settleWindow) {
      return 0;
    }

    final progress = (t - _groundTime) / settleWindow;
    final envelope = math.pow(1 - progress, 2).toDouble();
    return math.sin(progress * math.pi * 5.2) * envelope;
  }

  double _motionScale(double t) {
    const scaleAmount = 0.015;

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
          height: widget.size,
          width: widget.size,
          child: FittedBox(
            child: SizedBox(
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
                  final residual = _residualMotion(t);
                  final motionScale = _motionScale(t);

                  final groundOpacity = 0.06 + proximity * 0.14 + impact * 0.06;
                  final groundBlur = 9 + proximity * 16 + impact * 4;
                  final groundSpread = proximity * 5 + impact * 2;
                  final groundScaleX = 0.72 + proximity * 0.32 + impact * 0.08;
                  final groundScaleY = 0.16 + proximity * 0.10 + impact * 0.04;

                  final dropBlur = 8 + proximity * 14;
                  final dropOffsetY = 6 + proximity * 12;
                  final dropOpacity = 0.06 + proximity * 0.12;

                  final groundBlend = Curves.easeInOut.transform(proximity);
                  final impactBlend = (impact * groundBlend * 3.2).clamp(
                    0.0,
                    1.0,
                  );
                  final travelScale = motionScale * (1 - impactBlend);
                  final residualScale = residual * 0.0025;
                  final sphereScaleX =
                      1 + travelScale + impact * 0.014 + residualScale;
                  final sphereScaleY =
                      1 + travelScale - impact * 0.017 - residualScale;
                  final tiltX = (elevation - 0.5) * 0.10;
                  final tiltZ = x * 0.010 + impact * 0.0015 + residual * 0.010;

                  final ambientOpacity = 0.16 + elevation * 0.18;
                  final ambientBlur = 22 + elevation * 12;

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
                        offset: Offset(x, y + residual * 0.35),
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
            ),
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
