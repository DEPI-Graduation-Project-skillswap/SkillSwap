import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skill_swap/notifications/data/models/notification_model.dart';
import 'package:skill_swap/user_profile/view_model/user_profile_setup_view_model.dart';

class NotificationHelper {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a notification for a new friend request
  static Future<void> createFriendRequestNotification({
    required String receiverId,
    required String receiverName,
  }) async {
    try {
      final currentUser = UserProfileSetupViewModel.currentUser!;

      // Skip notification to self
      if (receiverId == currentUser.userDetailId) return;

      final notification = NotificationModel(
        id: '', // Will be set by Firestore
        userId: receiverId,
        senderId: currentUser.userDetailId,
        senderName: currentUser.name ?? 'User',
        message: 'sent you a friend request',
        type: 'friend_request',
        timestamp: DateTime.now().toIso8601String(),
        isRead: false,
      );

      // Add notification to Firestore
      final docRef = await _firestore
          .collection('notifications')
          .add(notification.toJson());
      print('Created friend request notification with ID: ${docRef.id}');
    } catch (e) {
      print('Error creating friend request notification: $e');
    }
  }

  // Create a notification for a new message
  static Future<void> createMessageNotification({
    required String receiverId,
    required String receiverName,
    required String message,
    required String conversationId,
  }) async {
    try {
      final currentUser = UserProfileSetupViewModel.currentUser!;

      // Skip notification to self
      if (receiverId == currentUser.userDetailId) return;

      final notification = NotificationModel(
        id: '', // Will be set by Firestore
        userId: receiverId,
        senderId: currentUser.userDetailId,
        senderName: currentUser.name ?? 'User',
        message:
            message.length > 30 ? '${message.substring(0, 30)}...' : message,
        type: 'message',
        timestamp: DateTime.now().toIso8601String(),
        isRead: false,
        conversationId: conversationId,
      );

      // Add notification to Firestore
      final docRef = await _firestore
          .collection('notifications')
          .add(notification.toJson());
      print('Created message notification with ID: ${docRef.id}');
    } catch (e) {
      print('Error creating message notification: $e');
    }
  }

  // Create a notification for an accepted friend request
  static Future<void> createFriendAcceptedNotification({
    required String receiverId,
    required String receiverName,
  }) async {
    try {
      final currentUser = UserProfileSetupViewModel.currentUser!;

      // Skip notification to self
      if (receiverId == currentUser.userDetailId) return;

      final notification = NotificationModel(
        id: '', // Will be set by Firestore
        userId: receiverId,
        senderId: currentUser.userDetailId,
        senderName: currentUser.name ?? 'User',
        message: 'accepted your friend request',
        type: 'friend_accepted',
        timestamp: DateTime.now().toIso8601String(),
        isRead: false,
      );

      // Add notification to Firestore
      final docRef = await _firestore
          .collection('notifications')
          .add(notification.toJson());
      print('Created friend accepted notification with ID: ${docRef.id}');
    } catch (e) {
      print('Error creating friend accepted notification: $e');
    }
  }

  // Count unread notifications for a user
  static Stream<int> unreadNotificationsCount(String userId) {
    if (userId.isEmpty) return Stream.value(0);

    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}
