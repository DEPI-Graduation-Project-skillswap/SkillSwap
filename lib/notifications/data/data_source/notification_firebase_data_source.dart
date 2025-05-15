import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skill_swap/notifications/data/data_source/notification_data_source.dart';
import 'package:skill_swap/notifications/data/models/notification_model.dart';

class NotificationFirebaseDataSource implements NotificationDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<NotificationModel>> getNotifications(String userId) async {
    try {
      print('Getting notifications for user: $userId'); // Debug log

      // Get notifications for the user, ordered by timestamp
      final notificationsSnapshot =
          await _firestore
              .collection('notifications')
              .where('userId', isEqualTo: userId)
              .orderBy('timestamp', descending: true)
              .get();

      print(
        'Found ${notificationsSnapshot.docs.length} notifications for user $userId',
      ); // Debug log

      // Process notifications
      final notifications =
          notificationsSnapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id; // Add document ID to the data
            print(
              'Processing notification: ${doc.id} - ${data['type']} - ${data['message']}',
            ); // Debug log
            return NotificationModel.fromJson(data);
          }).toList();

      return notifications;
    } catch (e) {
      print('Error getting notifications: $e');
      return [];
    }
  }

  @override
  Future<void> addNotification(NotificationModel notification) async {
    try {
      print('Adding notification: ${notification.message}'); // Debug log
      final docRef = await _firestore
          .collection('notifications')
          .add(notification.toJson());
      print('Added notification with ID: ${docRef.id}'); // Debug log
    } catch (e) {
      print('Error adding notification: $e');
      throw Exception('Failed to add notification');
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).update({
        'isRead': true,
      });
      print('Marked notification $notificationId as read'); // Debug log
    } catch (e) {
      print('Error marking notification as read: $e');
      throw Exception('Failed to mark notification as read');
    }
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    try {
      final batch = _firestore.batch();

      final unreadNotificationsSnapshot =
          await _firestore
              .collection('notifications')
              .where('userId', isEqualTo: userId)
              .where('isRead', isEqualTo: false)
              .get();

      print(
        'Marking ${unreadNotificationsSnapshot.docs.length} notifications as read',
      ); // Debug log

      for (var doc in unreadNotificationsSnapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      await batch.commit();
      print('Marked all notifications as read for user $userId'); // Debug log
    } catch (e) {
      print('Error marking all notifications as read: $e');
      throw Exception('Failed to mark all notifications as read');
    }
  }

  // Creates a notification for a new message
  Future<void> createMessageNotification({
    required String userId,
    required String senderId,
    required String senderName,
    required String message,
    required String conversationId,
  }) async {
    // Skip notification to self
    if (userId == senderId) return;

    try {
      // Create notification directly in Firestore
      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': userId,
        'senderId': senderId,
        'senderName': senderName,
        'message': message,
        'type': 'message',
        'timestamp': DateTime.now().toIso8601String(),
        'isRead': false,
        'conversationId': conversationId,
      });

      print('Created notification for: $userId from $senderName: $message');
    } catch (e) {
      print('Error creating message notification: $e');
    }
  }
}
