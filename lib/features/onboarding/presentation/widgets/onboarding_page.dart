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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxHeight < 560;
        final isVeryCompact = constraints.maxHeight < 500;
        final iconSize = isVeryCompact ? 142.0 : (isCompact ? 166.0 : 220.0);
        final titleStyle = _titleTextStyle.copyWith(
          fontSize: isVeryCompact ? 21 : (isCompact ? 22 : 24),
        );
        final descriptionStyle = _descriptionTextStyle.copyWith(
          fontSize: isVeryCompact ? 13.5 : (isCompact ? 14 : 16),
          height: isCompact ? 1.35 : 1.5,
        );
        final featureStyle = _featureTextStyle.copyWith(
          fontSize: isVeryCompact ? 13.5 : (isCompact ? 14 : 15),
        );
        final iconGap = isCompact ? 4.0 : 10.0;
        final titleGap = isCompact ? 10.0 : 18.0;
        final descriptionGap = isCompact ? 8.0 : 14.0;
        final featureGap = isCompact ? 12.0 : 20.0;

        return Padding(
          padding: EdgeInsets.only(
            top: isCompact ? 0 : 8,
            bottom: isCompact ? 0 : 8,
          ),

          child: Column(
            children: [
              Spacer(flex: isCompact ? 1 : 2),

              OnboardingIcon(
                icon: data.icon,
                iconColor: data.iconColor,
                innerColor: data.iconInnerCircleColor,
                outerColor: data.iconOuterCircleColor,
                size: iconSize,
              ),

              SizedBox(height: iconGap),

              Text(
                '$pageNumber of $pageCount',
                style: _pageIndicatorTextStyle.copyWith(
                  color: data.iconInnerCircleColor,
                  fontSize: isCompact ? 12 : 13,
                ),
              ).fadeSlide(),

              SizedBox(height: titleGap),

              Text(
                data.title,

                textAlign: TextAlign.center,

                style: titleStyle,
              ).fadeSlide(),

              SizedBox(height: descriptionGap),

              Text(
                data.description,

                textAlign: TextAlign.center,

                style: descriptionStyle,
              ).fadeSlide(),

              SizedBox(height: featureGap),

              Column(
                children: data.features.asMap().entries.map((entry) {
                  return FeatureTile(
                    text: entry.value,
                    color: data.iconInnerCircleColor,
                    textStyle: featureStyle,
                    bottomPadding: isCompact ? 7 : 10,
                  ).fadeSlideStaggered(entry.key);
                }).toList(),
              ),

              Spacer(flex: isCompact ? 3 : 2),
            ],
          ),
        );
      },
    );
  }
}
