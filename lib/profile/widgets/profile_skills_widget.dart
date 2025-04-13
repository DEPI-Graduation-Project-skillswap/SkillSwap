import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/app_theme.dart';
import 'package:skill_swap/profile/cubits/profile_cubit.dart';

class ProfileSkillsWidget extends StatelessWidget {
  const ProfileSkillsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) =>
          previous.offeredSkills != current.offeredSkills ||
          previous.desiredSkills != current.desiredSkills,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Skills I Offer
            _buildSkillsSection(
              context,
              'Skills I Offer',
              Icons.local_offer_outlined,
              Apptheme.primaryColor,
              state.offeredSkills,
            ),
            const SizedBox(height: 24),
            
            // Skills I Want to Learn
            _buildSkillsSection(
              context,
              'Skills I Want to Learn',
              Icons.school_outlined,
              Colors.orangeAccent,
              state.desiredSkills,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSkillsSection(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    List<String> skills,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: color,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Apptheme.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (skills.isEmpty)
          Text(
            'No skills added yet.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Apptheme.gray,
              fontStyle: FontStyle.italic,
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((skill) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: color.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  skill,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}