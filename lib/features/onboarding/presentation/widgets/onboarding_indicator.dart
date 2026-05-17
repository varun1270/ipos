import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingIndicator extends StatelessWidget {

  final PageController controller;
  final int count;
  final Color activeColor;

  const OnboardingIndicator({
    super.key,
    required this.controller,
    required this.count,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {

    return SmoothPageIndicator(

      controller: controller,

      count: count,

      effect: ExpandingDotsEffect(
        activeDotColor: activeColor,

        dotColor: Colors.grey.shade300,

        dotHeight: 8,
        dotWidth: 8,

        expansionFactor: 3,
      ),
    );
  }
}