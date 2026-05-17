import 'package:flutter/material.dart';
import '../domain/models/onboarding_model.dart';

const onboardingPages = [
  OnboardingModel(
    title: 'Lightning Fast Billing',
    description: 'Process sales in seconds. Scan products, apply GST automatically, and accept cash, UPI or card - all from one elegant screen.',
    icon: Icons.bolt_rounded,
    iconColor: Color(0xFFFFFFFF),
    iconInnerCircleColor: Color(0xFF4F46E5),
    iconOuterCircleColor: Color(0x184F46E5),
    screenBackgroundColor: Color.fromARGB(255, 205, 217, 255),
    features: [
      "Quick product search & scan",
      "GST auto-calculation",
      "Hold & resume orders",
      "Split payments",
    ],
  ),
  OnboardingModel(
    title: 'Smart Business Insights',
    description: 'Know exactly how your business is performing. Track revenue, profit, and inventory trends with clear visual reports.',
    icon: Icons.bar_chart_rounded,
    iconColor: Color(0xFFFFFFFF),
    iconInnerCircleColor: Color(0xFF7C3AED),
    iconOuterCircleColor: Color(0x187C3AED),
    screenBackgroundColor: Color.fromARGB(255, 213, 206, 255),
    features: [
      "Daily/weekly/monthly reports",
      "Category-wise breakdown",
      "Top & least selling products",
      "Expense tracking",
    ],
  ),
  OnboardingModel(
    title: 'Grow Customer Loyalty',
    description: 'Manage credit (Udhaar), track every order, and reward your best customers with points and referral bonuses.',
    icon: Icons.groups_rounded,
    iconColor: Color(0xFFFFFFFF),
    iconInnerCircleColor: Color(0xFF10B981),
    iconOuterCircleColor: Color(0x1810B981),
    screenBackgroundColor: Color.fromARGB(255, 204, 255, 231),
    features: [
      "Credit / Udhaar ledger",
      "Customer purchase history",
      "Loyalty points & tiers",
      "Referral rewards",
    ],
  ),
];
