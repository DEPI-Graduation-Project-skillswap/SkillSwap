// lib/home/view/widgets/account_card.dart
import 'package:flutter/material.dart';
import 'package:skill_swap/home/view/widgets/account_cart_eleveted_bottom.dart';
import 'package:skill_swap/user_profile/data/models/user_profile_model.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({
    super.key,
    required this.user,
    required this.onPressed,
    required this.isRequestPending, // Required prop from HomeTap
  });

  final VoidCallback? onPressed;
  final UserProfileModel user;
  final bool isRequestPending;

  @override
  Widget build(BuildContext context) {
    final skills = user.offeredSkills ?? [];
    final showMore = skills.length > 4;
    final displayedSkills = showMore ? skills.take(3).toList() : skills;
    final theme = Theme.of(context);

    return Card(
      elevation: 6,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Image Header Stack --- (Keep as is)
          Stack(
            clipBehavior: Clip.none,
            children: [
              // ... Image ClipRRect ...
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      // FIX IS HERE
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      // *** ADD 'colors:' before the list ***
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
              // ... Name Positioned ...
            ],
          ),
          // --- Content Section --- (Keep as is)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Bio section --- (Keep as is, maybe add conditional logic)
                if (user.bio != null && user.bio!.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 14,
                    ),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.format_quote_rounded,
                          color: theme.colorScheme.secondary.withOpacity(0.6),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            user.bio!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: theme.colorScheme.onSurfaceVariant,
                              height: 1.3,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  const SizedBox(height: 20),
                // --- Offered skills section --- (Keep as is, maybe add conditional logic)
                if (skills.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Offered Skills",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        ...displayedSkills.map(
                          (skill) => Chip(
                            label: Text(
                              skill,
                              style: TextStyle(
                                color: theme.colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                            backgroundColor: theme.colorScheme.primaryContainer,
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            labelPadding: const EdgeInsets.symmetric(
                              horizontal: 6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        if (showMore)
                          Chip(
                            label: Text(
                              "+${skills.length - 3}",
                              style: TextStyle(
                                color: theme.colorScheme.onSecondaryContainer,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                            backgroundColor:
                                theme.colorScheme.secondaryContainer,
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            labelPadding: const EdgeInsets.symmetric(
                              horizontal: 6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ] else
                  const SizedBox(height: 20),

                // --- Action Button ---
                SizedBox(
                  width: double.infinity,
                  child: AccountCartElevetedBottom(
                    text: isRequestPending ? 'Request Sent' : 'Add Friend',
                    onPressed:
                        isRequestPending
                            ? null
                            : onPressed, // Uses isRequestPending
                    icon:
                        isRequestPending
                            ? Icons.check_circle_outline
                            : Icons.person_add_alt_1_rounded,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
