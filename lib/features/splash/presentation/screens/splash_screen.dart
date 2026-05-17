import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const _splashDuration = Duration(milliseconds: 3600);
  static const _introDuration = Duration(milliseconds: 2400);
  static const _ambientDuration = Duration(milliseconds: 7000);
  static const _progressDuration = Duration(milliseconds: 3300);

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

  // Particles
  List<ParticleData> particles = [];

  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeParticles();

    // Navigate after the progress animation has had time to settle.
    Future.delayed(_splashDuration, () {
      if (mounted) {
        context.goNamed('onboarding');
      }
    });
  }

  void _initializeAnimations() {
    // Main animation controller for the sequence
    _mainController = AnimationController(duration: _introDuration, vsync: this)
      ..forward();

    // Ambient controller for looping background motion.
    _particleController = AnimationController(
      duration: _ambientDuration,
      vsync: this,
    )..repeat();

    // Progress controller for progress bar fill.
    _progressController = AnimationController(
      duration: _progressDuration,
      vsync: this,
    );

    // LOGO ANIMATIONS (0ms - 440ms )
    logoScale = Tween<double>(begin: 0.72, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.32, curve: Curves.easeOutCubic),
      ),
    );

    logoRotation = Tween<double>(begin: -0.045, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.32, curve: Curves.easeOutCubic),
      ),
    );

    // GLOW BURST (440ms )
    glowScale = Tween<double>(begin: 0.75, end: 2.05).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.18, 0.46, curve: Curves.easeOutCubic),
      ),
    );

    glowOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.18, 0.46, curve: Curves.easeOutQuad),
      ),
    );

    // SPARKLE BURST (460ms - 620ms )
    sparkleOffsets = List.generate(
      6,
      (i) =>
          Tween<Offset>(
            begin: Offset.zero,
            end: Offset(
              math.cos(i * math.pi / 3) * 64,
              math.sin(i * math.pi / 3) * 64,
            ),
          ).animate(
            CurvedAnimation(
              parent: _mainController,
              curve: const Interval(0.32, 0.54, curve: Curves.easeOutCubic),
            ),
          ),
    );

    sparkleOpacities = List.generate(
      6,
      (i) => Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
          parent: _mainController,
          curve: const Interval(0.32, 0.54, curve: Curves.easeOutQuad),
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
            0.1 + (i * 0.08),
            0.52 + (i * 0.08),
            curve: Curves.easeOutCubic,
          ),
        ),
      ),
    );

    ringOpacities = List.generate(
      3,
      (i) => Tween<double>(begin: 0.8, end: 0.0).animate(
        CurvedAnimation(
          parent: _mainController,
          curve: Interval(
            0.1 + (i * 0.08),
            0.52 + (i * 0.08),
            curve: Curves.easeOutQuad,
          ),
        ),
      ),
    );

    // LETTER ANIMATIONS (580ms - 865ms )
    final letterTimings = [0.36, 0.42, 0.48, 0.54];
    letterAnimations = letterTimings.map((timing) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _mainController,
          curve: Interval(timing, timing + 0.16, curve: Curves.easeOutCubic),
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
          curve: Interval(start, end, curve: Curves.easeOutCubic),
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

    _progressController.forward();
    progressValue = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  void _initializeParticles() {
    particles = List.generate(10, (index) {
      return ParticleData(
        x: _random.nextDouble() * 350 - 175, // -175 to 175
        y: _random.nextDouble() * 800, // Distribute across height
        velocity: 0.65 + _random.nextDouble() * 0.35,
        delay: Duration(
          milliseconds: _random.nextInt(_ambientDuration.inMilliseconds),
        ),
        opacity: 0.2 + _random.nextDouble() * 0.35,
        size: 3 + _random.nextDouble() * 3,
        drift: -16 + _random.nextDouble() * 32,
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
    final bottomInset = math.max(
      MediaQuery.paddingOf(context).bottom,
      MediaQuery.viewPaddingOf(context).bottom,
    );
    final progressBottomOffset = bottomInset + (size.height < 700 ? 32.0 : 20.0);

    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildDepthBackground(),

          // Background blobs with depth
          RepaintBoundary(child: _buildBackgroundBlobs()),

          // Floating particles
          RepaintBoundary(child: _buildFloatingParticles(size)),

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
          Positioned(
            bottom: progressBottomOffset,
            left: 0,
            right: 0,
            child: _buildProgressBar(size),
          ),
        ],
      ),
    );
  }

  Widget _buildDepthBackground() {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(-0.35, -0.45),
          radius: 1.2,
          colors: [
            AppColors.primaryLight,
            AppColors.primary,
            AppColors.primaryDark,
            AppColors.primaryExtraDark,
          ],
          stops: [0, 0.36, 0.72, 1],
        ),
      ),
    );
  }

  Widget _buildBackgroundBlobs() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Stack(
          children: [
            // Top-left blob
            Positioned(
              left: -70,
              top: -70,
              child: Transform.translate(
                offset: _blobOffset(0, 20),
                child: _buildBlob(220, 0.16),
              ),
            ),
            // Top-right blob
            Positioned(
              right: -60,
              top: -40,
              child: Transform.translate(
                offset: _blobOffset(1.5, 18),
                child: _buildBlob(200, 0.12),
              ),
            ),
            // Bottom-left blob
            Positioned(
              left: -50,
              bottom: -60,
              child: Transform.translate(
                offset: _blobOffset(3.1, 16),
                child: _buildBlob(210, 0.1),
              ),
            ),
            // Bottom-right blob
            Positioned(
              right: -60,
              bottom: -40,
              child: Transform.translate(
                offset: _blobOffset(4.4, 14),
                child: _buildBlob(190, 0.09),
              ),
            ),
          ],
        );
      },
    );
  }

  Offset _blobOffset(double phase, double radius) {
    final angle = (_particleController.value * math.pi * 2) + phase;
    return Offset(math.cos(angle) * radius, math.sin(angle) * radius);
  }

  Widget _buildBlob(double size, double opacity) {
    return Container(
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
        boxShadow: [
          BoxShadow(
            color: AppColors.splashBlobLight.withValues(alpha: opacity * 0.45),
            blurRadius: 48,
            spreadRadius: 12,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingParticles(Size size) {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Stack(
          children: particles.map((particle) {
            final progress =
                ((_particleController.value +
                    particle.delay.inMilliseconds /
                        _ambientDuration.inMilliseconds) %
                1.0);
            final easedProgress = Curves.easeInOutSine.transform(progress);
            final yOffset =
                -easedProgress * (size.height + 140) * particle.velocity;
            final xDrift = math.sin(progress * math.pi * 2) * particle.drift;
            final fadeIn = (progress / 0.18).clamp(0.0, 1.0);
            final fadeOut = ((1 - progress) / 0.22).clamp(0.0, 1.0);
            final opacity = particle.opacity * math.min(fadeIn, fadeOut);

            return Positioned(
              left: size.width / 2 + particle.x,
              top: size.height + particle.y * 0.15,
              child: Transform.translate(
                offset: Offset(xDrift, yOffset),
                child: Opacity(
                  opacity: opacity.clamp(0.0, 1.0),
                  child: Container(
                    width: particle.size,
                    height: particle.size,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.splashParticle,
                    ),
                  ),
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
      animation: Listenable.merge([
        logoScale,
        logoRotation,
        glowScale,
        glowOpacity,
        _mainController,
        _particleController,
      ]),
      builder: (context, child) {
        final ambientAngle = _particleController.value * math.pi * 2;
        final tiltX = math.sin(ambientAngle) * 0.045;
        final tiltY = math.cos(ambientAngle) * 0.055;
        final floatingLift = math.sin(ambientAngle) * 4;
        final liftProgress = ((floatingLift + 4) / 8).clamp(0.0, 1.0);
        final shadowOpacity = 0.12 + (liftProgress * 0.04);
        final shadowWidth = 92 + (liftProgress * 8);

        return Stack(
          alignment: Alignment.center,
          children: [
            Transform.translate(
              offset: Offset(0, 76 + floatingLift * 0.2),
              child: Opacity(
                opacity: logoScale.value.clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: logoScale.value,
                  child: Container(
                    width: shadowWidth,
                    height: 18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      gradient: RadialGradient(
                        colors: [
                          Colors.black.withValues(alpha: shadowOpacity),
                          Colors.black.withValues(alpha: shadowOpacity * 0.45),
                          Colors.black.withValues(alpha: 0),
                        ],
                        stops: const [0, 0.52, 1],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: shadowOpacity * 0.45,
                          ),
                          blurRadius: 18,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Glow burst effect
            Container(
              width: 120 * glowScale.value,
              height: 120 * glowScale.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.splashGlow.withValues(
                  alpha: glowOpacity.value * 0.6,
                ),
              ),
            ),

            // Main logo
            Transform.scale(
              scale: logoScale.value,
              child: Transform.translate(
                offset: Offset(0, floatingLift),
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0014)
                    ..rotateX(tiltX)
                    ..rotateY(tiltY)
                    ..rotateZ(logoRotation.value),
                  child: Container(
                    width: 124,
                    height: 124,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.textOnPrimary,
                          AppColors.textOnPrimary.withValues(alpha: 0.72),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.24),
                          offset: const Offset(0, 18),
                          blurRadius: 28,
                          spreadRadius: -10,
                        ),
                        BoxShadow(
                          color: AppColors.splashGlow.withValues(alpha: 0.28),
                          offset: const Offset(-10, -10),
                          blurRadius: 18,
                        ),
                      ],
                    ),
                    child: Center(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.textOnPrimary.withValues(
                              alpha: 0.45,
                            ),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              offset: const Offset(0, 8),
                              blurRadius: 14,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          clipBehavior: Clip.antiAlias,
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.asset(
                              'assets/logos/app_logo.png',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
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
              border: Border.all(
                color: AppColors.splashGlow.withValues(
                  alpha: (ringOpacities[i].value * 0.9).clamp(0.0, 1.0),
                ),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.splashGlow.withValues(
                    alpha: (ringOpacities[i].value * 0.25).clamp(0.0, 1.0),
                  ),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
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
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.splashGlow,
                ),
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
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textOnPrimary,
                    letterSpacing: 2,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.32),
                        offset: const Offset(0, 8),
                        blurRadius: 16,
                      ),
                      Shadow(
                        color: AppColors.splashGlow.withValues(alpha: 0.2),
                        offset: const Offset(-2, -2),
                        blurRadius: 8,
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
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textOnPrimary.withValues(alpha: 0.8),
                letterSpacing: 0.5,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureChips() {
    final features = [
      '💳 Smart Payments',
      '📊 Analytics',
      '👥 Customer CRM',
      '📦 Inventory',
    ];

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
              child: Transform.translate(
                offset: Offset(0, (1 - progress) * 12),
                child: Opacity(
                  opacity: progress.clamp(0.0, 1.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.textOnPrimary.withValues(alpha: 0.24),
                          AppColors.textOnPrimary.withValues(alpha: 0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.textOnPrimary.withValues(alpha: 0.28),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          offset: const Offset(0, 10),
                          blurRadius: 18,
                          spreadRadius: -8,
                        ),
                        BoxShadow(
                          color: AppColors.splashGlow.withValues(alpha: 0.1),
                          offset: const Offset(-2, -2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Text(
                      features[i],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textOnPrimary.withValues(alpha: 0.94),
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.22),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
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
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textOnPrimary.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressBar(Size size) {
    return AnimatedBuilder(
      animation: progressValue,
      builder: (context, child) {
        final pct = (progressValue.value * 100).clamp(0, 100).round();
        final fillWidth = (progressValue.value * size.width).clamp(
          0.0,
          size.width,
        );

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
                      child: Container(
                        width: fillWidth,
                        color: AppColors.textOnPrimary.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              // Percentage label (centered)
              Text(
                '$pct%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textOnPrimary.withValues(alpha: 0.85),
                ),
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
  final double size;
  final double drift;

  ParticleData({
    required this.x,
    required this.y,
    required this.velocity,
    required this.delay,
    required this.opacity,
    required this.size,
    required this.drift,
  });
}
