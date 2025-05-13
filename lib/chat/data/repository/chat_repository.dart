import 'package:skill_swap/chat/data/data_source/chat_data_source.dart';
import 'package:skill_swap/chat/data/models/chat_conversation_model.dart';
import 'package:skill_swap/chat/data/models/message_model.dart';

class ChatRepository {
  final ChatDataSource dataSource;

  ChatRepository({required this.dataSource});

  Future<List<ChatConversationModel>> getConversations(String userId) async {
    return await dataSource.getConversations(userId);
  }

  Future<List<MessageModel>> getMessages(String conversationId) async {
    return await dataSource.getMessages(conversationId);
  }

  Future<String> sendMessage(MessageModel message) async {
    return await dataSource.sendMessage(message);
  }

  Future<String> createOrGetConversation(String userId1, String userId2) async {
    return await dataSource.createOrGetConversation(userId1, userId2);
  }

  Future<void> markMessagesAsRead(String conversationId, String userId) async {
    await dataSource.markMessagesAsRead(conversationId, userId);
  }
}
