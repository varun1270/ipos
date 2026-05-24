import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipos/features/notifications/data/models/notification_model.dart';
import 'package:ipos/features/notifications/data/notification_data.dart';

enum NotificationFilter { all, unread, read }

class NotificationListNotifier extends StateNotifier<List<NotificationModel>> {
  NotificationListNotifier([List<NotificationModel>? initial]) : super(initial ?? notificationPages.map((n) => n).toList());

  void markReadAt(int index) {
    if (index < 0 || index >= state.length) return;
    state = [
      for (var i = 0; i < state.length; i++)
        if (i == index) state[i].copyWith(read: true) else state[i],
    ];
  }

  void markUnreadAt(int index) {
    if (index < 0 || index >= state.length) return;
    state = [
      for (var i = 0; i < state.length; i++)
        if (i == index) state[i].copyWith(read: false) else state[i],
    ];
  }

  void toggleReadAt(int index) {
    if (index < 0 || index >= state.length) return;
    final current = state[index];
    state = [
      for (var i = 0; i < state.length; i++)
        if (i == index) current.copyWith(read: !current.read) else state[i],
    ];
  }

  void markAllRead() {
    state = state.map((n) => n.copyWith(read: true)).toList();
  }

  void markAllUnread() {
    state = state.map((n) => n.copyWith(read: false)).toList();
  }
}

final notificationListProvider = StateNotifierProvider<NotificationListNotifier, List<NotificationModel>>((ref) {
  return NotificationListNotifier();
});

final notificationFilterProvider = StateProvider<NotificationFilter>((ref) => NotificationFilter.all);
