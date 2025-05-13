import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/chat/data/data_source/chat_firebase_data_source.dart';
import 'package:skill_swap/chat/data/models/message_model.dart';
import 'package:skill_swap/chat/data/repository/chat_repository.dart';
import 'package:skill_swap/chat/view/widgets/message_bubble.dart';
import 'package:skill_swap/chat/view_model/chat_cubit.dart';
import 'package:skill_swap/shared/app_theme.dart';


class ChatConversationScreen extends StatefulWidget {
  static const String routeName = '/chat-conversation';
  
  final String conversationId;
  final String otherUserId;
  final String otherUserName;
  
  const ChatConversationScreen({
    super.key,
    required this.conversationId,
    required this.otherUserId,
    required this.otherUserName,
  });

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  late ChatCubit _chatCubit;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  
  @override
  void initState() {
    super.initState();
    _chatCubit = ChatCubit(
      repository: ChatRepository(
        dataSource: ChatFirebaseDataSource(),
      ),
    );
    _loadMessages();
  }
  
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  void _loadMessages() {
    _chatCubit.getMessages(widget.conversationId);
  }
  
  void _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;
    
    final success = await _chatCubit.sendMessage(
      widget.otherUserId,
      messageText,
    );
    
    if (success) {
      _messageController.clear();
      _scrollToBottom();
    }
  }
  
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.otherUserName,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Apptheme.primaryColor,
              ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocProvider(
        create: (context) => _chatCubit,
        child: Column(
          children: [
            Expanded(
              child: _buildMessagesStream(),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMessagesStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('conversations')
          .doc(widget.conversationId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'Send a message to start the conversation',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }
        
        // Mark messages as read
        _chatCubit.repository.markMessagesAsRead(
          widget.conversationId,
          currentUserId,
        );
        
        final messages = snapshot.data!.docs.map((doc) {
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
        
        return ListView.builder(
          controller: _scrollController,
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            final isMe = message.senderId == currentUserId;
            
            return MessageBubble(
              message: message,
              isMe: isMe,
            );
          },
        );
      },
    );
  }
  
  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Apptheme.primaryColor,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
