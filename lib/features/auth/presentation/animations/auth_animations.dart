import 'package:flutter/material.dart';

class AuthAnimations {
  AuthAnimations._();

  static Widget fadeSlide({required Widget child, int index = 0}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 420 + (index * 80)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 18 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  /// [direction] 1 = slide in from right, -1 = slide in from left.
  static Widget horizontalSlide({
    required Animation<double> animation,
    required Widget child,
    int direction = 1,
  }) {
    final slideAnimation = Tween<Offset>(
      begin: Offset(direction.toDouble(), 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

    final fadeAnimation = Tween<double>(begin: 0.85, end: 1).animate(
      CurvedAnimation(parent: animation, curve: Curves.easeOut),
    );

    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(position: slideAnimation, child: child),
    );
  }
}
