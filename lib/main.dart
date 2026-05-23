import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/router_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/system_ui_overlay.dart';
import 'core/theme/theme_mode_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSystemUi.configure();
  await _enableHighRefreshRate();

  runApp(const ProviderScope(child: MainApp()));
}

Future<void> _enableHighRefreshRate() async {
  if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;

  try {
    await FlutterDisplayMode.setHighRefreshRate();
  } catch (_) {
    // High refresh mode is best-effort and depends on device/OS support.
  }
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final theme = ref.watch(themeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'IPOS',
      theme: theme.lightTheme,
      darkTheme: theme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: AppSystemUi.overlayFor(context),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
