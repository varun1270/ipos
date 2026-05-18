import 'package:flutter/material.dart';

import '../utils/responsive_utils.dart';

/// Centers content and caps width on tablets and desktops.
class AdaptiveContent extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;

  const AdaptiveContent({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedMaxWidth = maxWidth ??
        context.responsiveValue<double>(
          compact: double.infinity,
          medium: 720,
          expanded: 1080,
        );

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: resolvedMaxWidth),
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
      ),
    );
  }
}
