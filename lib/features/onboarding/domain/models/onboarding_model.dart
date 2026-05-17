import 'package:flutter/material.dart';

class OnboardingModel {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final Color iconInnerCircleColor;
  final Color iconOuterCircleColor;
  final Color screenBackgroundColor;
  final List<String> features;

  const OnboardingModel({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.iconInnerCircleColor,
    required this.iconOuterCircleColor,
    required this.screenBackgroundColor,
    required this.features,
  });
}
