import 'package:flutter/material.dart';

enum NotificationType { success, error, warning, info, alert }

class NotificationModel {
  /// Main title
  final String title;

  /// Short description/message
  final String description;

  /// Notification type
  final NotificationType type;

  /// Custom icon (optional)
  final IconData? icon;

  /// Network image url
  final String? imageUrl;

  /// Local asset image path
  final String? imagePath;

  /// Features / bullet points
  final List<String> features;

  /// Custom colors (optional override)
  final Color? iconColor;
  final Color? backgroundColorLight;
  final Color? backgroundColorDark;

  /// Optional timestamp for the notification
  final DateTime? timestamp;

  /// Read flag
  final bool read;

  const NotificationModel({
    required this.title,
    required this.description,
    required this.type,
    this.icon,
    this.imageUrl,
    this.imagePath,
    this.features = const [],
    this.iconColor,
    this.backgroundColorLight,
    this.backgroundColorDark,
    this.timestamp,
    this.read = false,
  });

  NotificationModel copyWith({
    String? title,
    String? description,
    NotificationType? type,
    IconData? icon,
    String? imageUrl,
    String? imagePath,
    List<String>? features,
    Color? iconColor,
    Color? backgroundColorLight,
    Color? backgroundColorDark,
    DateTime? timestamp,
    bool? read,
  }) {
    return NotificationModel(
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      imageUrl: imageUrl ?? this.imageUrl,
      imagePath: imagePath ?? this.imagePath,
      features: features ?? this.features,
      iconColor: iconColor ?? this.iconColor,
      backgroundColorLight: backgroundColorLight ?? this.backgroundColorLight,
      backgroundColorDark: backgroundColorDark ?? this.backgroundColorDark,
      timestamp: timestamp ?? this.timestamp,
      read: read ?? this.read,
    );
  }

  // =========================
  // DEFAULT TYPE COLORS
  // =========================

  Color get defaultIconColor {
    switch (type) {
      case NotificationType.success:
        return Colors.green;

      case NotificationType.error:
        return Colors.red;

      case NotificationType.warning:
        return Colors.orange;

      case NotificationType.info:
        return Colors.blue;

      case NotificationType.alert:
        return Colors.purple;
    }
  }

  Color get defaultLightBackground {
    switch (type) {
      case NotificationType.success:
        return const Color(0xFFEAFBF0);

      case NotificationType.error:
        return const Color(0xFFFFEEEE);

      case NotificationType.warning:
        return const Color(0xFFFFF7E8);

      case NotificationType.info:
        return const Color(0xFFEEF5FF);

      case NotificationType.alert:
        return const Color(0xFFF4EEFF);
    }
  }

  Color get defaultDarkBackground {
    switch (type) {
      case NotificationType.success:
        return const Color(0xFF102117);

      case NotificationType.error:
        return const Color(0xFF2A1414);

      case NotificationType.warning:
        return const Color(0xFF2A2114);

      case NotificationType.info:
        return const Color(0xFF121E2D);

      case NotificationType.alert:
        return const Color(0xFF1D1630);
    }
  }

  IconData get defaultIcon {
    switch (type) {
      case NotificationType.success:
        return Icons.check_circle_rounded;

      case NotificationType.error:
        return Icons.cancel_rounded;

      case NotificationType.warning:
        return Icons.warning_rounded;

      case NotificationType.info:
        return Icons.info_rounded;

      case NotificationType.alert:
        return Icons.notifications_active_rounded;
    }
  }

  // =========================
  // HELPERS
  // =========================

  Color getIconColor() {
    return iconColor ?? defaultIconColor;
  }

  Color getBackgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      return backgroundColorDark ?? defaultDarkBackground;
    }

    return backgroundColorLight ?? defaultLightBackground;
  }

  bool get hasImage {
    return imageUrl != null || imagePath != null;
  }
}
