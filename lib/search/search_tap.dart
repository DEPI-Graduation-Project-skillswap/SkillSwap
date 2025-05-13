import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skill_swap/auth/data/models/user_model.dart';
import 'package:skill_swap/chat/view/screens/chat_conversation_screen.dart';
import 'package:skill_swap/shared/app_theme.dart';
import 'package:skill_swap/user_profile/data/models/user_profile_model.dart';

class SearchTap extends StatefulWidget {
  const SearchTap({super.key});

  @override
  State<SearchTap> createState() => _SearchTapState();
}

class _SearchTapState extends State<SearchTap> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  List<UserProfileModel> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load all users on initial load to ensure users exist
    _loadAllUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Get users collection with converter
  CollectionReference<UserModel> _getUsersCollection() {
    return FirebaseFirestore.instance
        .collection('users')
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
          toFirestore: (userModel, _) => userModel.toJson(),
        );
  }

  // Get user details subcollection with converter
  CollectionReference<UserProfileModel> _getUserDetailsCollection(
    String userId,
  ) {
    return _getUsersCollection()
        .doc(userId)
        .collection('userdetails')
        .withConverter<UserProfileModel>(
          fromFirestore:
              (snapshot, _) => UserProfileModel.fromJson(snapshot.data()!),
          toFirestore: (userProfileModel, _) => userProfileModel.toJson(),
        );
  }

  // Load all users from Firebase using the correct collection structure
  void _loadAllUsers() async {
    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    try {
      print('Loading all users');
      final usersSnapshot = await _getUsersCollection().get();
      print('Found ${usersSnapshot.docs.length} users in main collection');

      List<UserProfileModel> allUsers = [];

      // Iterate through main users collection
      for (var userDoc in usersSnapshot.docs) {
        // Skip current user
        if (userDoc.id == currentUserId) continue;

        print('Fetching user details for user: ${userDoc.id}');

        // Get user details subcollection for this user
        final userDetailsSnapshot =
            await _getUserDetailsCollection(userDoc.id).get();
        print(
          'Found ${userDetailsSnapshot.docs.length} detail entries for user ${userDoc.id}',
        );

        // Add each user detail to results
        for (var detailDoc in userDetailsSnapshot.docs) {
          try {
            final userProfile = detailDoc.data();
            print('Added user: ${userProfile.name}');
            allUsers.add(userProfile);
          } catch (e) {
            print('Error processing user details: $e');
          }
        }
      }

      setState(() {
        _searchResults = allUsers;
        _isLoading = false;
      });

      if (allUsers.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No other users found in the system.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      print('Error loading users: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading users: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _performSearch(String query) async {
    // Don't search if query is empty
    if (query.trim().isEmpty) {
      _loadAllUsers(); // Show all users instead
      return;
    }

    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _searchQuery = query.trim().toLowerCase();
    });

    try {
      print('Searching for: $_searchQuery');
      final usersSnapshot = await _getUsersCollection().get();
      print('Searching through ${usersSnapshot.docs.length} users');

      List<UserProfileModel> results = [];

      // Iterate through main users collection
      for (var userDoc in usersSnapshot.docs) {
        // Skip current user
        if (userDoc.id == currentUserId) continue;

        // Get user details subcollection for this user
        final userDetailsSnapshot =
            await _getUserDetailsCollection(userDoc.id).get();

        // Process each user detail document
        for (var detailDoc in userDetailsSnapshot.docs) {
          try {
            final user = detailDoc.data();

            // Check if name matches
            bool nameMatch = false;
            if (user.name != null) {
              nameMatch = user.name!.toLowerCase().contains(_searchQuery);
            }

            // Check if skills match
            bool skillsMatch = false;
            if (user.offeredSkills != null) {
              skillsMatch = user.offeredSkills!.any(
                (skill) => skill.toLowerCase().contains(_searchQuery),
              );
            }

            if (user.wantedSkills != null && !skillsMatch) {
              skillsMatch = user.wantedSkills!.any(
                (skill) => skill.toLowerCase().contains(_searchQuery),
              );
            }

            // Add user if they match search criteria
            if (nameMatch || skillsMatch) {
              print('Match found: ${user.name}');
              results.add(user);
            }
          } catch (e) {
            print('Error processing user details during search: $e');
          }
        }
      }

      setState(() {
        _searchResults = results;
        _isLoading = false;
      });

      // If no results found, show message
      if (results.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No users found matching your search.'),
            action: SnackBarAction(label: 'Show All', onPressed: _loadAllUsers),
          ),
        );
      }
    } catch (e) {
      print('Search error: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error searching: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateToChat(UserProfileModel user) async {
    try {
      setState(() {
        _isLoading = true;
      });

      print('Starting chat with: ${user.name} (${user.userDetailId})');

      // Create conversation ID by combining and sorting user IDs
      final List<String> userIds = [currentUserId, user.userDetailId];
      userIds.sort();
      final String conversationId = userIds.join('_');

      // Check if conversation exists
      final conversationDoc =
          await _firestore
              .collection('conversations')
              .doc(conversationId)
              .get();

      // Create conversation if it doesn't exist
      if (!conversationDoc.exists) {
        await _firestore.collection('conversations').doc(conversationId).set({
          'createdAt': DateTime.now().toIso8601String(),
          'lastMessage': '',
          'lastMessageTime': DateTime.now().toIso8601String(),
        });
      }

      // Create user conversation entry for current user
      final userConvDocId = '${currentUserId}_$conversationId';
      final userConversationDoc =
          await _firestore
              .collection('user_conversations')
              .doc(userConvDocId)
              .get();

      if (!userConversationDoc.exists) {
        await _firestore
            .collection('user_conversations')
            .doc(userConvDocId)
            .set({
              'conversationId': conversationId,
              'userId': currentUserId,
              'otherUserId': user.userDetailId,
              'userName': user.name ?? 'User',
              'userBio': user.bio ?? '',
              'lastMessage': '',
              'lastMessageTime': DateTime.now().toIso8601String(),
              'unreadMessages': false,
            });
      }
      // Complete the navigation by going to chat screen
      setState(() {
        _isLoading = false;
      });

      // Navigate to conversation screen
      Navigator.pushNamed(
        context,
        ChatConversationScreen.routeName,
        arguments: {
          'conversationId': conversationId,
          'otherUserId': user.userDetailId,
          'otherUserName': user.name ?? 'User',
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error navigating to chat: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search by name or skills...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _loadAllUsers(); // Show all users when cleared
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Apptheme.primaryColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Apptheme.primaryColor,
                  width: 2.0,
                ),
              ),
            ),
            onSubmitted: _performSearch,
          ),

          const SizedBox(height: 16),

          // Action buttons
          Row(
            children: [
              // Search button
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () => _performSearch(_searchController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Apptheme.primaryColor,
                    minimumSize: const Size(0, 50),
                  ),
                  child: const Text(
                    'Search',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Show All button
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: _loadAllUsers,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: const Size(0, 50),
                  ),
                  child: const Text(
                    'Show All',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Results list
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _searchResults.isEmpty
                    ? Center(
                      child:
                          _hasSearched
                              ? const Text('No results found')
                              : const Text(
                                'Search for users by name or skills',
                              ),
                    )
                    : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final user = _searchResults[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Apptheme.primaryColor,
                              child: Text(
                                user.name?.isNotEmpty == true
                                    ? user.name![0].toUpperCase()
                                    : 'U',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(user.name ?? 'User'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user.bio ?? 'No bio'),
                                const SizedBox(height: 4),
                                if (user.offeredSkills?.isNotEmpty == true)
                                  Wrap(
                                    spacing: 4,
                                    children:
                                        user.offeredSkills!.map((skill) {
                                          return Chip(
                                            label: Text(skill),
                                            backgroundColor: Colors.green[100],
                                            labelStyle: const TextStyle(
                                              fontSize: 10,
                                            ),
                                            padding: EdgeInsets.zero,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                          );
                                        }).toList(),
                                  ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.chat_outlined,
                                color: Apptheme.primaryColor,
                              ),
                              onPressed: () => _navigateToChat(user),
                            ),
                            onTap: () => _navigateToChat(user),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
