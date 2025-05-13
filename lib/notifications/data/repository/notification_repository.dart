import 'package:skill_swap/notifications/data/data_source/notification_data_source.dart';
import 'package:skill_swap/notifications/data/models/notification_model.dart';

class NotificationRepository {
  final NotificationDataSource dataSource;

  NotificationRepository({required this.dataSource});

  Future<List<NotificationModel>> getNotifications(String userId) async {
    return await dataSource.getNotifications(userId);
  }

  Future<void> addNotification(NotificationModel notification) async {
    await dataSource.addNotification(notification);
  }

  Future<void> markAsRead(String notificationId) async {
    await dataSource.markAsRead(notificationId);
  }

  Future<void> markAllAsRead(String userId) async {
    await dataSource.markAllAsRead(userId);
  }
}
