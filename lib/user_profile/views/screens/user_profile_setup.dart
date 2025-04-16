import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skill_swap/shared/app_theme.dart';
import 'package:skill_swap/user_profile/view_model/user_profile_setup_view_model.dart';
import 'package:skill_swap/user_profile/views/widget/profile_image.dart';
import 'package:skill_swap/user_profile/views/widget/skill_selector.dart';
import 'package:skill_swap/widgets/default_text_form_fieled.dart';

class UserProfileSetup extends StatefulWidget {
  static const String routeName = '/user-profile-setup';
  const UserProfileSetup({super.key});

  @override
  State<UserProfileSetup> createState() => _UserProfileSetupState();
}

class _UserProfileSetupState extends State<UserProfileSetup> {
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController offeredSkillsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<UserProfileSetupViewModel>(context);
    viewModel.loadSkillsFromAssets(offeredSkillsController.text);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profile Setup',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Apptheme.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
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
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
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
              ProfileImage(),
              const SizedBox(height: 16),
              DefaultTextFormFieled(
                hintText: 'Enter Your Name',
                label: "UserName",
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
                isPassword: false,
                controller: nameController,
              ),
              const SizedBox(height: 16),
              DefaultTextFormFieled(
                hintText: 'Enter Your Bio',
                icon: Icons.info_outline,
                label: "Bio",
                isPassword: false,
                controller: bioController,
              ),
              const SizedBox(height: 16),
              DefaultTextFormFieled(
                hintText: "Search for your skills",
                label: 'Skills You Offer',
                isPassword: false,
                controller: offeredSkillsController,
              ),
              SkillSelector(
                skills: viewModel.showedSkills,
                selectedSkills: viewModel.selectedSkills,
                onSelectionChanged: viewModel.onSelectionChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
