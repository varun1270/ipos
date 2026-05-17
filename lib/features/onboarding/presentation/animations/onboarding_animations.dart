import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

extension OnboardingAnimations on Widget {
  Widget fadeSlide({Duration delay = Duration.zero}) {
    return animate(delay: delay)
        .fade(
          duration: 400.ms,
        )
        .slideY(
          begin: 0.2,
          end: 0,
          duration: 400.ms,
        );
  }

  Widget fadeSlideStaggered(
    int index, {
    int baseDelayMs = 200,
    int staggerMs = 80,
  }) {
    return fadeSlide(
      delay: Duration(milliseconds: baseDelayMs + index * staggerMs),
    );
  }
}