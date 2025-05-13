import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:skill_swap/chat/view/screens/chat_conversation_screen.dart';
import 'package:skill_swap/shared/app_theme.dart';
import 'package:skill_swap/shared/widgets/profile_initials.dart';
import 'package:skill_swap/user_profile/data/models/user_profile_model.dart';
import 'package:skill_swap/user_profile/view_model/user_profile_setup_view_model.dart';
import 'package:skill_swap/user_profile/views/screens/user_profile_setup.dart';
import 'package:skill_swap/user_profile/views/widget/warb_widget.dart';

class Profile extends StatefulWidget {
  static const String routeName = '/profile';
  const Profile({super.key});
  
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isFriend = false;
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
    // We'll check friendship status when the widget is built with context
  }
  
  // Start a chat with another user
  Future<void> _startChat(BuildContext context, UserProfileModel user) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final otherUserId = user.userDetailId;
    
    // Create conversation ID from user IDs (sorted for consistency)
    List<String> ids = [currentUserId, otherUserId];
    ids.sort(); // Ensure consistent order
    final conversationId = "${ids[0]}_${ids[1]}";
    
    // Navigate to the chat screen
    Navigator.of(context).pushNamed(
      ChatConversationScreen.routeName,
      arguments: {
        'conversationId': conversationId,
        'otherUserId': otherUserId,
        'otherUserName': user.name ?? 'User',
      },
    );
  }
  
  Future<void> checkFriendshipStatus(String otherUserId) async {
    if (otherUserId == FirebaseAuth.instance.currentUser?.uid) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    
    try {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
      final friendsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('friends')
          .doc(otherUserId)
          .get();
      
      setState(() {
        isFriend = friendsSnapshot.exists;
        isLoading = false;
      });
    } catch (e) {
      print('Error checking friendship status: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final userProfileModel =
        ModalRoute.of(context)?.settings.arguments as UserProfileModel?;
    late UserProfileModel user;
    if (userProfileModel == null) {
      user = UserProfileSetupViewModel.currentUser!;
    } else {
      user = userProfileModel;
      // Check friendship status when viewing another user's profile
      if (isLoading && user.userDetailId.isNotEmpty) {
        checkFriendshipStatus(user.userDetailId);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ' Profile',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ProfileInitials(
                  name: user.name ?? 'User',
                  radius: 70,
                  fontSize: 42,
                  border: Border.all(color: Colors.white, width: 4),
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              textAlign: TextAlign.center,
              user.name ?? "",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 26, 
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Card(
              elevation: 0,
              color: Colors.grey.shade100,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                  user.bio ?? "No bio provided",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 16,
                    color: Apptheme.textColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            SizedBox(height: 36),
            Container(
              decoration: BoxDecoration(
                color: Apptheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Apptheme.primaryColor.withOpacity(0.3)),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.local_offer_outlined, color: Apptheme.primaryColor),
                      SizedBox(width: 8),
                      Text(
                        'Offered Skills',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Apptheme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  WarbWidget(
                    skills: user.offeredSkills ?? [],
                    onSelectionChanged: () {},
                    isReadOnly: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.search_outlined, color: Colors.amber.shade800),
                      SizedBox(width: 8),
                      Text(
                        'Wanted Skills',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.amber.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  WarbWidget(
                    skills: user.wantedSkills ?? [],
                    onSelectionChanged: () {},
                    isReadOnly: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            userProfileModel == null
                ? SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: const Text(
                        'Edit Profile',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Apptheme.primaryColor,
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(UserProfileSetup.routeName);
                      },
                    ),
                  )
                : SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.chat, color: Colors.white),
                      label: const Text(
                        'Chat With',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Apptheme.primaryColor,
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => _startChat(context, user),
                    ),
                  ),
            SizedBox(height: 16),
          ],
        ),
      ),
    ),
    );
  }
}
