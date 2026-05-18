import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Semantic type of the snackbar. Controls accent color and default icon.
///
/// Use [AppSnackbarType.auto] to auto-detect the type from the message text
/// (e.g. "failed", "error" -> error; "success", "completed" -> success).
enum AppSnackbarType { success, error, warning, info, auto }

/// Vertical position of the snackbar on screen.
enum AppSnackbarPosition { top, bottom }

/// Entrance/exit animation styles.
enum AppSnackbarAnimation {
  slideVertical,
  slideHorizontal,
  fade,
  scale,
  bounce,
  flip3D,
  rotateIn,
}

/// Global, themed, 3D-styled snackbar usable from any screen.
///
/// Example:
/// ```dart
/// AppSnackbar.success(context, 'Login successful');
/// AppSnackbar.error(context, 'Invalid OTP');
/// AppSnackbar.show(
///   context,
///   message: 'Saved!',
///   type: AppSnackbarType.success,
///   incoming: AppSnackbarAnimation.flip3D,
///   outgoing: AppSnackbarAnimation.fade,
///   position: AppSnackbarPosition.top,
/// );
/// ```
class AppSnackbar {
  AppSnackbar._();

  /// Currently visible entry, used to dismiss before showing a new one.
  static _AppSnackbarController? _current;

  /// Show a snackbar with full control over type, animations, and position.
  ///
  /// [message] is required. All other parameters have sensible defaults.
  static void show(
    BuildContext context, {
    required String message,
    String? title,
    AppSnackbarType type = AppSnackbarType.auto,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
    AppSnackbarAnimation incoming = AppSnackbarAnimation.slideVertical,
    AppSnackbarAnimation outgoing = AppSnackbarAnimation.fade,
    AppSnackbarPosition position = AppSnackbarPosition.bottom,
    String? actionLabel,
    VoidCallback? onAction,
    bool dismissible = true,
  }) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;

    _current?.dismiss(animate: false);

    final resolvedType = type == AppSnackbarType.auto
        ? _detectType(message, title)
        : type;

    final controller = _AppSnackbarController(
      overlay: overlay,
      message: message,
      title: title,
      type: resolvedType,
      icon: icon ?? _iconFor(resolvedType, message),
      duration: duration,
      incoming: incoming,
      outgoing: outgoing,
      position: position,
      actionLabel: actionLabel,
      onAction: onAction,
      dismissible: dismissible,
    );

    _current = controller;
    controller.show();
  }

  /// Success shortcut. Uses [AppSnackbarType.success] styling.
  static void success(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    AppSnackbarAnimation incoming = AppSnackbarAnimation.bounce,
    AppSnackbarAnimation outgoing = AppSnackbarAnimation.fade,
    AppSnackbarPosition position = AppSnackbarPosition.bottom,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      context,
      message: message,
      title: title,
      type: AppSnackbarType.success,
      duration: duration,
      incoming: incoming,
      outgoing: outgoing,
      position: position,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Error shortcut. Uses [AppSnackbarType.error] styling.
  static void error(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 4),
    AppSnackbarAnimation incoming = AppSnackbarAnimation.slideHorizontal,
    AppSnackbarAnimation outgoing = AppSnackbarAnimation.slideHorizontal,
    AppSnackbarPosition position = AppSnackbarPosition.bottom,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      context,
      message: message,
      title: title,
      type: AppSnackbarType.error,
      duration: duration,
      incoming: incoming,
      outgoing: outgoing,
      position: position,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Warning shortcut. Uses [AppSnackbarType.warning] styling.
  static void warning(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    AppSnackbarAnimation incoming = AppSnackbarAnimation.scale,
    AppSnackbarAnimation outgoing = AppSnackbarAnimation.fade,
    AppSnackbarPosition position = AppSnackbarPosition.bottom,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      context,
      message: message,
      title: title,
      type: AppSnackbarType.warning,
      duration: duration,
      incoming: incoming,
      outgoing: outgoing,
      position: position,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Info shortcut. Uses [AppSnackbarType.info] styling.
  static void info(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    AppSnackbarAnimation incoming = AppSnackbarAnimation.fade,
    AppSnackbarAnimation outgoing = AppSnackbarAnimation.fade,
    AppSnackbarPosition position = AppSnackbarPosition.bottom,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      context,
      message: message,
      title: title,
      type: AppSnackbarType.info,
      duration: duration,
      incoming: incoming,
      outgoing: outgoing,
      position: position,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Dismiss the currently visible snackbar, if any.
  static void dismiss() => _current?.dismiss();

  // ---------------------------------------------------------------------------
  // Internal helpers
  // ---------------------------------------------------------------------------

  static AppSnackbarType _detectType(String message, String? title) {
    final haystack = '${title ?? ''} $message'.toLowerCase();
    const errorWords = [
      'error',
      'failed',
      'failure',
      'invalid',
      'denied',
      'unauthorized',
      'wrong',
      'exception',
      'unable',
    ];
    const successWords = [
      'success',
      'successful',
      'completed',
      'verified',
      'saved',
      'created',
      'sent',
      'updated',
      'welcome',
    ];
    const warningWords = ['warning', 'caution', 'careful', 'attention'];

    if (errorWords.any(haystack.contains)) return AppSnackbarType.error;
    if (successWords.any(haystack.contains)) return AppSnackbarType.success;
    if (warningWords.any(haystack.contains)) return AppSnackbarType.warning;
    return AppSnackbarType.info;
  }

  static IconData _iconFor(AppSnackbarType type, String message) {
    final lower = message.toLowerCase();
    if (lower.contains('otp') || lower.contains('verify')) {
      return Icons.verified_user_rounded;
    }
    if (lower.contains('login') || lower.contains('welcome')) {
      return Icons.login_rounded;
    }
    if (lower.contains('password')) return Icons.lock_rounded;
    if (lower.contains('email')) return Icons.email_rounded;
    if (lower.contains('phone')) return Icons.phone_rounded;
    if (lower.contains('network') || lower.contains('connection')) {
      return Icons.wifi_off_rounded;
    }

    return switch (type) {
      AppSnackbarType.success => Icons.check_circle_rounded,
      AppSnackbarType.error => Icons.error_rounded,
      AppSnackbarType.warning => Icons.warning_amber_rounded,
      AppSnackbarType.info => Icons.info_rounded,
      AppSnackbarType.auto => Icons.notifications_rounded,
    };
  }
}

/// Resolves the accent palette for a given semantic [AppSnackbarType].
class _SnackbarPalette {
  final Color accent;
  final Color accentDark;
  final Color soft;

  const _SnackbarPalette({
    required this.accent,
    required this.accentDark,
    required this.soft,
  });

  factory _SnackbarPalette.of(AppSnackbarType type) {
    switch (type) {
      case AppSnackbarType.success:
        return const _SnackbarPalette(
          accent: AppColors.success,
          accentDark: Color(0xFF047857),
          soft: AppColors.successSoft,
        );
      case AppSnackbarType.error:
        return const _SnackbarPalette(
          accent: AppColors.error,
          accentDark: Color(0xFFB91C1C),
          soft: Color(0xFFFEE2E2),
        );
      case AppSnackbarType.warning:
        return const _SnackbarPalette(
          accent: AppColors.warning,
          accentDark: Color(0xFFB45309),
          soft: Color(0xFFFEF3C7),
        );
      case AppSnackbarType.info:
      case AppSnackbarType.auto:
        return const _SnackbarPalette(
          accent: AppColors.primary,
          accentDark: AppColors.primaryDark,
          soft: AppColors.primaryVeryLight,
        );
    }
  }
}

/// Manages the lifecycle (insert, animate, auto-dismiss) of a single snackbar.
class _AppSnackbarController {
  final OverlayState overlay;
  final String message;
  final String? title;
  final AppSnackbarType type;
  final IconData icon;
  final Duration duration;
  final AppSnackbarAnimation incoming;
  final AppSnackbarAnimation outgoing;
  final AppSnackbarPosition position;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool dismissible;

  OverlayEntry? _entry;
  final GlobalKey<_AppSnackbarWidgetState> _key =
      GlobalKey<_AppSnackbarWidgetState>();
  Timer? _autoDismiss;
  bool _disposed = false;

  _AppSnackbarController({
    required this.overlay,
    required this.message,
    required this.title,
    required this.type,
    required this.icon,
    required this.duration,
    required this.incoming,
    required this.outgoing,
    required this.position,
    required this.actionLabel,
    required this.onAction,
    required this.dismissible,
  });

  void show() {
    _entry = OverlayEntry(
      builder: (context) => _AppSnackbarWidget(
        key: _key,
        message: message,
        title: title,
        type: type,
        icon: icon,
        duration: duration,
        incoming: incoming,
        outgoing: outgoing,
        position: position,
        actionLabel: actionLabel,
        onAction: () {
          onAction?.call();
          dismiss();
        },
        dismissible: dismissible,
        onDismissed: _cleanup,
      ),
    );
    overlay.insert(_entry!);

    _autoDismiss = Timer(duration, dismiss);
  }

  void dismiss({bool animate = true}) {
    if (_disposed) return;
    _autoDismiss?.cancel();
    final state = _key.currentState;
    if (animate && state != null) {
      state.playOut().then((_) => _cleanup());
    } else {
      _cleanup();
    }
  }

  void _cleanup() {
    if (_disposed) return;
    _disposed = true;
    _autoDismiss?.cancel();
    _entry?.remove();
    _entry = null;
    if (AppSnackbar._current == this) {
      AppSnackbar._current = null;
    }
  }
}

/// The rendered snackbar surface with 3D styling and configurable transitions.
class _AppSnackbarWidget extends StatefulWidget {
  final String message;
  final String? title;
  final AppSnackbarType type;
  final IconData icon;
  final Duration duration;
  final AppSnackbarAnimation incoming;
  final AppSnackbarAnimation outgoing;
  final AppSnackbarPosition position;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool dismissible;
  final VoidCallback onDismissed;

  const _AppSnackbarWidget({
    super.key,
    required this.message,
    required this.title,
    required this.type,
    required this.icon,
    required this.duration,
    required this.incoming,
    required this.outgoing,
    required this.position,
    required this.actionLabel,
    required this.onAction,
    required this.dismissible,
    required this.onDismissed,
  });

  @override
  State<_AppSnackbarWidget> createState() => _AppSnackbarWidgetState();
}

class _AppSnackbarWidgetState extends State<_AppSnackbarWidget>
    with TickerProviderStateMixin {
  late final AnimationController _inController;
  late final AnimationController _outController;
  late final AnimationController _progressController;
  bool _isExiting = false;

  @override
  void initState() {
    super.initState();
    _inController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _outController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _progressController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _inController.forward();
    _progressController.forward();
  }

  @override
  void dispose() {
    _inController.dispose();
    _outController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  /// Public hook used by the controller to play the exit animation.
  Future<void> playOut() async {
    if (!mounted || _isExiting) return;
    setState(() => _isExiting = true);
    _progressController.stop();
    await _outController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final isTop = widget.position == AppSnackbarPosition.top;
    final padding = EdgeInsets.fromLTRB(
      16,
      isTop ? mq.padding.top + 12 : 0,
      16,
      isTop ? 0 : mq.padding.bottom + 16,
    );

    return Positioned(
      left: 0,
      right: 0,
      top: isTop ? 0 : null,
      bottom: isTop ? null : 0,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: padding,
          child: Align(
            alignment:
                isTop ? Alignment.topCenter : Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: _buildAnimated(
                child: _buildCard(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimated({required Widget child}) {
    final inAnim = CurvedAnimation(
      parent: _inController,
      curve: _curveFor(widget.incoming, isIn: true),
    );
    final outAnim = CurvedAnimation(
      parent: _outController,
      curve: _curveFor(widget.outgoing, isIn: false),
    );

    return AnimatedBuilder(
      animation: Listenable.merge([inAnim, outAnim]),
      builder: (context, _) {
        final inValue = inAnim.value;
        final outValue = 1 - outAnim.value;
        final activeAnim = _isExiting ? widget.outgoing : widget.incoming;
        final progress = _isExiting ? outValue : inValue;
        return _applyAnimation(
          animation: activeAnim,
          progress: progress,
          isExiting: _isExiting,
          child: child,
        );
      },
    );
  }

  Curve _curveFor(AppSnackbarAnimation animation, {required bool isIn}) {
    switch (animation) {
      case AppSnackbarAnimation.bounce:
        return isIn ? Curves.elasticOut : Curves.easeInBack;
      case AppSnackbarAnimation.scale:
        return isIn ? Curves.easeOutBack : Curves.easeInCubic;
      case AppSnackbarAnimation.flip3D:
      case AppSnackbarAnimation.rotateIn:
        return isIn ? Curves.easeOutCubic : Curves.easeInCubic;
      case AppSnackbarAnimation.slideVertical:
      case AppSnackbarAnimation.slideHorizontal:
        return isIn ? Curves.easeOutCubic : Curves.easeInCubic;
      case AppSnackbarAnimation.fade:
        return isIn ? Curves.easeOut : Curves.easeIn;
    }
  }

  Widget _applyAnimation({
    required AppSnackbarAnimation animation,
    required double progress,
    required bool isExiting,
    required Widget child,
  }) {
    final isTop = widget.position == AppSnackbarPosition.top;
    final opacity = progress.clamp(0.0, 1.0);

    switch (animation) {
      case AppSnackbarAnimation.fade:
        return Opacity(opacity: opacity, child: child);

      case AppSnackbarAnimation.scale:
        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: 0.7 + 0.3 * progress,
            child: child,
          ),
        );

      case AppSnackbarAnimation.bounce:
        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, (isTop ? -1 : 1) * (1 - progress) * 80),
            child: Transform.scale(
              scale: 0.85 + 0.15 * progress,
              child: child,
            ),
          ),
        );

      case AppSnackbarAnimation.slideHorizontal:
        final dir = isExiting ? 1.0 : -1.0;
        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(dir * (1 - progress) * 320, 0),
            child: child,
          ),
        );

      case AppSnackbarAnimation.slideVertical:
        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, (isTop ? -1 : 1) * (1 - progress) * 120),
            child: child,
          ),
        );

      case AppSnackbarAnimation.flip3D:
        final angle = (1 - progress) * (isTop ? -1 : 1) * 1.2;
        return Opacity(
          opacity: opacity,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0015)
              ..rotateX(angle),
            child: child,
          ),
        );

      case AppSnackbarAnimation.rotateIn:
        final angle = (1 - progress) * 0.35 * (isExiting ? -1 : 1);
        return Opacity(
          opacity: opacity,
          child: Transform.rotate(
            angle: angle,
            child: Transform.scale(
              scale: 0.85 + 0.15 * progress,
              child: child,
            ),
          ),
        );
    }
  }

  Widget _buildCard(BuildContext context) {
    final palette = _SnackbarPalette.of(widget.type);

    final card = Material(
      color: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: palette.accentDark.withValues(alpha: 0.55),
            ),
            height: 76,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilterFallback(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      palette.soft,
                    ],
                  ),
                  border: Border.all(
                    color: palette.accent.withValues(alpha: 0.18),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: palette.accent.withValues(alpha: 0.22),
                      blurRadius: 28,
                      offset: const Offset(0, 14),
                      spreadRadius: -6,
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _AccentBar(palette: palette),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _IconBadge(
                              icon: widget.icon,
                              palette: palette,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: _Body(
                                title: widget.title,
                                message: widget.message,
                                accent: palette.accentDark,
                              ),
                            ),
                            if (widget.actionLabel != null) ...[
                              const SizedBox(width: 8),
                              _ActionButton(
                                label: widget.actionLabel!,
                                onTap: widget.onAction,
                                palette: palette,
                              ),
                            ] else if (widget.dismissible) ...[
                              const SizedBox(width: 4),
                              _CloseButton(
                                onTap: widget.onAction,
                                palette: palette,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 4,
            child: AnimatedBuilder(
              animation: _progressController,
              builder: (context, _) {
                return _ProgressBar(
                  value: 1 - _progressController.value,
                  palette: palette,
                );
              },
            ),
          ),
        ],
      ),
    );

    return widget.dismissible
        ? Dismissible(
            key: ValueKey(widget.message),
            direction: DismissDirection.horizontal,
            onDismissed: (_) => widget.onAction?.call(),
            child: card,
          )
        : card;
  }
}

/// Vertical accent strip that gives the snackbar its 3D-edge look.
class _AccentBar extends StatelessWidget {
  final _SnackbarPalette palette;
  const _AccentBar({required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [palette.accent, palette.accentDark],
        ),
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(18),
        ),
      ),
    );
  }
}

/// Circular icon "puck" with a layered gradient and glow.
class _IconBadge extends StatelessWidget {
  final IconData icon;
  final _SnackbarPalette palette;

  const _IconBadge({required this.icon, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [palette.accent, palette.accentDark],
        ),
        boxShadow: [
          BoxShadow(
            color: palette.accent.withValues(alpha: 0.45),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }
}

class _Body extends StatelessWidget {
  final String? title;
  final String message;
  final Color accent;

  const _Body({
    required this.title,
    required this.message,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final hasTitle = title != null && title!.trim().isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasTitle) ...[
          Text(
            title!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: accent,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 2),
        ],
        Text(
          message,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final _SnackbarPalette palette;

  const _ActionButton({
    required this.label,
    required this.onTap,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: palette.accentDark,
            ),
          ),
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  final VoidCallback? onTap;
  final _SnackbarPalette palette;

  const _CloseButton({required this.onTap, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            Icons.close_rounded,
            size: 18,
            color: palette.accentDark.withValues(alpha: 0.75),
          ),
        ),
      ),
    );
  }
}

/// Thin progress bar at the bottom that shrinks while the snackbar is alive.
class _ProgressBar extends StatelessWidget {
  final double value;
  final _SnackbarPalette palette;

  const _ProgressBar({required this.value, required this.palette});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: SizedBox(
        height: 3,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: palette.accent.withValues(alpha: 0.12),
              ),
            ),
            FractionallySizedBox(
              widthFactor: value.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [palette.accent, palette.accentDark],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder for platforms where `BackdropFilter` is too expensive on the
/// overlay; we still wrap the surface so future blur tweaks are localized.
class BackdropFilterFallback extends StatelessWidget {
  final Widget child;
  const BackdropFilterFallback({super.key, required this.child});

  @override
  Widget build(BuildContext context) => child;
}
