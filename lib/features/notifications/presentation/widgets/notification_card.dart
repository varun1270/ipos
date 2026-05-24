import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:ipos/core/theme/app_colors.dart';
import 'package:ipos/features/notifications/data/models/notification_model.dart';

class NotificationCard extends StatefulWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;
  final VoidCallback? onToggleRead;

  const NotificationCard({super.key, required this.notification, this.onTap, this.onToggleRead});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  bool _pressed = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 550));

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

    _slide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setPressed(bool value) {
    if (_pressed != value) {
      setState(() => _pressed = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.notification;
    final scheme = AppColors.of(context);

    final isDark = context.isDarkTheme;

    final accent = model.getIconColor();

    final background = Color.lerp(model.getBackgroundColor(context), scheme.surface, isDark ? 0.25 : 0.08) ?? model.getBackgroundColor(context);

    final borderColor = accent.withOpacity(isDark ? 0.18 : 0.10);

    final textColor = AppColors.getTextColorForBackground(context, background);

    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 140),
          scale: _pressed ? 0.985 : 1,
          curve: Curves.easeOut,
          child: GestureDetector(
            onTap: widget.onTap,
            onTapDown: (_) => _setPressed(true),
            onTapCancel: () => _setPressed(false),
            onTapUp: (_) => _setPressed(false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: borderColor, width: 1.2),
                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [background, Color.lerp(background, accent, isDark ? 0.08 : 0.04) ?? background]),
                boxShadow: [
                  if (!isDark) BoxShadow(color: accent.withOpacity(0.10), blurRadius: 40, spreadRadius: -10, offset: const Offset(0, 20)),
                  BoxShadow(color: Colors.black.withOpacity(isDark ? 0.35 : 0.06), blurRadius: 18, offset: const Offset(0, 10)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(26.8), // Slightly less to fit inside the border
                child: Stack(
                  children: [
                    // Glow Background (Blurred)
                    Positioned(
                      top: -60,
                      right: -60,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: accent.withOpacity(isDark ? 0.25 : 0.15)),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -40,
                      left: -40,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: accent.withOpacity(isDark ? 0.12 : 0.08)),
                        ),
                      ),
                    ),

                    // Content overlay
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // TOP
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ICON
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [accent, accent.withOpacity(0.7)]),
                                  boxShadow: [BoxShadow(color: accent.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6))],
                                  border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
                                ),
                                child: Icon(model.icon ?? model.defaultIcon, color: Colors.white, size: 26),
                              ),

                              const SizedBox(width: 16),

                              // CONTENT
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            model.title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18, color: textColor, fontWeight: model.read ? FontWeight.w600 : FontWeight.w800, height: 1.2),
                                          ),
                                        ),

                                        // UNREAD DOT
                                        if (!model.read)
                                          Container(
                                            width: 10,
                                            height: 10,
                                            margin: const EdgeInsets.only(left: 10),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: accent,
                                              boxShadow: [BoxShadow(color: accent.withOpacity(0.6), blurRadius: 8)],
                                              border: Border.all(color: background, width: 2),
                                            ),
                                          ),
                                      ],
                                    ),

                                    const SizedBox(height: 8),

                                    Text(
                                      model.description,
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(fontSize: 14, color: isDark ? scheme.textSecondary : scheme.textSecondary.withOpacity(0.9), height: 1.5, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // FEATURES
                          if (model.features.isNotEmpty) ...[
                            const SizedBox(height: 16),

                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: model.features.map((feature) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: isDark ? accent.withOpacity(0.12) : accent.withOpacity(0.06),
                                    border: Border.all(color: accent.withOpacity(isDark ? 0.15 : 0.10)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(shape: BoxShape.circle, color: accent.withOpacity(0.15)),
                                        child: Icon(Icons.check_rounded, size: 12, color: accent),
                                      ),

                                      const SizedBox(width: 6),

                                      Text(
                                        feature,
                                        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: isDark ? textColor.withOpacity(0.9) : textColor, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],

                          const SizedBox(height: 16),

                          // BOTTOM
                          Row(
                            children: [
                              // TYPE BADGE
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: accent.withOpacity(isDark ? 0.15 : 0.08)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(model.defaultIcon, size: 14, color: accent),

                                    const SizedBox(width: 6),

                                    Text(
                                      model.type.name.toUpperCase(),
                                      style: TextStyle(color: accent, fontWeight: FontWeight.w800, fontSize: 10, letterSpacing: 1.0),
                                    ),
                                  ],
                                ),
                              ),

                              const Spacer(),

                              Text(
                                _timeAgoLabel(),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.textTertiary, fontWeight: FontWeight.w600),
                              ),

                              const SizedBox(width: 16),

                              InkWell(
                                borderRadius: BorderRadius.circular(100),
                                onTap: widget.onToggleRead,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: model.read ? Colors.transparent : accent.withOpacity(0.1),
                                    border: Border.all(color: model.read ? scheme.border : accent.withOpacity(0.3)),
                                  ),
                                  child: Icon(model.read ? Icons.done_all_rounded : Icons.mark_email_unread_rounded, size: 18, color: model.read ? scheme.textTertiary : accent),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _timeAgoLabel() {
    return 'Just now';
  }
}
