import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skill_swap/chat/data/data_source/chat_data_source.dart';
import 'package:skill_swap/chat/data/models/chat_conversation_model.dart';
import 'package:skill_swap/chat/data/models/message_model.dart';
// Chat firebase data source

class ChatFirebaseDataSource implements ChatDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<String> createOrGetConversation(String userId1, String userId2) async {
    // Sort user IDs to ensure consistent conversation IDs
    final List<String> userIds = [userId1, userId2]..sort();
    final String sortedId = "${userIds[0]}_${userIds[1]}";
    
    try {
      // Check if conversation already exists
      final conversationDoc = await _firestore
          .collection('conversations')
          .doc(sortedId)
          .get();
      
      if (conversationDoc.exists) {
        // Check if user-specific conversation entries exist and create if missing
        final user1ConvDoc = await _firestore
            .collection('user_conversations')
            .doc('${userId1}_$sortedId')
            .get();
            
        if (!user1ConvDoc.exists) {
          // Create missing user-specific conversation entry
          final user2Doc = await _firestore.collection('users').doc(userId2).get();
          final user2Data = user2Doc.data() as Map<String, dynamic>? ?? {};
          
          await _firestore
              .collection('user_conversations')
              .doc('${userId1}_$sortedId')
              .set({
            'conversationId': sortedId,
            'userId': userId1,
            'otherUserId': userId2,
            'userName': user2Data['name'] ?? '',
            'userBio': user2Data['bio'] ?? '',
            // Handle Firestore data safely
            'lastMessage': conversationDoc.exists ? (conversationDoc.data() as Map<String, dynamic>)['lastMessage'] ?? '' : '',
            'lastMessageTime': conversationDoc.exists ? (conversationDoc.data() as Map<String, dynamic>)['lastMessageTime'] ?? DateTime.now().toIso8601String() : DateTime.now().toIso8601String(),
            'unreadMessages': false,
          });
        }
        
        return sortedId;
      }
      
      // Get user data for both users
      final user1Doc = await _firestore.collection('users').doc(userId1).get();
      final user2Doc = await _firestore.collection('users').doc(userId2).get();
      
      final user1Data = user1Doc.data() as Map<String, dynamic>;
      final user2Data = user2Doc.data() as Map<String, dynamic>;
      
      // Create conversation documents for both users
      await _firestore.collection('conversations').doc(sortedId).set({
        'userId1': userIds[0],
        'userId2': userIds[1],
        'lastMessage': '',
        'lastMessageTime': DateTime.now().toIso8601String(),
        'unreadMessages': false,
        'createdAt': DateTime.now().toIso8601String(),
      });
      
      // Create user-specific conversation entries
      await _firestore
          .collection('user_conversations')
          .doc('${userId1}_$sortedId')
          .set({
        'conversationId': sortedId,
        'userId': userId1,
        'otherUserId': userId2,
        'userName': user2Data['name'] ?? '',
        'userBio': user2Data['bio'] ?? '',
        'lastMessage': '',
        'lastMessageTime': DateTime.now().toIso8601String(),
        'unreadMessages': false,
      });
      
      await _firestore
          .collection('user_conversations')
          .doc('${userId2}_$sortedId')
          .set({
        'conversationId': sortedId,
        'userId': userId2,
        'otherUserId': userId1,
        'userName': user1Data['name'] ?? '',
        'userBio': user1Data['bio'] ?? '',
        'lastMessage': '',
        'lastMessageTime': DateTime.now().toIso8601String(),
        'unreadMessages': false,
      });
      
      return sortedId;
    } catch (e) {
      print('Error creating conversation: $e');
      throw Exception('Failed to create or get conversation');
    }
  }

  @override
  Future<List<ChatConversationModel>> getConversations(String userId) async {
    try {
      final currentUserId = userId.isEmpty ? _auth.currentUser?.uid ?? '' : userId;
      
      print('Getting conversations for user: $currentUserId'); // Debug log
      
      // Get all user conversation documents
      final conversationsSnapshot = await _firestore
          .collection('user_conversations')
          .where('userId', isEqualTo: currentUserId)
          .orderBy('lastMessageTime', descending: true)
          .get();
      
      print('Found ${conversationsSnapshot.docs.length} conversations'); // Debug log
      
      // Process conversation documents
      final result = conversationsSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        print('Processing conversation: ${doc.id}'); // Debug log
        
        return ChatConversationModel(
          id: data['conversationId'] ?? '',
          userId1: data['userId'] ?? '',
          userId2: data['otherUserId'] ?? '',
          lastMessage: data['lastMessage'] ?? '',
          lastMessageTime: data['lastMessageTime'] ?? '',
          unreadMessages: data['unreadMessages'] ?? false,
          userName: data['userName'] ?? '',
          userBio: data['userBio'] ?? '',
        );
      }).toList();
      
      if (result.isEmpty) {
        // Try to find conversations where this user is participating but no user-specific documents exist
        final allConversationsQuery = await _firestore
            .collection('conversations')
            .get();
            
        for (final convDoc in allConversationsQuery.docs) {
          final convId = convDoc.id;
          if (convId.contains(currentUserId)) {
            // This user is part of this conversation, ensure user document exists
            String otherUserId = convId.split('_')[0];
            if (otherUserId == currentUserId) {
              otherUserId = convId.split('_')[1];
            }
            
            // Create user-specific conversation document
            await createOrGetConversation(currentUserId, otherUserId);
          }
        }
        
        // Try again after fixing
        final updatedSnapshot = await _firestore
            .collection('user_conversations')
            .where('userId', isEqualTo: currentUserId)
            .orderBy('lastMessageTime', descending: true)
            .get();
            
        return updatedSnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return ChatConversationModel(
            id: data['conversationId'] ?? '',
            userId1: data['userId'] ?? '',
            userId2: data['otherUserId'] ?? '',
            lastMessage: data['lastMessage'] ?? '',
            lastMessageTime: data['lastMessageTime'] ?? '',
            unreadMessages: data['unreadMessages'] ?? false,
            userName: data['userName'] ?? '',
            userBio: data['userBio'] ?? '',
          );
        }).toList();
      }
      
      return result;
    } catch (e) {
      print('Error getting conversations: $e');
      return [];
    }
  }

  @override
  Future<List<MessageModel>> getMessages(String conversationId) async {
    try {
      final messagesSnapshot = await _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .get();
      
      return messagesSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return MessageModel(
          id: doc.id,
          senderId: data['senderId'] ?? '',
          receiverId: data['receiverId'] ?? '',
          content: data['content'] ?? '',
          timestamp: data['timestamp'] ?? '',
          isRead: data['isRead'] ?? false,
        );
      }).toList();
    } catch (e) {
      print('Error getting messages: $e');
      return [];
    }
  }

  @override
  Future<void> markMessagesAsRead(String conversationId, String userId) async {
    try {
      final messagesQuery = await _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .where('receiverId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();
      
      final batch = _firestore.batch();
      
      for (var doc in messagesQuery.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      
      // Update unread status in user conversation
      final userConversationDoc = await _firestore
          .collection('user_conversations')
          .where('conversationId', isEqualTo: conversationId)
          .where('userId', isEqualTo: userId)
          .get();
      
      if (userConversationDoc.docs.isNotEmpty) {
        batch.update(userConversationDoc.docs.first.reference, {'unreadMessages': false});
      }
      
      await batch.commit();
    } catch (e) {
      print('Error marking messages as read: $e');
      throw Exception('Failed to mark messages as read');
    }
  }

  @override
  Future<String> sendMessage(MessageModel message) async {
    try {
      final List<String> userIds = [message.senderId, message.receiverId]..sort();
      final String conversationId = "${userIds[0]}_${userIds[1]}";
      
      // Create conversation if it doesn't exist
      await createOrGetConversation(message.senderId, message.receiverId);
      
      // Add message to the conversation
      final messageRef = _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .doc();
      
      final messageData = {
        'senderId': message.senderId,
        'receiverId': message.receiverId,
        'content': message.content,
        'timestamp': DateTime.now().toIso8601String(),
        'isRead': false,
      };
      
      await messageRef.set(messageData);
      
      // Get sender's name to display in notification
      final senderDoc = await _firestore.collection('users').doc(message.senderId).get();
      final senderData = (senderDoc.data() as Map<String, dynamic>?) ?? {};
      final senderName = senderData['name'] ?? 'Someone';
      
      // Update last message in both user conversation documents
      final batch = _firestore.batch();
      
      // Get sender's document for reference
      await _firestore.collection('users').doc(message.senderId).get();
      
      // Update conversation for sender
      final senderConversationQuery = await _firestore
          .collection('user_conversations')
          .where('userId', isEqualTo: message.senderId)
          .where('otherUserId', isEqualTo: message.receiverId)
          .get();
      
      if (senderConversationQuery.docs.isNotEmpty) {
        batch.update(senderConversationQuery.docs.first.reference, {
          'lastMessage': message.content,
          'lastMessageTime': DateTime.now().toIso8601String(),
          'unreadMessages': false,
        });
      }
      
      // Update conversation for receiver
      final receiverConversationQuery = await _firestore
          .collection('user_conversations')
          .where('userId', isEqualTo: message.receiverId)
          .where('otherUserId', isEqualTo: message.senderId)
          .get();
      
      if (receiverConversationQuery.docs.isNotEmpty) {
        batch.update(receiverConversationQuery.docs.first.reference, {
          'lastMessage': message.content,
          'lastMessageTime': DateTime.now().toIso8601String(),
          'unreadMessages': true,
        });
      }
      
      await batch.commit();
      
      // Create a notification for the recipient directly in Firestore
      // Skip notification to self
      if (message.receiverId != message.senderId) {
        try {
          // Create notification directly in Firestore for better reliability
          await _firestore.collection('notifications').add({
            'userId': message.receiverId,
            'senderId': message.senderId,
            'senderName': senderName,
            'message': message.content,
            'type': 'message',
            'timestamp': DateTime.now().toIso8601String(),
            'isRead': false,
            'conversationId': conversationId,
          });
          
          print('Created notification for: ${message.receiverId} from $senderName: ${message.content}');
        } catch (e) {
          print('Error creating message notification: $e');
        }
      }
      
      return messageRef.id;
    } catch (e) {
      print('Error sending message: $e');
      throw Exception('Failed to send message');
    }
  }
}
