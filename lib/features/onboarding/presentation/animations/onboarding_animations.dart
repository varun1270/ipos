import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

extension OnboardingAnimations on Widget {

  Widget fadeSlide() {

    return animate()
        .fade(
          duration: 400.ms,
        )
        .slideY(
          begin: 0.2,
          end: 0,
          duration: 400.ms,
        );
  }
}