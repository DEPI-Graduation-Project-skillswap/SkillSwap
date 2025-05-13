import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skill_swap/user_profile/data/models/user_profile_model.dart';
import 'package:skill_swap/user_profile/view_model/user_profile_setup_view_model.dart';
import 'package:skill_swap/chat/view/screens/chat_conversation_screen.dart';
import 'package:skill_swap/shared/app_theme.dart';

class FriendsTap extends StatefulWidget {
  const FriendsTap({Key? key}) : super(key: key);

  @override
  State<FriendsTap> createState() => _FriendsTapState();
}

class _FriendsTapState extends State<FriendsTap> {
  List<UserProfileModel> _friends = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final currentUserId = UserProfileSetupViewModel.currentUser!.userDetailId;
      
      final friendsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('friends');
      
      final snapshot = await friendsRef.get();
      
      if (snapshot.docs.isEmpty) {
        setState(() {
          _friends = [];
          _isLoading = false;
        });
        return;
      }

      final friendsList = snapshot.docs.map((doc) {
        final data = doc.data();
        return UserProfileModel(
          userDetailId: doc.id,
          name: data['name'],
          bio: data['bio'],
          wantedSkills: [], // Adding empty lists for required parameters
          offeredSkills: [], // Adding empty lists for required parameters
        );
      }).toList();

      setState(() {
        _friends = friendsList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load friends: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _friends.isEmpty
                  ? _buildEmptyState()
                  : _buildFriendsList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_alt_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'No friends yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Accept friend requests to see them here',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendsList() {
    return RefreshIndicator(
      onRefresh: _loadFriends,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _friends.length,
        itemBuilder: (context, index) {
          final friend = _friends[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: const AssetImage('assets/images/account_image.png'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          friend.name ?? 'No Name',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          friend.bio ?? 'No bio',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        ChatConversationScreen.routeName,
                        arguments: {
                          'conversationId': '${UserProfileSetupViewModel.currentUser!.userDetailId}_${friend.userDetailId}',
                          'otherUserId': friend.userDetailId,
                          'otherUserName': friend.name ?? 'Friend'
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Apptheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Chat'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
