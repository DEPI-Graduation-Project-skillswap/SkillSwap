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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> taps = [HomeTap(), SearchTap(), RequestsTap(), FriendsTap(), SettingsTap()];
  int selectedIndex = 0;
  bool hasUnreadChats = false;
  bool hasUnreadNotifications = false;
  bool hasNewFriendRequests = false;
  
  @override
  void initState() {
    super.initState();
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
            hasUnreadNotifications = snapshot.docs.isNotEmpty;
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
            'SkillSwap',
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
