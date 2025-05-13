import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skill_swap/notifications/data/data_source/notification_data_source.dart';
import 'package:skill_swap/notifications/data/models/notification_model.dart';

class NotificationFirebaseDataSource implements NotificationDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<NotificationModel>> getNotifications(String userId) async {
    try {
      print('Getting notifications for user: $userId'); // Debug log
      
      // First check if there are any notifications in the collection
      final allNotifications = await _firestore.collection('notifications').get();
      print('Total notifications in collection: ${allNotifications.docs.length}');
      
      // Then check if any are associated with this user
      final notificationsSnapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();
      
      print('Found ${notificationsSnapshot.docs.length} notifications for user $userId'); // Debug log
      
      // Log the first few notifications for debugging
      if (notificationsSnapshot.docs.isNotEmpty) {
        print('First notification details:');
        print(notificationsSnapshot.docs.first.data());
      }
      
      return notificationsSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return NotificationModel.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting notifications: $e');
      return [];
    }
  }

  @override
  Future<void> addNotification(NotificationModel notification) async {
    try {
      print('Adding notification: ${notification.message}'); // Debug log
      await _firestore.collection('notifications').add(notification.toJson());
    } catch (e) {
      print('Error adding notification: $e');
      throw Exception('Failed to add notification');
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      await _firestore
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      print('Error marking notification as read: $e');
      throw Exception('Failed to mark notification as read');
    }
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    try {
      final batch = _firestore.batch();
      
      final unreadNotificationsSnapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();
      
      for (var doc in unreadNotificationsSnapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      
      await batch.commit();
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
