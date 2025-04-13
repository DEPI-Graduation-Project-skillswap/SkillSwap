import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/app_theme.dart'; // Assuming Apptheme is defined here
import 'package:skill_swap/profile/cubits/profile_setup_cubit.dart';
import 'package:skill_swap/profile/widgets/profile_picture_widget.dart';
import 'package:skill_swap/profile/widgets/full_name_widget.dart'; // Assuming exists
import 'package:skill_swap/profile/widgets/bio_widget.dart'; // Assuming exists
import 'package:skill_swap/profile/widgets/skills_selection_widget.dart'; // Assuming exists
import 'package:skill_swap/profile/widgets/category_chips_widget.dart'; // Assuming exists
import 'package:skill_swap/profile/widgets/save_button_widget.dart'; // Assuming exists

class ProfileSetupPage extends StatefulWidget {
  static const String routeName = '/profile-setup';

  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  // REMOVED: late ProfileSetupCubit _profileCubit; - Will be created by BlocProvider
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // REMOVED: _profileCubit = ProfileSetupCubit(); - BlocProvider handles creation
  }

  @override
  void dispose() {
    // REMOVED: _profileCubit.close(); - BlocProvider handles disposal
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use BlocProvider(create: ...) to manage the Cubit lifecycle
    return BlocProvider(
      // Creates the Cubit when the BlocProvider is inserted into the tree
      // and disposes it when removed.
      create: (context) => ProfileSetupCubit(),
      child: Scaffold(
        backgroundColor: Apptheme.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close, color: Apptheme.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Profile Setup',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Apptheme.black), // Ensure text color
          ),
          backgroundColor: Apptheme.white, // Match scaffold background
          elevation: 0,
        ),
        // Use a Builder or Consumer to get the context with the Cubit available
        body: BlocConsumer<ProfileSetupCubit, ProfileSetupState>(
          listener: (context, state) {
            // Listener can react to state changes, e.g., showing snackbars on success/error
            debugPrint('ProfileSetupPage LISTENER: Profile image updated: ${state.profileImage?.path ?? "none"}');
            if (state.errorMessage.isNotEmpty) {
              // Optional: Show error message from state via SnackBar if needed elsewhere
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //   content: Text(state.errorMessage),
              //   backgroundColor: Colors.red,
              // ));
            }
          },
          builder: (context, state) {
            // Access the cubit instance provided by BlocProvider
            // final profileCubit = context.read<ProfileSetupCubit>(); // Use context.read inside callbacks

            if (state.isLoading && state.skillOptions.isEmpty) { // Show loading only during initial data fetch
              return const Center(child: CircularProgressIndicator());
            }

            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome Message Container
                      Container(
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
                      ),
                      const SizedBox(height: 24),

                      // Error Message Display (if any, besides initial loading)
                      if (state.errorMessage.isNotEmpty && !state.isLoading)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.withOpacity(0.3)),
                          ),
                          child: Text(
                            state.errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),

                      // Profile Picture Widget (will now get state updates correctly)
                      const ProfilePictureWidget(),
                      const SizedBox(height: 24),

                      // Other Profile Fields
                      const FullNameWidget(), // Needs implementation
                      const SizedBox(height: 16),
                      const BioWidget(), // Needs implementation
                      const SizedBox(height: 24),

                      // Skills Selection Widgets
                      SkillsSelectionWidget(
                        title: 'Skills You Offer',
                        filteredSkills: state.filteredOfferedSkills,
                        selectedSkills: state.selectedOfferedSkills,
                        // Use context.read to access the cubit within callbacks
                        onFilter: (query) => context.read<ProfileSetupCubit>().filterOfferedSkills(query),
                        onSelect: (skill) => context.read<ProfileSetupCubit>().selectOfferedSkill(skill),
                      ),
                      const SizedBox(height: 24),
                      SkillsSelectionWidget(
                        title: 'Skills You Want to Learn',
                        filteredSkills: state.filteredDesiredSkills,
                        selectedSkills: state.selectedDesiredSkills,
                        onFilter: (query) => context.read<ProfileSetupCubit>().filterDesiredSkills(query),
                        onSelect: (skill) => context.read<ProfileSetupCubit>().selectDesiredSkill(skill),
                      ),
                      const SizedBox(height: 24), // Adjusted spacing

                      // Category Chips (assuming implementation)
                      const CategoryChipsWidget(),
                       const SizedBox(height: 40), // Spacing before button

                      // Save Button (assuming implementation)
                      SaveButtonWidget(formKey: _formKey),
                       const SizedBox(height: 20), // Padding at the bottom
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}