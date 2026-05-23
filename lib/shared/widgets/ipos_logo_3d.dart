import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// 3D IPOS logo card — same visual as the login screen logo.
class IposLogo3D extends StatefulWidget {
  static const double baseWidth = 128;
  static const double baseHeight = 76;
  static const String logoAsset = 'assets/logos/app_logo.png';

  final double scale;
  final bool animated;

  const IposLogo3D({
    super.key,
    this.scale = 1,
    this.animated = false,
  });

  @override
  State<IposLogo3D> createState() => _IposLogo3DState();
}

class _IposLogo3DState extends State<IposLogo3D> with TickerProviderStateMixin {
  static const double _depth = 5;
  static const double _radius = 22;

  AnimationController? _entranceController;
  AnimationController? _floatController;
  Animation<double>? _shadowStrength;
  Animation<double>? _float;

  @override
  void initState() {
    super.initState();
    if (!widget.animated) return;

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    _shadowStrength = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceController!,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
      ),
    );
    _float = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _floatController!, curve: Curves.easeInOut),
    );

    _entranceController!.forward().then((_) {
      if (mounted) _floatController!.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _entranceController?.dispose();
    _floatController?.dispose();
    super.dispose();
  }

  double get _width => IposLogo3D.baseWidth * widget.scale;
  double get _height => IposLogo3D.baseHeight * widget.scale;

  Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkTheme;
    final color = isDark ? context.adaptivePrimary : AppColors.primary;
    final baseColor = _darken(color, isDark ? 0.14 : 0.22);

    Widget buildLogo(double shadowT, double bob) {
      final floatY = widget.animated ? -3.5 * bob : 0.0;
      final floatTilt = widget.animated ? 0.018 * bob : 0.0;

      return SizedBox(
        width: _width,
        height: _height + _depth,
        child: Transform.translate(
          offset: Offset(0, floatY),
          child: Transform.rotate(
            angle: floatTilt,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: _depth,
                  child: Container(
                    width: _width,
                    height: _height,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: BorderRadius.circular(_radius),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.22 * shadowT),
                          blurRadius: 22 * shadowT,
                          offset: Offset(0, 12 * shadowT),
                          spreadRadius: -6,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  child: Container(
                    width: _width,
                    height: _height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(_radius),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: 0.16 * shadowT,
                          ),
                          blurRadius: 14 * shadowT,
                          offset: Offset(0, 8 * shadowT),
                          spreadRadius: -3,
                        ),
                        if (!isDark)
                          BoxShadow(
                            color: color.withValues(alpha: 0.28 * shadowT),
                            blurRadius: 16 * shadowT,
                            offset: Offset(0, 4 * shadowT),
                            spreadRadius: -4,
                          ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(_radius),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (!isDark)
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              height: _height * 0.4,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.white.withValues(alpha: 0.18),
                                      Colors.white.withValues(alpha: 0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          Center(
                            child: Image.asset(
                              IposLogo3D.logoAsset,
                              width: _width,
                              height: _height,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: _width,
                                  height: _height,
                                  color: AppColors.primary,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.storefront_rounded,
                                    color: AppColors.textOnPrimary,
                                    size: 36 * widget.scale,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (!widget.animated) {
      return buildLogo(1, 0);
    }

    return AnimatedBuilder(
      animation: Listenable.merge([_shadowStrength!, _float!]),
      builder: (context, _) {
        final shadowT = _shadowStrength!.value;
        final bob = (_float!.value - 0.5) * 2;
        return buildLogo(shadowT, bob);
      },
    );
  }
}
