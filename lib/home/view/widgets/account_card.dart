import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skill_swap/chat/view/screens/chat_conversation_screen.dart';
import 'package:skill_swap/home/view/widgets/account_cart_eleveted_bottom.dart';
import 'package:skill_swap/shared/app_theme.dart';
import 'package:skill_swap/shared/widgets/profile_initials.dart';
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
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _navigateToChat(context),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.grey.shade50],
            ),
          ),
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
        ProfileInitials(
          name: user.name ?? 'User',
          radius: 40,
          fontSize: 26,
          border: Border.all(color: Colors.white, width: 3),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name ?? 'No Name',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  user.bio ?? 'No bio available',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
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
    
    // Choose a different color based on the section title
    Color chipColor = title.contains("Wanted") ? 
        Colors.amber.shade100 : 
        Apptheme.primaryColor.withOpacity(0.1);
        
    Color borderColor = title.contains("Wanted") ? 
        Colors.amber.shade300 : 
        Apptheme.primaryColor.withOpacity(0.3);
        
    Color textColor = title.contains("Wanted") ? 
        Colors.amber.shade900 : 
        Apptheme.primaryColor;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                title.contains("Wanted") ? Icons.search : Icons.local_offer_outlined,
                color: textColor,
                size: 18,
              ),
              SizedBox(width: 6),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              ...displayedSkills.map(
                (skill) => Chip(
                  label: Text(
                    skill, 
                    style: TextStyle(fontSize: 12, color: textColor.withOpacity(0.8)),
                  ),
                  backgroundColor: chipColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: borderColor),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              if (showMore)
                Chip(
                  label: Text(
                    "more...", 
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                  backgroundColor: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
