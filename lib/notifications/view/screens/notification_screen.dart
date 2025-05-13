import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:skill_swap/chat/view/screens/chat_conversation_screen.dart';
import 'package:skill_swap/notifications/data/data_source/notification_firebase_data_source.dart';
import 'package:skill_swap/notifications/data/repository/notification_repository.dart';
import 'package:skill_swap/notifications/view_model/notification_cubit.dart';
import 'package:skill_swap/shared/app_theme.dart';
import 'package:skill_swap/shared/utils/navigation_utils.dart';

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
    // Mark as read when tapped
    _notificationCubit.markAsRead(notification.id);
    
    // Navigate to appropriate screen based on notification type
    switch (notification.type) {
      case 'message':
        // Navigate to chat conversation
        if (notification.conversationId != null) {
          Navigator.pushNamed(
            context,
            ChatConversationScreen.routeName,
            arguments: {
              'conversationId': notification.conversationId,
              'otherUserId': notification.senderId,
              'otherUserName': notification.senderName,
            },
          );
        }
        break;
      case 'friend_request':
        // Navigate to requests tab
        // Return to home screen and select the requests tab
        Navigator.popUntil(context, (route) => route.isFirst);
        // Access the HomeScreen state to select the requests tab
        // This will be handled in _buildRequestActionButton
        break;
      case 'friend_accepted':
        // Navigate to friends tab
        Navigator.popUntil(context, (route) => route.isFirst);
        // Access the HomeScreen state to select the friends tab
        // This will be handled in _buildAcceptedActionButton
        break;
      default:
        // Default behavior
        break;
    }
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
                      color: notification.isRead ? Colors.grey[700] : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Show appropriate action button based on notification type
                  _buildActionButton(notification),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build the appropriate action button based on notification type
  Widget _buildActionButton(final notification) {
    switch (notification.type) {
      case 'message':
        return _buildChatActionButton(notification);
      case 'friend_request':
        return _buildRequestActionButton(notification);
      case 'friend_accepted':
        return _buildAcceptedActionButton(notification);
      default:
        return const SizedBox.shrink(); // No action button for unknown types
    }
  }

  // Button for message notifications
  Widget _buildChatActionButton(final notification) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton.icon(
        onPressed: () => _handleNotificationTap(notification),
        icon: const Icon(Icons.chat, size: 16),
        label: const Text('Open Chat'),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Apptheme.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  // Button for friend request notifications
  Widget _buildRequestActionButton(final notification) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton.icon(
        onPressed: () {
          // Mark as read
          _notificationCubit.markAsRead(notification.id);
          
          // Navigate to requests tab (index 2)
          NavigationUtils.navigateToHomeTab(context, 2);
        },
        icon: const Icon(Icons.person_add, size: 16),
        label: const Text('View Request'),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.orange,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  // Button for accepted friend request notifications
  Widget _buildAcceptedActionButton(final notification) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton.icon(
        onPressed: () {
          // Mark as read
          _notificationCubit.markAsRead(notification.id);
          
          // Navigate to friends tab (index 3)
          NavigationUtils.navigateToHomeTab(context, 3);
        },
        icon: const Icon(Icons.people, size: 16),
        label: const Text('View Friends'),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: const TextStyle(fontSize: 12),
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
