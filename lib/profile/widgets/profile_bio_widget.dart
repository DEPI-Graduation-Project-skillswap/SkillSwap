import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/app_theme.dart';
import 'package:skill_swap/profile/cubits/profile_cubit.dart';

class ProfileBioWidget extends StatelessWidget {
  const ProfileBioWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => previous.bio != current.bio,
      builder: (context, state) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Apptheme.darkGray,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Apptheme.gray.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 18,
                    color: Apptheme.gray,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'About Me',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Apptheme.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                state.bio.isNotEmpty ? state.bio : 'No bio provided yet.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Apptheme.black.withOpacity(0.8),
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}