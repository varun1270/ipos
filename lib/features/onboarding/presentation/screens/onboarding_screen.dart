import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/system_ui_overlay.dart';
import '../../../../core/utils/responsive_utils.dart';
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

  void _onPageChanged(int index) {
    setState(() => controller.updatePage(index));
  }

  void _onNext({required VoidCallback onFinished}) {
    controller.nextPage(
      totalPages: onboardingPages.length,
      onFinished: onFinished,
    );
    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = context.isWideScreen;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final isCompact = screenHeight < 700;
    final buttonLabel = controller.currentPage == onboardingPages.length - 1
        ? 'Get Started'
        : 'Next';

    return AnimatedBuilder(
      animation: controller.pageController,
      builder: (context, _) {
        final backgroundColor = _lerpPageColor(
          onboardingPages.map((p) => p.backgroundColor(context)).toList(),
        );
        final accentColor = _lerpPageColor(
          onboardingPages.map((p) => p.accentColor(context)).toList(),
        );

        return ThemedScreen(
          backgroundColor: backgroundColor,
          body: isWide
              ? _buildDesktopBody(
                  accentColor: accentColor,
                  buttonLabel: buttonLabel,
                )
              : _buildMobileBody(
                  accentColor: accentColor,
                  isCompact: isCompact,
                  buttonLabel: buttonLabel,
                ),
        );
      },
    );
  }

  Widget _buildMobileBody({
    required Color accentColor,
    required bool isCompact,
    required String buttonLabel,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: isCompact ? 14 : 24,
      ),
      child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OnboardingIndicator(
                  controller: controller.pageController,
                  count: onboardingPages.length,
                  activeColor: accentColor,
                ),
                TextButton(
                  onPressed: () => context.goNamed('login'),
                  
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
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: onboardingPages.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    data: onboardingPages[index],
                    pageNumber: index + 1,
                    pageCount: onboardingPages.length,
                    layout: OnboardingPageLayout.mobile,
                  );
                },
              ),
            ),
            OnboardingButton(
              text: buttonLabel,
              color: accentColor,
              onPressed: () => _onNext(
                onFinished: () => context.goNamed('login'),
              ),
            ),
            SizedBox(height: isCompact ? 10 : 20),
          ],
        ),
    );
  }

  Widget _buildDesktopBody({
    required Color accentColor,
    required String buttonLabel,
  }) {
    final screen = MediaQuery.sizeOf(context);
    final cardWidth = math.min(screen.width * 0.62, 720.0).clamp(520.0, 720.0);
    final cardHeight = math.min(screen.height * 0.78, 640.0).clamp(500.0, 640.0);
    const buttonMaxWidth = 320.0;

    final colors = context.appColors;
    final isDark = context.isDarkTheme;

    return Center(
      child: SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.elevatedSurface,
              borderRadius: BorderRadius.circular(24),
              border: isDark ? Border.all(color: colors.border) : null,
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 40,
                        offset: const Offset(0, 16),
                        spreadRadius: -4,
                      ),
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.15),
                        blurRadius: 48,
                        offset: const Offset(0, 20),
                        spreadRadius: -12,
                      ),
                    ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(36, 20, 36, 24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OnboardingIndicator(
                          controller: controller.pageController,
                          count: onboardingPages.length,
                          activeColor: accentColor,
                        ),
                        TextButton(
                          onPressed: () => context.goNamed('login'),
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              color: accentColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: PageView.builder(
                        controller: controller.pageController,
                        itemCount: onboardingPages.length,
                        onPageChanged: _onPageChanged,
                        itemBuilder: (context, index) {
                          return OnboardingPage(
                            data: onboardingPages[index],
                            pageNumber: index + 1,
                            pageCount: onboardingPages.length,
                            layout: OnboardingPageLayout.desktop,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: buttonMaxWidth,
                        ),
                        child: OnboardingButton(
                          text: buttonLabel,
                          color: accentColor,
                          onPressed: () => _onNext(
                            onFinished: () => context.goNamed('login'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}
