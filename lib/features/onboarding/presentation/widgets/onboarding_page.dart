import 'package:flutter/material.dart';

import '../../domain/models/onboarding_model.dart';
import '../animations/onboarding_animations.dart';
import 'feature_tile.dart';
import 'onboarding_icon.dart';

class OnboardingPage extends StatelessWidget {

  final OnboardingModel data;

  const OnboardingPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(24),

      child: Column(
        children: [

          const Spacer(),

          OnboardingIcon(
            icon: data.icon,
            iconColor: data.iconColor,
            innerColor: data.iconInnerCircleColor,
            outerColor: data.iconOuterCircleColor,
          ),

          const SizedBox(height: 50),

          Text(
            data.title,

            textAlign: TextAlign.center,

            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ).fadeSlide(),

          const SizedBox(height: 20),

          Text(
            data.description,

            textAlign: TextAlign.center,

            style: TextStyle(
              fontSize: 17,
              height: 1.6,
              color: Colors.grey.shade600,
            ),
          ).fadeSlide(),

          const SizedBox(height: 40),

          Column(
            children: data.features.map(
              (feature) {

                return FeatureTile(
                  text: feature,
                  color: data.iconInnerCircleColor,
                );
              },
            ).toList(),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}