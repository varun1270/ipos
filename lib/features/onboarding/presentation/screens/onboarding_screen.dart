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
  State<OnboardingScreen> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState
    extends State<OnboardingScreen> {

  final OnboardingController controller =
      OnboardingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final currentData =
        onboardingPages[controller.currentPage];

    return AnimatedContainer(

      duration: const Duration(milliseconds: 500),

      color: currentData.screenBackgroundColor,

      child: Scaffold(

        backgroundColor: Colors.transparent,

        body: SafeArea(

          child: Padding(
            padding: const EdgeInsets.all(24),

            child: Column(
              children: [

                /// TOP SECTION

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                  children: [

                    OnboardingIndicator(
                      controller:
                          controller.pageController,

                      count:
                          onboardingPages.length,

                      activeColor:
                          currentData
                              .iconInnerCircleColor,
                    ),

                    TextButton(

                      onPressed: () {

                        context.goNamed('login');
                      },

                      child: Text(
                        'Skip',

                        style: TextStyle(
                          color:
                              currentData
                                  .iconInnerCircleColor,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                /// PAGE VIEW

                Expanded(

                  child: PageView.builder(

                    controller:
                        controller.pageController,

                    itemCount:
                        onboardingPages.length,

                    onPageChanged: (index) {

                      setState(() {

                        controller.updatePage(index);
                      });
                    },

                    itemBuilder: (context, index) {

                      return OnboardingPage(
                        data: onboardingPages[index],
                      );
                    },
                  ),
                ),

                /// BUTTON

                OnboardingButton(

                  text:
                      controller.currentPage ==
                              onboardingPages.length - 1
                          ? 'Get Started'
                          : 'Next',

                  color:
                      currentData.iconInnerCircleColor,

                  onPressed: () {

                    controller.nextPage(

                      totalPages:
                          onboardingPages.length,

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
  }
}