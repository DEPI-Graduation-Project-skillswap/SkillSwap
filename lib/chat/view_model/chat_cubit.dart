import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/chat/data/models/chat_conversation_model.dart';
import 'package:skill_swap/chat/data/models/message_model.dart';
import 'package:skill_swap/chat/data/repository/chat_repository.dart';


// States
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}

// Conversation states
class ConversationsLoaded extends ChatState {
  final List<ChatConversationModel> conversations;
  ConversationsLoaded(this.conversations);
}

class ConversationsEmpty extends ChatState {}

// Messages states
class MessagesLoaded extends ChatState {
  final List<MessageModel> messages;
  MessagesLoaded(this.messages);
}

class MessagesEmpty extends ChatState {}

class MessageSent extends ChatState {
  final MessageModel message;
  MessageSent(this.message);
}

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository repository;
  String currentUserId = '';

  ChatCubit({required this.repository}) : super(ChatInitial()) {
    currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  Future<void> getConversations() async {
    try {
      emit(ChatLoading());
      
      final conversations = await repository.getConversations(currentUserId);
      
      if (conversations.isEmpty) {
        emit(ConversationsEmpty());
      } else {
        emit(ConversationsLoaded(conversations));
      }
    } catch (e) {
      emit(ChatError('Failed to load conversations: $e'));
    }
  }

  Future<void> getMessages(String conversationId) async {
    try {
      emit(ChatLoading());
      
      final messages = await repository.getMessages(conversationId);
      
      // Mark messages as read
      await repository.markMessagesAsRead(conversationId, currentUserId);
      
      if (messages.isEmpty) {
        emit(MessagesEmpty());
      } else {
        emit(MessagesLoaded(messages));
      }
    } catch (e) {
      emit(ChatError('Failed to load messages: $e'));
    }
  }

  Future<bool> sendMessage(String receiverId, String content) async {
    try {
      final message = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: currentUserId,
        receiverId: receiverId,
        content: content,
        timestamp: DateTime.now().toIso8601String(),
        isRead: false,
      );
      
      final messageId = await repository.sendMessage(message);
      
      if (messageId.isNotEmpty) {
        // Get updated messages
        final conversationId = await repository.createOrGetConversation(
          currentUserId,
          receiverId,
        );
        
        await getMessages(conversationId);
        return true;
      }
      
      return false;
    } catch (e) {
      emit(ChatError('Failed to send message: $e'));
      return false;
    }
  }

  Future<String> createOrGetConversation(String otherUserId) async {
    try {
      return await repository.createOrGetConversation(
        currentUserId,
        otherUserId,
      );
    } catch (e) {
      emit(ChatError('Failed to create conversation: $e'));
      return '';
    }
  }
}
