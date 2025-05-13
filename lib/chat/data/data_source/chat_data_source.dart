import 'package:skill_swap/chat/data/models/chat_conversation_model.dart';
import 'package:skill_swap/chat/data/models/message_model.dart';

abstract class ChatDataSource {
  Future<List<MessageModel>> getMessages(String conversationId);
  Future<List<ChatConversationModel>> getConversations(String userId);
  Future<String> sendMessage(MessageModel message);
  Future<String> createOrGetConversation(String userId1, String userId2);
  Future<void> markMessagesAsRead(String conversationId, String userId);
}
