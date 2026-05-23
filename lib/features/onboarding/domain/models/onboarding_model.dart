import 'package:flutter/material.dart';

class OnboardingModel {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final Color iconInnerCircleColor;
  final Color iconOuterCircleColor;
  final Color screenBackgroundColor;
  final Color iconInnerCircleColorDark;
  final Color iconOuterCircleColorDark;
  final Color screenBackgroundColorDark;
  final List<String> features;

  const OnboardingModel({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.iconInnerCircleColor,
    required this.iconOuterCircleColor,
    required this.screenBackgroundColor,
    required this.iconInnerCircleColorDark,
    required this.iconOuterCircleColorDark,
    required this.screenBackgroundColorDark,
    required this.features,
  });

  Color backgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? screenBackgroundColorDark
        : screenBackgroundColor;
  }

  Color accentColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? iconInnerCircleColorDark
        : iconInnerCircleColor;
  }

  Color outerCircleColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? iconOuterCircleColorDark
        : iconOuterCircleColor;
  }
}
