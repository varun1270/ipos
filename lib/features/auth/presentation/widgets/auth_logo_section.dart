import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../shared/widgets/ipos_logo_3d.dart';

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
  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoLift;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: _entranceDuration,
    );
    final logoCurve = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
    );

    _logoFade = Tween<double>(begin: 0, end: 1).animate(logoCurve);
    _logoScale = Tween<double>(begin: 0.72, end: 1).animate(logoCurve);
    _logoLift = Tween<double>(begin: 14, end: 0).animate(logoCurve);

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
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
          child: IposLogo3D(
            scale: scale,
            animated: true,
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
              color: context.appColors.textPrimary,
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
              color: context.appColors.textSecondary,
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
