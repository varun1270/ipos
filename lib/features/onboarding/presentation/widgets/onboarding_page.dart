import 'package:flutter/material.dart';

import '../../domain/models/onboarding_model.dart';
import '../animations/onboarding_animations.dart';
import 'feature_tile.dart';
import 'onboarding_icon.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingModel data;
  final int pageNumber;
  final int pageCount;
  static const _titleTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    height: 1.1,
    color: Color(0xFF111827),
  );
  static const _descriptionTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: Color(0xFF6B7280),
  );
  static const _featureTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: Color(0xFF374151),
  );
  static const _pageIndicatorTextStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
  );

  const OnboardingPage({
    super.key,
    required this.data,
    required this.pageNumber,
    required this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),

      child: Column(
        children: [
          const Spacer(),

          OnboardingIcon(
            icon: data.icon,
            iconColor: data.iconColor,
            innerColor: data.iconInnerCircleColor,
            outerColor: data.iconOuterCircleColor,
            size: 220,
          ),

          const SizedBox(height: 10),

          Text(
            '$pageNumber of $pageCount',
            style: _pageIndicatorTextStyle.copyWith(
              color: data.iconInnerCircleColor,
            ),
          ).fadeSlide(),

          const SizedBox(height: 18),

          Text(
            data.title,

            textAlign: TextAlign.center,

            style: _titleTextStyle,
          ).fadeSlide(),

          const SizedBox(height: 14),

          Text(
            data.description,

            textAlign: TextAlign.center,

            style: _descriptionTextStyle,
          ).fadeSlide(),

          const SizedBox(height: 20),

          Column(
            children: data.features.asMap().entries.map((entry) {
              return FeatureTile(
                text: entry.value,
                color: data.iconInnerCircleColor,
                textStyle: _featureTextStyle,
              ).fadeSlideStaggered(entry.key);
            }).toList(),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}
