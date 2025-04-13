import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/profile/cubits/profile_cubit.dart';
import 'package:skill_swap/profile/views/profile_setup_page.dart';
import 'package:skill_swap/widgets/default_eleveted_botton.dart'; // Import the default button

class EditProfileButtonWidget extends StatelessWidget {
  const EditProfileButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultElevetedBotton(
      icon: Icons.edit_outlined,
      text: 'Edit Profile',
      onPressed: () {
        // Read the current state from ProfileCubit
        final currentState = context.read<ProfileCubit>().state;

        // Navigate to ProfileSetupPage, passing the current ProfileState
        Navigator.pushNamed(
          context,
          ProfileSetupPage.routeName,
          arguments: currentState, // Pass the current profile data
        );
      },
    );
  }
}