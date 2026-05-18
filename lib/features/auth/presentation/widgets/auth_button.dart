import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';

class AuthButton extends StatefulWidget {
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;

  const AuthButton({
    super.key,
    required this.text,
    this.isLoading = false,
    this.onPressed,
  });

  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton>
    with SingleTickerProviderStateMixin {
  static const double _height = 56;
  static const double _depth = 5;
  static const double _radius = 18;

  late final AnimationController _pressController;
  late final Animation<double> _press;

  bool get _isEnabled => !widget.isLoading && widget.onPressed != null;

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
    if (!_isEnabled) return;

    HapticFeedback.lightImpact();
    _pressController.forward();
  }

  Future<void> _onTapUp(TapUpDetails _) async {
    if (!_isEnabled) return;

    await _pressController.forward();
    await _pressController.reverse();

    if (mounted) widget.onPressed?.call();
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
    final buttonColor = _isEnabled ? AppColors.primary : AppColors.primaryLight;
    final baseColor = _darken(buttonColor, 0.22);
    final faceTop = _lighten(buttonColor, 0.08);
    final faceBottom = _darken(buttonColor, 0.06);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _press,
        builder: (context, child) {
          final t = _press.value;
          final faceOffset = _depth * t;
          final shadowBlur = 18 - (10 * t);
          final shadowSpread = -6 + (4 * t);
          final shadowYOffset = 10 - (6 * t);
          final glowOpacity = _isEnabled ? 0.35 - (0.15 * t) : 0.14;
          final foregroundColor = AppColors.textOnPrimary.withValues(
            alpha: _isEnabled ? 0.95 - (0.1 * t) : 0.75,
          );

          return SizedBox(
            height: _height + _depth,
            width: double.infinity,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: _depth,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: _height,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: BorderRadius.circular(_radius),
                      boxShadow: [
                        BoxShadow(
                          color: buttonColor.withValues(alpha: 0.22),
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
                      height: _height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(_radius),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [faceTop, buttonColor, faceBottom],
                          stops: const [0.0, 0.45, 1.0],
                        ),
                        border: Border.all(
                          color: _darken(
                            buttonColor,
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
                            color: buttonColor.withValues(alpha: glowOpacity),
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
                        borderRadius: BorderRadius.circular(_radius),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              height: _height * 0.42,
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
                  height: _height,
                  child: Transform.scale(
                    scale: 1 - (0.015 * t),
                    alignment: Alignment.topCenter,
                    child: Center(
                      child: widget.isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: AppColors.textOnPrimary,
                                strokeWidth: 2.4,
                              ),
                            )
                          : Text(
                              widget.text,
                              style: TextStyle(
                                color: foregroundColor,
                                fontSize: 20,
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
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
