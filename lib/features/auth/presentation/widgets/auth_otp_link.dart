import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../animations/auth_animations.dart';

class AuthOtpLink extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String label;

  const AuthOtpLink({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.label = 'Login with OTP',
  });

  @override
  State<AuthOtpLink> createState() => _AuthOtpLinkState();
}

class _AuthOtpLinkState extends State<AuthOtpLink>
    with TickerProviderStateMixin {
  static const double _height = 56;
  static const double _radius = 18;

  late final AnimationController _shimmerController;
  late final AnimationController _iconPulseController;
  late final AnimationController _pressController;

  late final Animation<double> _shimmer;
  late final Animation<double> _iconPulse;
  late final Animation<double> _press;

  bool get _isEnabled => !widget.isLoading && widget.onPressed != null;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
    _iconPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 200),
    );

    _shimmer = CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    );
    _iconPulse = Tween<double>(begin: 1, end: 1.12).animate(
      CurvedAnimation(parent: _iconPulseController, curve: Curves.easeInOut),
    );
    _press = CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _iconPulseController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    if (!_isEnabled) return;
    HapticFeedback.lightImpact();
    _pressController.forward();
  }

  void _onTapUp(TapUpDetails _) {
    if (!_isEnabled) return;
    _pressController.reverse();
    widget.onPressed?.call();
  }

  void _onTapCancel() {
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AuthAnimations.fadeSlide(
      index: 4,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedBuilder(
          animation: Listenable.merge([_shimmer, _iconPulse, _press]),
          builder: (context, child) {
            final pressScale = 1 - (0.03 * _press.value);
            final shimmerT = _shimmer.value;

            return Transform.scale(
              scale: pressScale,
              child: Opacity(
                opacity: _isEnabled ? 1 : 0.55,
                child: Container(
                  height: _height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(_radius),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primaryVeryLight,
                        AppColors.primaryVeryLight.withValues(alpha: 0.6),
                      ],
                    ),
                    border: Border.all(
                      color: AppColors.primary.withValues(
                        alpha: _isEnabled ? 0.28 + (0.08 * _press.value) : 0.14,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryShadow.withValues(
                          alpha: _isEnabled ? 0.35 - (0.12 * _press.value) : 0.1,
                        ),
                        blurRadius: 12 - (4 * _press.value),
                        offset: Offset(0, 4 - (2 * _press.value)),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.scale(
                        scale: _isEnabled ? _iconPulse.value : 1,
                        child: Icon(
                          Icons.sms_rounded,
                          size: 22,
                          color: _isEnabled
                              ? AppColors.primary
                              : AppColors.primaryLight,
                        ),
                      ),
                      const SizedBox(width: 10),
                      _ShimmerLabel(
                        label: widget.label,
                        shimmerT: shimmerT,
                        enabled: _isEnabled,
                      ),
                      const SizedBox(width: 6),
                      Transform.translate(
                        offset: Offset(3 * (_iconPulse.value - 1), 0),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          size: 20,
                          color: _isEnabled
                              ? AppColors.primary
                              : AppColors.primaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ShimmerLabel extends StatelessWidget {
  final String label;
  final double shimmerT;
  final bool enabled;

  const _ShimmerLabel({
    required this.label,
    required this.shimmerT,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    const baseStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.2,
    );

    if (!enabled) {
      return Text(
        label,
        style: baseStyle.copyWith(color: AppColors.primaryLight),
      );
    }

    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        final slide = -1.2 + (shimmerT * 2.4);
        return LinearGradient(
          begin: Alignment(slide - 0.5, 0),
          end: Alignment(slide + 0.5, 0),
          colors: const [
            AppColors.primary,
            AppColors.primaryLight,
            AppColors.primary,
          ],
          stops: const [0.2, 0.5, 0.8],
        ).createShader(bounds);
      },
      child: Text(label, style: baseStyle.copyWith(color: Colors.white)),
    );
  }
}
