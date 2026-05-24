import 'package:flutter/material.dart';

import 'models/notification_model.dart';

const notificationPages = [
  // =========================
  // SUCCESS
  // =========================
  NotificationModel(
    title: 'Payment Successful',
    description: 'Your customer payment has been received successfully and invoice marked as paid.',
    type: NotificationType.success,
    icon: Icons.check_circle_rounded,
    imageUrl: 'https://images.unsplash.com/photo-1556740749-887f6717d7e4',
    features: ['Invoice auto-updated', 'Payment synced', 'Receipt generated'],
  ),

  // =========================
  // WARNING
  // =========================
  NotificationModel(
    title: 'Low Stock Alert',
    description: 'Some products are running critically low. Restock before sales get affected.',
    type: NotificationType.warning,
    icon: Icons.inventory_2_rounded,
    imageUrl: 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d',
    features: ['12 items below threshold', 'Auto reorder suggestions', 'Fast stock insights'],
  ),

  // =========================
  // ERROR
  // =========================
  NotificationModel(
    title: 'Sync Failed',
    description: 'Unable to sync your latest sales data. Please check internet connection.',
    type: NotificationType.error,
    icon: Icons.cloud_off_rounded,
    imageUrl: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3',
    features: ['Offline mode active', 'Data safely stored locally', 'Retry available'],
  ),

  // =========================
  // INFO
  // =========================
  NotificationModel(
    title: 'New Feature Available',
    description: 'Smart analytics dashboard is now available for your store.',
    type: NotificationType.info,
    icon: Icons.auto_graph_rounded,
    imageUrl: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71',
    features: ['Daily sales charts', 'Profit analysis', 'Customer insights'],
  ),

  // =========================
  // ALERT
  // =========================
  NotificationModel(
    title: 'Security Alert',
    description: 'A new login was detected from another device. Review activity immediately.',
    type: NotificationType.alert,
    icon: Icons.security_rounded,
    imageUrl: 'https://images.unsplash.com/photo-1563986768609-322da13575f3',
    features: ['Unknown device detected', 'Location tracking', 'Secure logout option'],
  ),

  // =========================
  // SUCCESS
  // =========================
  NotificationModel(
    title: 'Backup Completed',
    description: 'Your business data has been backed up securely to cloud storage.',
    type: NotificationType.success,
    icon: Icons.backup_rounded,
    imageUrl: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa',
    features: ['Encrypted backup', 'Auto daily sync', 'Restore anytime'],
  ),

  // =========================
  // WARNING
  // =========================
  NotificationModel(
    title: 'Subscription Expiring',
    description: 'Your premium plan will expire in 3 days. Renew to avoid interruptions.',
    type: NotificationType.warning,
    icon: Icons.workspace_premium_rounded,
    imageUrl: 'https://images.unsplash.com/photo-1520607162513-77705c0f0d4a',
    features: ['Renew in one tap', 'Keep premium access', 'Avoid feature lock'],
  ),

  // =========================
  // ERROR
  // =========================
  NotificationModel(
    title: 'Printer Disconnected',
    description: 'Thermal printer connection lost. Reconnect to continue printing bills.',
    type: NotificationType.error,
    icon: Icons.print_disabled_rounded,
    imageUrl: 'https://images.unsplash.com/photo-1516321497487-e288fb19713f',
    features: ['Bluetooth disconnected', 'Reconnect instantly', 'Pending bills saved'],
  ),

  // =========================
  // INFO
  // =========================
  NotificationModel(
    title: 'Daily Sales Report',
    description: 'Today’s revenue increased by 18% compared to yesterday.',
    type: NotificationType.info,
    icon: Icons.bar_chart_rounded,
    imageUrl: 'https://images.unsplash.com/photo-1460925895917-afdab827c52f',
    features: ['Top selling products', 'Revenue comparison', 'Peak sales hour'],
  ),

  // =========================
  // ALERT
  // =========================
  NotificationModel(
    title: 'Server Maintenance',
    description: 'Scheduled maintenance will start tonight at 2:00 AM for 30 minutes.',
    type: NotificationType.alert,
    icon: Icons.settings_suggest_rounded,
    imageUrl: 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31',
    features: ['Temporary downtime', 'Data remains safe', 'Auto reconnect after maintenance'],
  ),
];
