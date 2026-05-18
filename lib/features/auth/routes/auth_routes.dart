import 'package:go_router/go_router.dart';

import '../presentation/screens/login_screen.dart';
import '../presentation/screens/otp_screen.dart';
import '../presentation/screens/register_screen.dart';

final List<RouteBase> authRoutes = [
  GoRoute(
    path: '/login',
    name: 'login',
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: LoginScreen()),
  ),
  GoRoute(
    path: '/register',
    name: 'register',
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: RegisterScreen()),
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
