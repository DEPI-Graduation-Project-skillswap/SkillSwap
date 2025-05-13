import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:skill_swap/chat/view/screens/chat_conversation_screen.dart';
import 'package:skill_swap/shared/app_theme.dart';
import 'package:skill_swap/user_profile/data/models/user_profile_model.dart';
import 'package:skill_swap/user_profile/view_model/user_profile_setup_view_model.dart';
import 'package:skill_swap/user_profile/views/screens/user_profile_setup.dart';
import 'package:skill_swap/user_profile/views/widget/warb_widget.dart';
import 'package:skill_swap/widgets/default_eleveted_botton.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              radius: 70,
              backgroundColor: Apptheme.gray,
              child: Icon(
                Icons.person,
                size: 100,
                color: Apptheme.primaryColor,
              ),
            ),
            SizedBox(height: 20),
            Text(
              textAlign: TextAlign.center,
              user.name ?? "",
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(fontSize: 25),
            ),
            Text(
              textAlign: TextAlign.center,
              user.bio ?? "",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 20,
                color: Apptheme.textColor,
              ),
            ),
            SizedBox(height: 50),
            Row(
              children: [
                Icon(Icons.local_offer_outlined, color: Apptheme.primaryColor),
                Text(
                  ' Offerd Skills',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Apptheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            WarbWidget(
              skills: user.offeredSkills ?? [],
              onSelectionChanged: () {},
              isReadOnly: true,
            ),
            Divider(height: 50),
            Row(
              children: [
                Icon(Icons.local_offer_outlined, color: Apptheme.primaryColor),
                Text(
                  ' Wanted Skills',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Apptheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            WarbWidget(
              skills: user.wantedSkills ?? [],
              onSelectionChanged: () {},
              isReadOnly: true,
            ),
            Spacer(),
            userProfileModel == null
                ? DefaultElevatedButton(
                  text: 'Edit Profile',
                  onPressed: () {
                    Navigator.of(context).pushNamed(UserProfileSetup.routeName);
                  },
                )
                : DefaultElevatedButton(
                    text: 'Chat With',
                    onPressed: () => _startChat(context, user),
                  ),
          ],
        ),
      ),
    );
  }
}
