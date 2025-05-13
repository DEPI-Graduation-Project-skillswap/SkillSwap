import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skill_swap/chat/data/models/chat_conversation_model.dart';
import 'package:skill_swap/shared/app_theme.dart';

class ChatConversationTile extends StatelessWidget {
  final ChatConversationModel conversation;
  final VoidCallback onTap;

  const ChatConversationTile({
    Key? key,
    required this.conversation,
    required this.onTap,
  }) : super(key: key);

  String _formatTimestamp(String timestamp) {
    final DateTime dateTime = DateTime.parse(timestamp);
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (today == messageDate) {
      return DateFormat.jm().format(dateTime); // e.g., 3:32 PM
    } else if (today.difference(messageDate).inDays == 1) {
      return 'Yesterday';
    } else if (today.difference(messageDate).inDays < 7) {
      return DateFormat.E().format(dateTime); // e.g., Mon, Tue
    } else {
      return DateFormat.MMMd().format(dateTime); // e.g., Jan 12
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: conversation.unreadMessages ? Colors.blue.withOpacity(0.05) : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: const AssetImage('assets/images/account_image.png'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        conversation.userName,
                        style: TextStyle(
                          fontWeight: conversation.unreadMessages ? FontWeight.bold : FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        _formatTimestamp(conversation.lastMessageTime),
                        style: TextStyle(
                          color: conversation.unreadMessages ? Apptheme.primaryColor : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.lastMessage.isEmpty ? 'Start a conversation' : conversation.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: conversation.unreadMessages ? Colors.black87 : Colors.grey.shade600,
                            fontWeight: conversation.unreadMessages ? FontWeight.w500 : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (conversation.unreadMessages)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Apptheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
