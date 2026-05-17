import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Animation utilities and extensions for IPOS app
class AnimationUtils {
  // Private constructor
  AnimationUtils._();

  /// Standard durations for animations
  static const Duration veryFast = Duration(milliseconds: 200);
  static const Duration fast = Duration(milliseconds: 300);
  static const Duration standard = Duration(milliseconds: 500);
  static const Duration medium = Duration(milliseconds: 700);
  static const Duration slow = Duration(milliseconds: 1000);
  static const Duration verySlow = Duration(milliseconds: 1500);

  /// Standard curves for animations
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;
  static const Curve elasticOut = Curves.elasticOut;
  static const Curve bounceOut = Curves.bounceOut;

  /// Create a spring curve for bouncy animations
  static Curve springCurve({double tension = 200.0}) {
    return Curves.elasticOut;
  }

  /// Delay for sequential animations
  static Duration getSequentialDelay(int index, {Duration delay = const Duration(milliseconds: 100)}) {
    return delay * index;
  }
}

/// Extension on AnimationController for common animations
extension AnimationControllerExtensions on AnimationController {
  /// Play animation with optional repeat
  Future<void> playOnce() async {
    await forward();
  }

  /// Play and reverse animation
  Future<void> playAndReverse() async {
    await forward();
    await reverse();
  }

  /// Repeat animation N times
  Future<void> repeatNTimes(int count) async {
    for (int i = 0; i < count; i++) {
      await forward();
      await reverse();
    }
  }

  /// Play and stay at the end
  Future<void> playToEnd() async {
    await forward();
  }
}

/// Extension on double for animation ranges
extension DoubleAnimationExtension on Animation<double> {
  /// Map animation value to a custom range
  double mapRange({required double start, required double end}) {
    return start + (value * (end - start));
  }

  /// Clamp animation value
  double clamp({required double min, required double max}) {
    return value.clamp(min, max);
  }
}

/// Tween extensions for common animations
extension TweenExtensions on Tween<double> {
  /// Create a pulsing animation (expand and shrink)
  Tween<double> pulse({required double from, required double to}) {
    return Tween<double>(begin: from, end: to);
  }

  /// Create a bounce animation
  Tween<double> bounce({required double from, required double to}) {
    return Tween<double>(begin: from, end: to);
  }
}

/// Staggered animation builder for sequential animations
class StaggeredAnimationBuilder extends StatefulWidget {
  final List<Animation<double>> animations;
  final Duration baseDelay;
  final Duration interval;
  final Duration duration;
  final Widget Function(BuildContext, List<Animation<double>>) builder;

  const StaggeredAnimationBuilder({
    super.key,
    required this.animations,
    required this.builder,
    this.baseDelay = const Duration(milliseconds: 100),
    this.interval = const Duration(milliseconds: 100),
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  State<StaggeredAnimationBuilder> createState() => _StaggeredAnimationBuilderState();
}

class _StaggeredAnimationBuilderState extends State<StaggeredAnimationBuilder> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Animation<double>> _animations = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    // Create staggered animations
    for (int i = 0; i < widget.animations.length; i++) {
      final start = (widget.baseDelay.inMilliseconds + i * widget.interval.inMilliseconds) / widget.duration.inMilliseconds;
      final end = math.min(start + 0.3, 1.0);
      _animations.add(
        Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(start, end, curve: Curves.easeOut),
          ),
        ),
      );
    }

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _animations);
}

/// Floating animation helper
class FloatingAnimationValues {
  final double xOffset;
  final double yOffset;
  final Duration duration;
  final Curve curve;

  const FloatingAnimationValues({required this.xOffset, required this.yOffset, this.duration = const Duration(milliseconds: 3000), this.curve = Curves.linear});
}

/// Particle animation model for splash screen
class ParticleModel {
  final double initialX;
  final double initialY;
  final double velocity;
  final Duration delay;
  final double opacity;

  ParticleModel({required this.initialX, required this.initialY, required this.velocity, required this.delay, required this.opacity});
}

/// Ring animation model for pulsing rings
class RingAnimationModel {
  final int index;
  final Duration startDelay;
  final Duration duration;
  final double maxScale;

  RingAnimationModel({required this.index, required this.startDelay, required this.duration, required this.maxScale});
}
