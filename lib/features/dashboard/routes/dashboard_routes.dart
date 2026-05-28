import 'package:go_router/go_router.dart';
import 'package:ipos/features/dashboard/presentation/animations/dashboard_animations.dart';
import 'package:ipos/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:ipos/features/notifications/presentation/screens/notification_screen.dart';

final List<RouteBase> dashboardRoutes = [
  GoRoute(
    path: '/dashboard',
    name: 'dashboard',
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: const DashboardScreen(),
      transitionDuration: const Duration(milliseconds: 360),
      reverseTransitionDuration: const Duration(milliseconds: 320),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return DashboardAnimations.horizontalSlide(animation: animation, direction: -1, child: child);
      },
    ),
  ),
  GoRoute(
    path: '/notifications',
    name: 'notifications',
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: const NotificationScreen(),
      transitionDuration: const Duration(milliseconds: 360),
      reverseTransitionDuration: const Duration(milliseconds: 320),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return DashboardAnimations.horizontalSlide(animation: animation, direction: -1, child: child);
      },
    ),
  ),
  GoRoute(
    path: '/profile',
    name: 'profile',
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: const NotificationScreen(),
      transitionDuration: const Duration(milliseconds: 360),
      reverseTransitionDuration: const Duration(milliseconds: 320),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return DashboardAnimations.horizontalSlide(animation: animation, direction: -1, child: child);
      },
    ),
  ),
];
