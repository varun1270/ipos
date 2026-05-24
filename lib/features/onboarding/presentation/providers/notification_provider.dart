import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipos/features/notifications/data/models/notification_model.dart';
import 'package:ipos/features/notifications/data/notification_data.dart';

final notificationProvider = Provider<List<NotificationModel>>((ref) {
  return notificationPages;
});
