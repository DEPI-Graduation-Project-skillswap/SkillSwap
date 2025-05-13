import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skill_swap/chat/view/screens/chat_list_screen.dart';
import 'package:skill_swap/home/view/widgets/home_tap.dart';
import 'package:skill_swap/friends/view/widgets/friends_tap.dart';
import 'package:skill_swap/requests/view/screens/requests_tap.dart';
import 'package:skill_swap/search/search_tap.dart';
import 'package:skill_swap/settings/view/settings_tap.dart';
import 'package:skill_swap/shared/app_theme.dart';
import 'package:skill_swap/user_profile/views/screens/profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  final int? initialTabIndex;

  const HomeScreen({super.key, this.initialTabIndex});
  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> taps = [
    HomeTap(),
    SearchTap(),
    RequestsTap(),
    FriendsTap(),
    SettingsTap(),
  ];
  int selectedIndex = 0;
  bool hasUnreadChats = false;
  bool hasUnreadNotifications = false;
  bool hasNewFriendRequests = false;

  @override
  void initState() {
    super.initState();
    // Set initial tab index if provided
    if (widget.initialTabIndex != null) {
      selectedIndex = widget.initialTabIndex!;
    }

    // Listen for unread chats
    _checkForUnreadChats();
    // Listen for unread notifications
    _checkForUnreadNotifications();
    // Listen for new friend requests
    _checkForNewFriendRequests();
  }

  // Check for unread chat messages
  void _checkForUnreadChats() {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    FirebaseFirestore.instance
        .collection('user_conversations')
        .where('userId', isEqualTo: currentUserId)
        .where('unreadMessages', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
          setState(() {
            hasUnreadChats = snapshot.docs.isNotEmpty;
          });
        });
  }

  // Check for new friend requests
  void _checkForNewFriendRequests() {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('requestsReceived')
        .snapshots()
        .listen((snapshot) {
          setState(() {
            hasNewFriendRequests = snapshot.docs.isNotEmpty;
          });
        });
  }

  // Check for unread notifications
  void _checkForUnreadNotifications() {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    FirebaseFirestore.instance
        .collection('notifications')
        .where('userId', isEqualTo: currentUserId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
          setState(() {
            // Check if there are any unread notifications
            hasUnreadNotifications = snapshot.docs.isNotEmpty;

            // Also update the count for different notification types
            int messageNotifications = 0;
            int friendNotifications = 0;

            for (var doc in snapshot.docs) {
              final data = doc.data();
              final type = data['type'] as String?;

              if (type == 'message') {
                messageNotifications++;
              } else if (type == 'friend_request' ||
                  type == 'friend_accepted') {
                friendNotifications++;
              }
            }

            // Update unread chats based on message notifications too
            hasUnreadChats = hasUnreadChats || messageNotifications > 0;

            // Update friend requests indicator based on friend notifications
            hasNewFriendRequests =
                hasNewFriendRequests || friendNotifications > 0;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsetsDirectional.only(start: 20),
          child: Text(
            AppLocalizations.of(context)!.skillswap,
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(color: Apptheme.primaryColor),
          ),
        ),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, size: 30),
                onPressed: () {
                  Navigator.pushNamed(context, '/notifications');
                },
              ),
              if (hasUnreadNotifications)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: const Center(
                      child: Text(
                        '',
                        style: TextStyle(color: Colors.white, fontSize: 8),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, ChatListScreen.routeName);
                },
                icon: const Icon(Icons.chat_outlined, size: 30),
              ),
              if (hasUnreadChats)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: const Center(
                      child: Text(
                        '',
                        style: TextStyle(color: Colors.white, fontSize: 8),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(end: 20, start: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Profile.routeName);
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/account_image.png'),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          selectedIndex = index;
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.group_add_outlined),
                if (hasNewFriendRequests)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 10,
                        minHeight: 10,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outlined),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
      body: taps[selectedIndex],
    );
  }
}
