import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/router_provider.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'IPOS',
      theme: theme.lightTheme,
      routerConfig: router,
    );
  }
}
