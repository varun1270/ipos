import 'package:flutter/material.dart';

import '../animations/onboarding_animations.dart';
import 'feature_tile.dart';

/// Two-column feature list for tablet and desktop onboarding.
class OnboardingFeatureGrid extends StatelessWidget {
  final List<String> features;
  final Color accentColor;
  final TextStyle textStyle;
  final bool twoColumns;

  const OnboardingFeatureGrid({
    super.key,
    required this.features,
    required this.accentColor,
    required this.textStyle,
    this.twoColumns = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!twoColumns || features.length <= 2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: features.asMap().entries.map((entry) {
          return FeatureTile(
            text: entry.value,
            color: accentColor,
            textStyle: textStyle,
            bottomPadding: 10,
          ).fadeSlideStaggered(entry.key);
        }).toList(),
      );
    }

    final mid = (features.length / 2).ceil();
    final left = features.sublist(0, mid);
    final right = features.sublist(mid);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: left.asMap().entries.map((entry) {
              return FeatureTile(
                text: entry.value,
                color: accentColor,
                textStyle: textStyle,
                bottomPadding: 12,
              ).fadeSlideStaggered(entry.key);
            }).toList(),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: right.asMap().entries.map((entry) {
              return FeatureTile(
                text: entry.value,
                color: accentColor,
                textStyle: textStyle,
                bottomPadding: 12,
              ).fadeSlideStaggered(mid + entry.key);
            }).toList(),
          ),
        ),
      ],
    );
  }
}
