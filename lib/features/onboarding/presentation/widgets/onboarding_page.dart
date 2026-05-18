import 'package:flutter/material.dart';

import '../../domain/models/onboarding_model.dart';
import '../animations/onboarding_animations.dart';
import 'feature_tile.dart';
import 'onboarding_feature_grid.dart';
import 'onboarding_icon.dart';

enum OnboardingPageLayout { mobile, desktop }

class OnboardingPage extends StatelessWidget {
  final OnboardingModel data;
  final int pageNumber;
  final int pageCount;
  final OnboardingPageLayout layout;

  const OnboardingPage({
    super.key,
    required this.data,
    required this.pageNumber,
    required this.pageCount,
    this.layout = OnboardingPageLayout.mobile,
  });

  @override
  Widget build(BuildContext context) {
    return layout == OnboardingPageLayout.desktop
        ? _DesktopPageContent(
            data: data,
            pageNumber: pageNumber,
            pageCount: pageCount,
          )
        : _MobilePageContent(
            data: data,
            pageNumber: pageNumber,
            pageCount: pageCount,
          );
  }
}

class _DesktopPageContent extends StatelessWidget {
  final OnboardingModel data;
  final int pageNumber;
  final int pageCount;

  const _DesktopPageContent({
    required this.data,
    required this.pageNumber,
    required this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxH = constraints.maxHeight;
        final maxW = constraints.maxWidth;
        final iconSize = (maxH * 0.52).clamp(240.0, 340.0);
        final copyWidth = (maxW * 0.9).clamp(480.0, 640.0);

        return Column(
          children: [
            Expanded(
              flex: 11,
              child: Center(
                child: _IconStage(data: data, size: iconSize),
              ),
            ),
            const SizedBox(height: 28),
            Expanded(
              flex: 12,
              child: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: copyWidth),
                    child: Column(
                      children: [
                        _PageBadge(
                          label: '$pageNumber of $pageCount',
                          color: data.iconInnerCircleColor,
                        ).fadeSlide(),
                        const SizedBox(height: 14),
                        Text(
                          data.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                            color: Color(0xFF111827),
                            letterSpacing: -0.3,
                          ),
                        ).fadeSlide(),
                        const SizedBox(height: 8),
                        Text(
                          data.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            height: 1.45,
                            color: Color(0xFF6B7280),
                          ),
                        ).fadeSlide(),
                        const SizedBox(height: 18),
                        OnboardingFeatureGrid(
                          features: data.features,
                          accentColor: data.iconInnerCircleColor,
                          textStyle: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF374151),
                            height: 1.35,
                          ),
                          twoColumns: copyWidth >= 460,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MobilePageContent extends StatelessWidget {
  final OnboardingModel data;
  final int pageNumber;
  final int pageCount;

  const _MobilePageContent({
    required this.data,
    required this.pageNumber,
    required this.pageCount,
  });

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

        return Padding(
          padding: EdgeInsets.only(
            top: isCompact ? 0 : 8,
            bottom: isCompact ? 0 : 8,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OnboardingIcon(
                icon: data.icon,
                iconColor: data.iconColor,
                innerColor: data.iconInnerCircleColor,
                outerColor: data.iconOuterCircleColor,
                size: iconSize,
              ),
              SizedBox(height: isCompact ? 4 : 10),
              Text(
                '$pageNumber of $pageCount',
                style: TextStyle(
                  fontSize: isCompact ? 12 : 13,
                  fontWeight: FontWeight.w700,
                  color: data.iconInnerCircleColor,
                ),
              ).fadeSlide(),
              SizedBox(height: isCompact ? 10 : 18),
              Text(
                data.title,
                textAlign: TextAlign.center,
                style: titleStyle,
              ).fadeSlide(),
              SizedBox(height: isCompact ? 8 : 14),
              Text(
                data.description,
                textAlign: TextAlign.center,
                style: descriptionStyle,
              ).fadeSlide(),
              SizedBox(height: isCompact ? 12 : 20),
              ...data.features.asMap().entries.map((entry) {
                return FeatureTile(
                  text: entry.value,
                  color: data.iconInnerCircleColor,
                  textStyle: featureStyle,
                  bottomPadding: isCompact ? 7 : 10,
                ).fadeSlideStaggered(entry.key);
              }),
            ],
          ),
        );
      },
    );
  }
}

class _PageBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _PageBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _IconStage extends StatelessWidget {
  final OnboardingModel data;
  final double size;

  const _IconStage({required this.data, required this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: SizedBox(
        width: size,
        height: size,
        child: OnboardingIcon(
          icon: data.icon,
          iconColor: data.iconColor,
          innerColor: data.iconInnerCircleColor,
          outerColor: data.iconOuterCircleColor,
          size: size,
        ),
      ),
    );
  }
}
