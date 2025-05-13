import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/notifications/data/models/notification_model.dart';
import 'package:skill_swap/notifications/data/repository/notification_repository.dart';

// States
abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
}

class NotificationsLoaded extends NotificationState {
  final List<NotificationModel> notifications;
  NotificationsLoaded(this.notifications);
}

class NotificationsEmpty extends NotificationState {}

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository repository;
  String currentUserId = '';

  NotificationCubit({required this.repository}) : super(NotificationInitial()) {
    currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  Future<void> getNotifications() async {
    try {
      emit(NotificationLoading());
      
      final notifications = await repository.getNotifications(currentUserId);
      
      if (notifications.isEmpty) {
        emit(NotificationsEmpty());
      } else {
        emit(NotificationsLoaded(notifications));
      }
    } catch (e) {
      emit(NotificationError('Failed to load notifications: $e'));
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await repository.markAsRead(notificationId);
      await getNotifications(); // Refresh the list
    } catch (e) {
      emit(NotificationError('Failed to mark notification as read: $e'));
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await repository.markAllAsRead(currentUserId);
      await getNotifications(); // Refresh the list
    } catch (e) {
      emit(NotificationError('Failed to mark all notifications as read: $e'));
    }
  }
}
