import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:skill_swap/chat/view/screens/chat_conversation_screen.dart';
import 'package:skill_swap/notifications/data/data_source/notification_firebase_data_source.dart';
import 'package:skill_swap/notifications/data/repository/notification_repository.dart';
import 'package:skill_swap/notifications/view_model/notification_cubit.dart';
import 'package:skill_swap/shared/app_theme.dart';

class NotificationScreen extends StatefulWidget {
  static const String routeName = '/notifications';
  
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationCubit _notificationCubit;

  @override
  void initState() {
    super.initState();
    _notificationCubit = NotificationCubit(
      repository: NotificationRepository(
        dataSource: NotificationFirebaseDataSource(),
      ),
    );
    _loadNotifications();
  }

  void _loadNotifications() {
    _notificationCubit.getNotifications();
  }

  String _formatTimestamp(String timestamp) {
    final DateTime dateTime = DateTime.parse(timestamp);
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime notificationDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (today == notificationDate) {
      return DateFormat.jm().format(dateTime); // e.g., 3:32 PM
    } else if (today.difference(notificationDate).inDays == 1) {
      return 'Yesterday';
    } else if (today.difference(notificationDate).inDays < 7) {
      return DateFormat.E().format(dateTime); // e.g., Mon, Tue
    } else {
      return DateFormat.MMMd().format(dateTime); // e.g., Jan 12
    }
  }

  void _handleNotificationTap(notification) {
    // Mark as read
    _notificationCubit.markAsRead(notification.id);
    
    // Navigate based on notification type
    if (notification.type == 'message' && notification.conversationId != null) {
      Navigator.of(context).pushNamed(
        ChatConversationScreen.routeName,
        arguments: {
          'conversationId': notification.conversationId,
          'otherUserId': notification.senderId,
          'otherUserName': notification.senderName,
        },
      );
    }
    // Other notification types can be handled here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Apptheme.primaryColor,
              ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [

          TextButton(
            onPressed: () {
              _notificationCubit.markAllAsRead();
            },
            child: Text(
              'Mark all as read',
              style: TextStyle(color: Apptheme.primaryColor),
            ),
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => _notificationCubit,
        child: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is NotificationsLoaded) {
              return _buildNotificationsList(state.notifications);
            } else if (state is NotificationsEmpty) {
              return _buildEmptyNotifications();
            } else if (state is NotificationError) {
              return Center(
                child: Text('Error: ${state.message}'),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Widget _buildNotificationsList(final notifications) {
    return RefreshIndicator(
      onRefresh: () async {
        _loadNotifications();
      },
      child: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return _buildNotificationItem(notification);
        },
      ),
    );
  }

  Widget _buildNotificationItem(final notification) {
    return InkWell(
      onTap: () => _handleNotificationTap(notification),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.transparent : Colors.blue.withOpacity(0.05),
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        notification.senderName,
                        style: TextStyle(
                          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        _formatTimestamp(notification.timestamp),
                        style: TextStyle(
                          color: notification.isRead ? Colors.grey : Apptheme.primaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: TextStyle(
                      color: notification.isRead ? Colors.grey.shade600 : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyNotifications() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.notifications_none,
            size: 80,
            color: Apptheme.primaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No Notifications',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'You have no notifications at the moment',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

        ],
      ),
    );
  }
}
