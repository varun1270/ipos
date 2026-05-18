import 'package:go_router/go_router.dart';

import '../presentation/animations/auth_animations.dart';
import '../presentation/screens/auth_shell_screen.dart';
import '../presentation/screens/otp_screen.dart';

final List<RouteBase> authRoutes = [
  GoRoute(
    path: '/login',
    name: 'login',
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: const AuthShellScreen(initialTab: 0),
      transitionDuration: const Duration(milliseconds: 360),
      reverseTransitionDuration: const Duration(milliseconds: 320),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return AuthAnimations.horizontalSlide(
          animation: animation,
          direction: -1,
          child: child,
        );
      },
    ),
  ),
  GoRoute(
    path: '/register',
    name: 'register',
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: const AuthShellScreen(initialTab: 1),
      transitionDuration: const Duration(milliseconds: 360),
      reverseTransitionDuration: const Duration(milliseconds: 320),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return AuthAnimations.horizontalSlide(
          animation: animation,
          direction: 1,
          child: child,
        );
      },
    ),
  ),
  GoRoute(
    path: '/otp',
    name: 'otp',
    pageBuilder: (context, state) {
      final phoneNumber = state.uri.queryParameters['phone'] ?? '';
      return NoTransitionPage(child: OtpScreen(phoneNumber: phoneNumber));
    },
  ),
];
