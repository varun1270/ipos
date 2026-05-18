import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';

class AuthLogoSection extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool compact;

  const AuthLogoSection({
    super.key,
    required this.title,
    required this.subtitle,
    this.compact = false,
  });

  @override
  State<AuthLogoSection> createState() => _AuthLogoSectionState();
}

class _AuthLogoSectionState extends State<AuthLogoSection>
    with TickerProviderStateMixin {
  static const Duration _entranceDuration = Duration(milliseconds: 900);
  static const Duration _textSwitchDuration = Duration(milliseconds: 320);

  late final AnimationController _entranceController;
  late final AnimationController _floatController;
  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoLift;
  late final Animation<double> _shadowStrength;
  late final Animation<double> _float;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: _entranceDuration,
    );
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    final logoCurve = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
    );

    _logoFade = Tween<double>(begin: 0, end: 1).animate(logoCurve);
    _logoScale = Tween<double>(begin: 0.72, end: 1).animate(logoCurve);
    _logoLift = Tween<double>(begin: 14, end: 0).animate(logoCurve);
    _shadowStrength = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
      ),
    );
    _float = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _entranceController.forward().then((_) {
      if (mounted) _floatController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.compact ? 1.0 : context.layoutScale;
    final titleSize = (widget.compact ? 28.0 : 28.0) * scale;
    final subtitleSize = (widget.compact ? 15.0 : 15.0) * scale;

    return Column(
      children: [
        AnimatedBuilder(
          animation: _entranceController,
          builder: (context, child) {
            return Opacity(
              opacity: _logoFade.value.clamp(0.0, 1.0),
              child: Transform.translate(
                offset: Offset(0, _logoLift.value),
                child: Transform.scale(
                  scale: _logoScale.value,
                  child: child,
                ),
              ),
            );
          },
          child: _Logo3D(
            shadowStrength: _shadowStrength,
            float: _float,
            scale: scale,
          ),
        ),
        SizedBox(height: 24 * scale),
        AnimatedSwitcher(
          duration: _textSwitchDuration,
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            final slide = Tween<Offset>(
              begin: const Offset(0, 0.18),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: slide, child: child),
            );
          },
          child: _AnimatedTextBlock(
            key: ValueKey('${widget.title}|${widget.subtitle}'),
            title: widget.title,
            subtitle: widget.subtitle,
            entranceController: _entranceController,
            titleSize: titleSize,
            subtitleSize: subtitleSize,
          ),
        ),
      ],
    );
  }
}

class _Logo3D extends StatelessWidget {
  static const double _baseWidth = 128;
  static const double _baseHeight = 76;
  static const double _depth = 5;
  static const double _radius = 22;
  static const String _logoAsset = 'assets/logos/app_logo.png';

  final Animation<double> shadowStrength;
  final Animation<double> float;
  final double scale;

  const _Logo3D({
    required this.shadowStrength,
    required this.float,
    this.scale = 1,
  });

  double get _width => _baseWidth * scale;
  double get _height => _baseHeight * scale;

  Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  @override
  Widget build(BuildContext context) {
    const color = AppColors.primary;
    final baseColor = _darken(color, 0.22);

    return AnimatedBuilder(
      animation: Listenable.merge([shadowStrength, float]),
      builder: (context, child) {
        final shadowT = shadowStrength.value;
        final bob = (float.value - 0.5) * 2;
        final floatY = -3.5 * bob;
        final floatTilt = 0.018 * bob;

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
                            Center(child: child),
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
      },
      child: Image.asset(
        _logoAsset,
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
            child: const Icon(
              Icons.storefront_rounded,
              color: AppColors.textOnPrimary,
              size: 36,
            ),
          );
        },
      ),
    );
  }
}

class _AnimatedTextBlock extends StatelessWidget {
  final String title;
  final String subtitle;
  final AnimationController entranceController;
  final double titleSize;
  final double subtitleSize;

  const _AnimatedTextBlock({
    super.key,
    required this.title,
    required this.subtitle,
    required this.entranceController,
    required this.titleSize,
    required this.subtitleSize,
  });

  @override
  Widget build(BuildContext context) {
    final titleAnim = CurvedAnimation(
      parent: entranceController,
      curve: const Interval(0.35, 0.78, curve: Curves.easeOutCubic),
    );
    final subtitleAnim = CurvedAnimation(
      parent: entranceController,
      curve: const Interval(0.48, 0.92, curve: Curves.easeOutCubic),
    );

    return Column(
      key: key,
      children: [
        _StaggeredLine(
          animation: titleAnim,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: titleSize,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
        ),
        const SizedBox(height: 8),
        _StaggeredLine(
          animation: subtitleAnim,
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: subtitleSize,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

class _StaggeredLine extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const _StaggeredLine({required this.animation, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final t = animation.value.clamp(0.0, 1.0);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, 12 * (1 - t)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
