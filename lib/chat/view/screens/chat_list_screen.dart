import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/chat/data/data_source/chat_firebase_data_source.dart';
import 'package:skill_swap/chat/data/repository/chat_repository.dart';
import 'package:skill_swap/chat/view/screens/chat_conversation_screen.dart';
import 'package:skill_swap/chat/view/widgets/chat_conversation_tile.dart';
import 'package:skill_swap/chat/view_model/chat_cubit.dart';
import 'package:skill_swap/shared/app_theme.dart';
import 'package:skill_swap/shared/ui_utils.dart';

class ChatListScreen extends StatefulWidget {
  static const String routeName = '/chat-list';
  
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late ChatCubit _chatCubit;

  @override
  void initState() {
    super.initState();
    _chatCubit = ChatCubit(
      repository: ChatRepository(
        dataSource: ChatFirebaseDataSource(),
      ),
    );
    _loadConversations();
  }

  void _loadConversations() {
    _chatCubit.getConversations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chats',
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
        child: BlocConsumer<ChatCubit, ChatState>(
          listener: (context, state) {
            if (state is ChatError) {
              UiUtils.showSnackBar(
                context,
                state.message,
                color: Apptheme.red,
              );
            }
          },
          builder: (context, state) {
            if (state is ChatLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ConversationsLoaded) {
              return _buildConversationsList(state.conversations);
            } else if (state is ConversationsEmpty) {
              return _buildEmptyConversations();
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Widget _buildConversationsList(final conversations) {
    return RefreshIndicator(
      onRefresh: () async {
        _loadConversations();
      },
      child: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          return ChatConversationTile(
            conversation: conversation,
            onTap: () {
              Navigator.pushNamed(
                context,
                ChatConversationScreen.routeName,
                arguments: {
                  'conversationId': conversation.id,
                  'otherUserId': conversation.userId2,
                  'otherUserName': conversation.userName,
                },
              ).then((_) => _loadConversations());
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyConversations() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Apptheme.primaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No conversations yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Start chatting with friends from the home screen',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

        ],
      ),
    );
  }
}
