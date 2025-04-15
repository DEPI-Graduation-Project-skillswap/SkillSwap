// profile/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/app_theme.dart';
import 'package:skill_swap/profile/cubits/profile_cubit.dart';
import 'package:skill_swap/profile/cubits/profile_setup_cubit.dart'; // Import setup state
import 'package:skill_swap/profile/widgets/profile_header_widget.dart';
import 'package:skill_swap/profile/widgets/profile_bio_widget.dart';
import 'package:skill_swap/profile/widgets/profile_skills_widget.dart';
import 'package:skill_swap/profile/widgets/edit_profile_button.dart';

class ProfilePage extends StatelessWidget {
  static const String routeName = '/profile';

  // Accept optional initial data
  final ProfileSetupState? initialProfileData;

  const ProfilePage({super.key, this.initialProfileData});

  @override
  Widget build(BuildContext context) {
    // Retrieve arguments if not passed directly via constructor
    final routeArgs = ModalRoute.of(context)?.settings.arguments as ProfileSetupState?;
    final profileData = initialProfileData ?? routeArgs; // Prioritize constructor data

    return BlocProvider(
      // Pass initial data to the Cubit if available
      create: (context) => ProfileCubit(initialData: profileData),
      child: Scaffold(
        backgroundColor: Apptheme.white,
        appBar: AppBar(
          // Optionally hide back button if coming from setup via pushReplacementNamed
           automaticallyImplyLeading: profileData == null, // Only show back if NOT coming from setup
           leading: profileData == null ? IconButton(
             icon: const Icon(Icons.arrow_back, color: Apptheme.black),
             onPressed: () => Navigator.of(context).pop(),
           ) : null, // Hide back button if initial data is present
          title: Text(
            'My Profile',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Apptheme.black),
          ),
          backgroundColor: Apptheme.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: Apptheme.black),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings page coming soon')),
                );
              },
            ),
          ],
        ),
        body: BlocConsumer<ProfileCubit, ProfileState>( // Now consuming ProfileCubit
          listener: (context, state) {
            if (state.errorMessage.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // The widgets below will now use the state from ProfileCubit,
            // which is initialized either from arguments or loadProfile()
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ProfileHeaderWidget(), // Reads from ProfileCubit's state
                    SizedBox(height: 24),
                    ProfileBioWidget(), // Reads from ProfileCubit's state
                    SizedBox(height: 24),
                    ProfileSkillsWidget(), // Reads from ProfileCubit's state
                    SizedBox(height: 32),
                    EditProfileButtonWidget(),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}