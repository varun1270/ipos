import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';

class AuthBrandPanel extends StatefulWidget {
  const AuthBrandPanel({super.key});

  @override
  State<AuthBrandPanel> createState() => _AuthBrandPanelState();
}

class _AuthBrandPanelState extends State<AuthBrandPanel>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _ambientController;

  static const _features = [
    (Icons.point_of_sale_rounded, 'Fast checkout & billing'),
    (Icons.people_alt_rounded, 'Customer CRM built-in'),
    (Icons.inventory_2_rounded, 'Inventory you can trust'),
    (Icons.insights_rounded, 'Real-time store analytics'),
  ];

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6200),
    )..repeat();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _ambientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = context.layoutScale;
    final logoSize = 96.0 * scale;
    final titleSize = context.responsiveValue(
      compact: 32.0,
      medium: 40.0,
      expanded: 48.0,
    );

    return AnimatedBuilder(
      animation: _ambientController,
      builder: (context, child) {
        final phase = _ambientController.value * math.pi * 2;
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primaryDark,
                AppColors.primaryExtraDark,
              ],
              stops: const [0, 0.55, 1],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _AmbientOrb(
                phase: phase,
                size: 220 * scale,
                top: -40,
                left: -30,
                opacity: 0.14,
              ),
              _AmbientOrb(
                phase: phase + 1.8,
                size: 180 * scale,
                bottom: 60,
                right: -20,
                opacity: 0.1,
              ),
              child!,
            ],
          ),
        );
      },
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.responsiveValue(
              compact: 32,
              medium: 40,
              expanded: 56,
            ),
            vertical: 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _fadeSlide(
                0,
                _BrandLogo(size: logoSize),
              ),
              SizedBox(height: 28 * scale),
              _fadeSlide(
                1,
                Text(
                  'IPOS',
                  style: TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: titleSize,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    height: 1,
                  ),
                ),
              ),
              SizedBox(height: 12 * scale),
              _fadeSlide(
                2,
                Text(
                  'Modern POS & Customer Commerce',
                  style: TextStyle(
                    color: AppColors.textOnPrimary.withValues(alpha: 0.82),
                    fontSize: 15 * scale,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),
              SizedBox(height: 36 * scale),
              ...List.generate(_features.length, (index) {
                final (icon, label) = _features[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 14 * scale),
                  child: _fadeSlide(
                    3 + index,
                    _FeatureRow(icon: icon, label: label, scale: scale),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fadeSlide(int index, Widget child) {
    final start = 0.08 + (index * 0.1);
    final end = (start + 0.42).clamp(0.0, 1.0);

    return AnimatedBuilder(
      animation: _entranceController,
      builder: (context, child) {
        final curve = CurvedAnimation(
          parent: _entranceController,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        );
        final t = curve.value;
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(-24 * (1 - t), 0),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _BrandLogo extends StatelessWidget {
  final double size;

  const _BrandLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.textOnPrimary,
            AppColors.textOnPrimary.withValues(alpha: 0.78),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: AppColors.splashGlow.withValues(alpha: 0.35),
            blurRadius: 20,
            spreadRadius: -4,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(size * 0.1),
        child: ClipOval(
          child: Image.asset(
            'assets/logos/app_logo.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.storefront_rounded,
              size: size * 0.45,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final double scale;

  const _FeatureRow({
    required this.icon,
    required this.label,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40 * scale,
          height: 40 * scale,
          decoration: BoxDecoration(
            color: AppColors.textOnPrimary.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.textOnPrimary.withValues(alpha: 0.22),
            ),
          ),
          child: Icon(icon, color: AppColors.textOnPrimary, size: 20 * scale),
        ),
        SizedBox(width: 14 * scale),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: AppColors.textOnPrimary.withValues(alpha: 0.92),
              fontSize: 14.5 * scale,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}

class _AmbientOrb extends StatelessWidget {
  final double phase;
  final double size;
  final double opacity;
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;

  const _AmbientOrb({
    required this.phase,
    required this.size,
    required this.opacity,
    this.top,
    this.left,
    this.right,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Transform.translate(
        offset: Offset(
          math.cos(phase) * 18,
          math.sin(phase) * 14,
        ),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.splashBlobLight.withValues(alpha: opacity),
                AppColors.splashBlobLight.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
