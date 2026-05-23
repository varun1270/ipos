import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

/// Status bar + navigation bar styling for iOS and Android.
abstract final class AppSystemUi {
  static SystemUiOverlayStyle overlayFor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = AppColors.of(context).background;

    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      // iOS: light status-bar content on dark backgrounds.
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: isDark ? Colors.black : background,
      systemNavigationBarIconBrightness:
          isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarContrastEnforced: false,
    );
  }

  static Future<void> configure() async {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }
}

/// Full-screen scaffold with system bar styling and safe-area insets.
class ThemedScreen extends StatelessWidget {
  final Widget body;
  final Color? backgroundColor;

  /// When true (default), wraps [body] in [SafeArea] so content clears the
  /// status bar and home indicator. Set false only if [body] uses [AppSafeScroll]
  /// or its own [SliverSafeArea].
  final bool applySafeArea;

  const ThemedScreen({
    super.key,
    required this.body,
    this.backgroundColor,
    this.applySafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.of(context).background;

    final screenBody = applySafeArea
        ? SafeArea(
            minimum: EdgeInsets.zero,
            child: SizedBox.expand(child: body),
          )
        : SizedBox.expand(child: body);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.overlayFor(context),
      child: ColoredBox(
        color: bg,
        child: Scaffold(
          backgroundColor: bg,
          resizeToAvoidBottomInset: true,
          body: screenBody,
        ),
      ),
    );
  }
}
