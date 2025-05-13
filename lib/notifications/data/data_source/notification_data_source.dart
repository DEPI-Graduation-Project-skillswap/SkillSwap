import 'package:skill_swap/notifications/data/models/notification_model.dart';

abstract class NotificationDataSource {
  Future<List<NotificationModel>> getNotifications(String userId);
  Future<void> addNotification(NotificationModel notification);
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead(String userId);
}
