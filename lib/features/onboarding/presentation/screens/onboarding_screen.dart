import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/onboarding_data.dart';
import '../controllers/onboarding_controller.dart';
import '../widgets/onboarding_button.dart';
import '../widgets/onboarding_indicator.dart';
import '../widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final OnboardingController controller = OnboardingController();

  double get _pagePosition {
    if (!controller.pageController.hasClients) {
      return controller.currentPage.toDouble();
    }

    return controller.pageController.page ?? controller.currentPage.toDouble();
  }

  Color _lerpPageColor(List<Color> colors) {
    final page = _pagePosition.clamp(0, colors.length - 1).toDouble();
    final startIndex = page.floor();
    final endIndex = page.ceil();
    final progress = page - startIndex;

    return Color.lerp(colors[startIndex], colors[endIndex], progress)!;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.pageController,
      builder: (context, _) {
        final backgroundColor = _lerpPageColor(
          onboardingPages.map((page) => page.screenBackgroundColor).toList(),
        );
        final accentColor = _lerpPageColor(
          onboardingPages.map((page) => page.iconInnerCircleColor).toList(),
        );

        return ColoredBox(
          color: backgroundColor,

          child: Scaffold(
            backgroundColor: Colors.transparent,

            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),

                child: Column(
                  children: [
                    /// TOP SECTION
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        OnboardingIndicator(
                          controller: controller.pageController,

                          count: onboardingPages.length,

                          activeColor: accentColor,
                        ),

                        TextButton(
                          onPressed: () {
                            context.goNamed('login');
                          },

                          child: Text(
                            'Skip',

                            style: TextStyle(
                              color: accentColor,

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// PAGE VIEW
                    Expanded(
                      child: PageView.builder(
                        controller: controller.pageController,

                        itemCount: onboardingPages.length,

                        onPageChanged: (index) {
                          setState(() {
                            controller.updatePage(index);
                          });
                        },

                        itemBuilder: (context, index) {
                          return OnboardingPage(
                            data: onboardingPages[index],
                            pageNumber: index + 1,
                            pageCount: onboardingPages.length,
                          );
                        },
                      ),
                    ),

                    /// BUTTON
                    OnboardingButton(
                      text: controller.currentPage == onboardingPages.length - 1
                          ? 'Get Started'
                          : 'Next',

                      color: accentColor,

                      onPressed: () {
                        controller.nextPage(
                          totalPages: onboardingPages.length,

                          onFinished: () {
                            context.goNamed('login');
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
