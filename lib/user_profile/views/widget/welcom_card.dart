import 'package:flutter/material.dart';
import 'package:skill_swap/shared/app_theme.dart';

class WelcomCard extends StatelessWidget {
  const WelcomCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Apptheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Apptheme.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.waving_hand,
                color: Apptheme.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Welcome to Skill Swap!',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Apptheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'First, let\'s set up your profile. This will help connect you with people who match your skill interests.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
