import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ipos/features/onboarding/presentation/providers/notification_provider.dart';
import 'package:ipos/features/notifications/presentation/widgets/notification_card.dart';
import 'package:ipos/features/notifications/data/models/notification_model.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationListProvider);
    final filter = ref.watch(notificationFilterProvider);

    List filtered = switch (filter) {
      NotificationFilter.unread => notifications.where((n) => !n.read).toList(),
      NotificationFilter.read => notifications.where((n) => n.read).toList(),
      _ => notifications,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(tooltip: 'Mark all read', icon: const Icon(Icons.mark_email_read_rounded), onPressed: () => ref.read(notificationListProvider.notifier).markAllRead()),
          PopupMenuButton<NotificationFilter>(
            onSelected: (f) => ref.read(notificationFilterProvider.notifier).state = f,
            itemBuilder: (context) => [
              const PopupMenuItem(value: NotificationFilter.all, child: Text('All')),
              const PopupMenuItem(value: NotificationFilter.unread, child: Text('Unread')),
              const PopupMenuItem(value: NotificationFilter.read, child: Text('Read')),
            ],
            icon: const Icon(Icons.filter_list_rounded),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        separatorBuilder: (context, index) => const SizedBox(height: 16.0),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          // Find original index to allow toggling by notifier
          final item = filtered[index] as NotificationModel;
          final originalIndex = notifications.indexOf(item);
          return NotificationCard(notification: item, onToggleRead: () => ref.read(notificationListProvider.notifier).toggleReadAt(originalIndex));
        },
      ),
    );
  }
}

// `NotificationCard` widget is implemented in presentation/widgets/notification_card.dart
