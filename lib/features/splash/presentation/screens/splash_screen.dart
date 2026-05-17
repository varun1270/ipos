import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _particleController;
  late AnimationController _progressController;

  // Animation values
  late Animation<double> logoScale;
  late Animation<double> logoRotation;
  late List<Animation<double>> letterAnimations;
  late Animation<double> taglineOpacity;
  late List<Animation<double>> chipAnimations;
  late Animation<double> footerOpacity;
  late Animation<double> progressValue;

  // Glow and sparkle animations
  late Animation<double> glowScale;
  late Animation<double> glowOpacity;
  late List<Animation<Offset>> sparkleOffsets;
  late List<Animation<double>> sparkleOpacities;
  late List<Animation<double>> ringScales;
  late List<Animation<double>> ringOpacities;

  // Background blob animations
  late List<Animation<Offset>> blobOffsets;

  // Particles
  List<ParticleData> particles = [];

  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeParticles();

    // Navigate to onboarding after 3.6 seconds
    Future.delayed(const Duration(milliseconds: 3600), () {
      if (mounted) {
        context.goNamed('onboarding');
      }
    });
  }

  void _initializeAnimations() {
    // Main animation controller for the sequence
    _mainController = AnimationController(duration: const Duration(milliseconds: 1600), vsync: this)..forward();

    // Particle controller for continuous animation
    _particleController = AnimationController(duration: const Duration(milliseconds: 4000), vsync: this)..repeat();

    // Progress controller for progress bar fill
    _progressController = AnimationController(duration: const Duration(milliseconds: 2100), vsync: this);

    // LOGO ANIMATIONS (0ms - 440ms )
    logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.275, curve: Curves.elasticOut),
      ),
    );

    logoRotation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.275, curve: Curves.elasticOut),
      ),
    );

    // GLOW BURST (440ms )
    glowScale = Tween<double>(begin: 0.5, end: 2.2).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.27, 0.32, curve: Curves.easeOut),
      ),
    );

    glowOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.27, 0.32, curve: Curves.easeOut),
      ),
    );

    // SPARKLE BURST (460ms - 620ms )
    sparkleOffsets = List.generate(
      6,
      (i) => Tween<Offset>(begin: Offset.zero, end: Offset(math.cos(i * math.pi / 3) * 80, math.sin(i * math.pi / 3) * 80)).animate(
        CurvedAnimation(
          parent: _mainController,
          curve: const Interval(0.29, 0.39, curve: Curves.easeOut),
        ),
      ),
    );

    sparkleOpacities = List.generate(
      6,
      (i) => Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
          parent: _mainController,
          curve: const Interval(0.29, 0.39, curve: Curves.easeOut),
        ),
      ),
    );

    // PULSING RINGS (0ms, 730ms stagger )
    // Start at 1.0 so rings are at least as large as the logo initially
    ringScales = List.generate(
      3,
      (i) => Tween<double>(begin: 1.0, end: 2.0).animate(
        CurvedAnimation(
          parent: _mainController,
          curve: Interval(
            (i * 0.045), // 730ms stagger
            (i * 0.045) + 0.15,
            curve: Curves.easeOut,
          ),
        ),
      ),
    );

    ringOpacities = List.generate(
      3,
      (i) => Tween<double>(begin: 0.8, end: 0.0).animate(
        CurvedAnimation(
          parent: _mainController,
          curve: Interval((i * 0.045), (i * 0.045) + 0.15, curve: Curves.easeOut),
        ),
      ),
    );

    // LETTER ANIMATIONS (580ms - 865ms )
    final letterTimings = [0.36, 0.42, 0.48, 0.54];
    letterAnimations = letterTimings.map((timing) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _mainController,
          curve: Interval(timing, timing + 0.08, curve: Curves.elasticOut),
        ),
      );
    }).toList();

    // TAGLINE ANIMATION (1020ms )
    taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.63, 0.75, curve: Curves.easeOut),
      ),
    );

    // FEATURE CHIPS (1260ms - 1530ms )
    chipAnimations = List.generate(4, (i) {
      final start = 0.78 + (i * 0.04);
      final end = math.min(0.95 + (i * 0.04), 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _mainController,
          curve: Interval(start, end, curve: Curves.elasticOut),
        ),
      );
    });

    // FOOTER + PROGRESS (1500ms )
    footerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.93, 1.0, curve: Curves.easeOut),
      ),
    );

    // Progress bar animation starts at 500ms and fills until 3100ms
    _progressController.forward();
    progressValue = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _progressController, curve: Curves.linear));

    // BLOB ANIMATIONS (continuous background movement )
    blobOffsets = [
      Tween<Offset>(begin: Offset.zero, end: const Offset(20, -20)).animate(CurvedAnimation(parent: _particleController, curve: Curves.linear)),
      Tween<Offset>(begin: Offset.zero, end: const Offset(-20, 20)).animate(CurvedAnimation(parent: _particleController, curve: Curves.linear)),
      Tween<Offset>(begin: Offset.zero, end: const Offset(15, 15)).animate(CurvedAnimation(parent: _particleController, curve: Curves.linear)),
      Tween<Offset>(begin: Offset.zero, end: const Offset(-15, -15)).animate(CurvedAnimation(parent: _particleController, curve: Curves.linear)),
    ];
  }

  void _initializeParticles() {
    particles = List.generate(10, (index) {
      return ParticleData(
        x: _random.nextDouble() * 350 - 175, // -175 to 175
        y: _random.nextDouble() * 800, // Distribute across height
        velocity: 20 + _random.nextDouble() * 60, // 20-80 px/s upward
        delay: Duration(milliseconds: _random.nextInt(800)),
        opacity: 0.3 + _random.nextDouble() * 0.6, // 0.3 to 0.9
      );
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background blobs with depth
          _buildBackgroundBlobs(size),

          // Floating particles
          _buildFloatingParticles(size),

          // Main content centered
          Center(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with animations
                  _buildAnimatedLogo(),

                  const SizedBox(height: 40),

                  // IPOS text letter-by-letter
                  _buildAnimatedText(),

                  const SizedBox(height: 24),

                  // Tagline
                  _buildTagline(),

                  const SizedBox(height: 48),

                  // Feature chips
                  _buildFeatureChips(),

                  const SizedBox(height: 60),

                  // Footer text
                  _buildFooter(),
                ],
              ),
            ),
          ),

          // Progress bar at bottom
          Positioned(bottom: 0, left: 0, right: 0, child: _buildProgressBar(size)),
        ],
      ),
    );
  }

  Widget _buildBackgroundBlobs(Size size) {
    return AnimatedBuilder(
      animation: Listenable.merge([_particleController]),
      builder: (context, child) {
        return Stack(
          children: [
            // Top-left blob
            Positioned(
              left: -50 + blobOffsets[0].value.dx,
              top: -50 + blobOffsets[0].value.dy,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.splashBlobLight.withValues(alpha: 0.15)),
                child: BackdropFilter(filter: ui.ImageFilter.blur(sigmaX: 40, sigmaY: 40), child: Container()),
              ),
            ),
            // Top-right blob
            Positioned(
              right: -50 + blobOffsets[1].value.dx,
              top: -50 + blobOffsets[1].value.dy,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.splashBlobLight.withValues(alpha: 0.12)),
                child: BackdropFilter(filter: ui.ImageFilter.blur(sigmaX: 40, sigmaY: 40), child: Container()),
              ),
            ),
            // Bottom-left blob
            Positioned(
              left: -50 + blobOffsets[2].value.dx,
              bottom: -50 + blobOffsets[2].value.dy,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.splashBlobLight.withValues(alpha: 0.1)),
                child: BackdropFilter(filter: ui.ImageFilter.blur(sigmaX: 40, sigmaY: 40), child: Container()),
              ),
            ),
            // Bottom-right blob
            Positioned(
              right: -50 + blobOffsets[3].value.dx,
              bottom: -50 + blobOffsets[3].value.dy,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.splashBlobLight.withValues(alpha: 0.08)),
                child: BackdropFilter(filter: ui.ImageFilter.blur(sigmaX: 40, sigmaY: 40), child: Container()),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFloatingParticles(Size size) {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Stack(
          children: particles.map((particle) {
            final animationProgress = (_particleController.value * 1000 - particle.delay.inMilliseconds) / 3000;
            if (animationProgress < 0) {
              return const SizedBox.shrink();
            }

            final yOffset = -animationProgress * particle.velocity * 60; // pixels moved up
            final opacity = animationProgress < 0.2 ? animationProgress / 0.2 * particle.opacity : (animationProgress > 0.8 ? (1 - animationProgress) / 0.2 * particle.opacity : particle.opacity);

            return Positioned(
              left: size.width / 2 + particle.x,
              top: size.height / 2 + particle.y + yOffset,
              child: Opacity(
                opacity: opacity.clamp(0.0, 1.0),
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.splashParticle),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: Listenable.merge([logoScale, logoRotation, glowScale, glowOpacity, _mainController]),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Glow burst effect
            Container(
              width: 120 * glowScale.value,
              height: 120 * glowScale.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.splashGlow.withValues(alpha: glowOpacity.value * 0.6),
              ),
            ),

            // Main logo
            Transform.scale(
              scale: logoScale.value,
              child: Transform.rotate(
                angle: logoRotation.value,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.textOnPrimary.withValues(alpha: 0.95)),
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
                      child: Center(child: Image.asset('assets/logos/app_logo.png', width: 64, height: 64, fit: BoxFit.contain)),
                    ),
                  ),
                ),
              ),
            ),

            // Pulsing rings (overlay the logo so they are visible)
            ..._buildPulsingRings(),

            // Sparkle burst
            ..._buildSparkles(),
          ],
        );
      },
    );
  }

  List<Widget> _buildPulsingRings() {
    return List.generate(3, (i) {
      return AnimatedBuilder(
        animation: Listenable.merge([ringScales[i], ringOpacities[i]]),
        builder: (context, child) {
          return Container(
            width: 120 * ringScales[i].value,
            height: 120 * ringScales[i].value,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.splashGlow.withValues(alpha: (ringOpacities[i].value * 0.9).clamp(0.0, 1.0)), width: 3),
              boxShadow: [BoxShadow(color: AppColors.splashGlow.withValues(alpha: (ringOpacities[i].value * 0.25).clamp(0.0, 1.0)), blurRadius: 8, spreadRadius: 1)],
            ),
          );
        },
      );
    });
  }

  List<Widget> _buildSparkles() {
    return List.generate(6, (i) {
      return AnimatedBuilder(
        animation: Listenable.merge([sparkleOffsets[i], sparkleOpacities[i]]),
        builder: (context, child) {
          return Transform.translate(
            offset: sparkleOffsets[i].value,
            child: Opacity(
              opacity: sparkleOpacities[i].value.clamp(0.0, 1.0),
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.splashGlow),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildAnimatedText() {
    final letters = ['I', 'P', 'O', 'S'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        letters.length,
        (i) => AnimatedBuilder(
          animation: letterAnimations[i],
          builder: (context, child) {
            final progress = letterAnimations[i].value;
            return Transform.translate(
              offset: Offset(0, (1 - progress) * 30),
              child: Opacity(
                opacity: progress.clamp(0.0, 1.0),
                child: Text(
                  letters[i],
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: AppColors.textOnPrimary, letterSpacing: 2),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTagline() {
    return AnimatedBuilder(
      animation: taglineOpacity,
      builder: (context, child) {
        return Opacity(
          opacity: taglineOpacity.value,
          child: Transform.translate(
            offset: Offset(0, (1 - taglineOpacity.value) * 20),
            child: Text(
              'Modern POS & Customer Commerce',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textOnPrimary.withValues(alpha: 0.8), letterSpacing: 0.5),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureChips() {
    final features = ['💳 Smart Payments', '📊 Analytics', '👥 Customer CRM', '📦 Inventory'];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(
        features.length,
        (i) => AnimatedBuilder(
          animation: chipAnimations[i],
          builder: (context, child) {
            final progress = chipAnimations[i].value;
            return Transform.scale(
              scale: progress * 0.3 + 0.7, // 0.7 to 1.0
              child: Opacity(
                opacity: progress.clamp(0.0, 1.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.textOnPrimary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.textOnPrimary.withValues(alpha: 0.2), width: 1),
                  ),
                  child: Text(
                    features[i],
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textOnPrimary.withValues(alpha: 0.9)),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return AnimatedBuilder(
      animation: footerOpacity,
      builder: (context, child) {
        return Opacity(
          opacity: footerOpacity.value,
          child: Column(
            children: [
              Text(
                'Getting your store ready...',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textOnPrimary.withValues(alpha: 0.7)),
              ),
              // const SizedBox(height: 16),
              // _buildShimmeringProgressBar(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmeringProgressBar() {
    return AnimatedBuilder(
      animation: progressValue,
      builder: (context, child) {
        return Column(
          children: [
            Container(
              height: 3,
              decoration: BoxDecoration(color: AppColors.textOnPrimary.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(2)),
              child: Stack(
                children: [
                  FractionallySizedBox(
                    widthFactor: progressValue.value,
                    child: Container(
                      decoration: BoxDecoration(color: AppColors.textOnPrimary.withValues(alpha: 0.8), borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  // Shimmer effect on progress bar
                  Positioned(
                    left: progressValue.value * 350 - 50,
                    top: 0,
                    child: Container(
                      width: 50,
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [AppColors.textOnPrimary.withValues(alpha: 0), AppColors.textOnPrimary.withValues(alpha: 0.8), AppColors.textOnPrimary.withValues(alpha: 0)]),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProgressBar(Size size) {
    return AnimatedBuilder(
      animation: progressValue,
      builder: (context, child) {
        final pct = (progressValue.value * 100).clamp(0, 100).round();
        final fillWidth = (progressValue.value * size.width).clamp(0.0, size.width);

        return SizedBox(
          width: size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Track
              Container(
                width: size.width,
                height: 4,
                color: AppColors.textOnPrimary.withValues(alpha: 0.15),
                child: Stack(
                  children: [
                    // Filled portion starts at left edge and expands right
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(width: fillWidth, color: AppColors.textOnPrimary.withValues(alpha: 0.6)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              // Percentage label (centered)
              Text(
                '$pct%',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textOnPrimary.withValues(alpha: 0.85)),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ParticleData {
  final double x;
  final double y;
  final double velocity;
  final Duration delay;
  final double opacity;

  ParticleData({required this.x, required this.y, required this.velocity, required this.delay, required this.opacity});
}
