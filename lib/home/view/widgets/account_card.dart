import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skill_swap/chat/view/screens/chat_conversation_screen.dart';
import 'package:skill_swap/home/view/widgets/account_cart_eleveted_bottom.dart';
import 'package:skill_swap/user_profile/data/models/user_profile_model.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({
    super.key, 
    required this.user, 
    required this.onPressed,
    this.isRequestSent = false,
    this.isFriend = false,
    this.onChatPressed,
  });
  final VoidCallback? onPressed;
  final UserProfileModel user;
  final bool isRequestSent;
  final bool isFriend;
  final VoidCallback? onChatPressed;
  
  // Build the appropriate action button based on relationship status
  Widget _buildActionButton(BuildContext context) {
    if (isFriend) {
      // If users are already friends, show Friends indicator and Chat button
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue.shade300),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.people, color: Colors.blue, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Friends',
                  style: TextStyle(color: Colors.blue.shade800),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Chat With button
          AccountCartElevetedBottom(
            text: 'Chat With',
            onPressed: () => _navigateToChat(context),
            backgroundColor: Colors.green,
          ),
        ],
      );
    } else if (isRequestSent) {
      // If request is pending, show Cancel Request button
      return AccountCartElevetedBottom(
        text: 'Cancel Request',
        onPressed: onPressed,
        backgroundColor: Colors.orange,
      );
    } else {
      // Show Add Friend and Chat With buttons
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Add Friend button
          AccountCartElevetedBottom(
            text: 'Add Friend',
            onPressed: onPressed,
            backgroundColor: null,
          ),
          const SizedBox(width: 8),
          // Chat With button
          AccountCartElevetedBottom(
            text: 'Chat With',
            onPressed: () => _navigateToChat(context),
            backgroundColor: Colors.green,
          ),
        ],
      );
    }
  }
  
  // Navigate to chat with this user
  void _navigateToChat(BuildContext context) {
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
  
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _navigateToChat(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // User image and basic info
            _buildUserHeader(context),
            const SizedBox(height: 16),
            
            // Skills sections
            if ((user.wantedSkills ?? []).isNotEmpty) _buildSkillsSection(
              context, 
              "Wanted Skills:", 
              user.wantedSkills ?? []
            ),
            const SizedBox(height: 12),
            
            if ((user.offeredSkills ?? []).isNotEmpty) _buildSkillsSection(
              context, 
              "Offered Skills:", 
              user.offeredSkills ?? []
            ),
            
            // Button section - shows either Add Friend, Cancel Request, or Chat With button
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: _buildActionButton(context),
            ),
          ],
        ),
      ),
    ));
  }
  // Helper method to build the user profile header
  Widget _buildUserHeader(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            'assets/images/account_image.png',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name ?? 'No Name',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                user.bio ?? 'No bio available',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Colors.black54,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  // Helper method to build skills section
  Widget _buildSkillsSection(BuildContext context, String title, List<String> skills) {
    // Limit skills to display
    final showMore = skills.length > 3;
    final displayedSkills = showMore ? skills.take(3).toList() : skills;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            ...displayedSkills.map(
              (skill) => Chip(
                label: Text(skill),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.black12),
                ),
              ),
            ),
            if (showMore)
              Chip(
                label: const Text("more..."),
                backgroundColor: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.black12),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
