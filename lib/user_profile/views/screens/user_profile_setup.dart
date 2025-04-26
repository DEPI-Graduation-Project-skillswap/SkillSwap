import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skill_swap/auth/view_model/auth_view_model.dart';
import 'package:skill_swap/home_screen.dart';
import 'package:skill_swap/shared/app_theme.dart';
import 'package:skill_swap/shared/ui_utils.dart';
import 'package:skill_swap/user_profile/data/models/user_profile_model.dart';
import 'package:skill_swap/user_profile/view_model/user_profile_setup_view_model.dart';
import 'package:skill_swap/user_profile/views/widget/profile_image.dart';
import 'package:skill_swap/user_profile/views/widget/skill_selector.dart';
import 'package:skill_swap/user_profile/views/widget/warb_widget.dart';
import 'package:skill_swap/user_profile/views/widget/welcom_card.dart';
import 'package:skill_swap/widgets/default_eleveted_botton.dart';
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
  TextEditingController wantedSkillsController = TextEditingController();
  bool firstbuild = true;
  final formKey = GlobalKey<FormState>();
  late final String userId;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final UserProfileSetupViewModel viewModel =
          Provider.of<UserProfileSetupViewModel>(context, listen: false);

      userId = AuthViewModel.currentUser!.id;
      UiUtils.showLoading(context);
      await viewModel.loadUserProfileDetails(userId);
      UiUtils.hideLoading(context);
      nameController.text = UserProfileSetupViewModel.currentuser?.name ?? '';
      bioController.text = UserProfileSetupViewModel.currentuser?.bio ?? '';
    });
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    offeredSkillsController.dispose();
    wantedSkillsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offeredViewModel = Provider.of<UserProfileSetupViewModel>(context);
    final wantedViewModel = Provider.of<UserProfileSetupViewModel>(context);
    if (firstbuild) {
      offeredViewModel.offredLoadSkillsFromAssets(offeredSkillsController.text);
      wantedViewModel.wantedLoadSkillsFromAssets(wantedSkillsController.text);
      nameController.text = UserProfileSetupViewModel.currentuser?.name ?? "";
      bioController.text = UserProfileSetupViewModel.currentuser?.bio ?? "";
      firstbuild = false;
    }
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
          child: Form(
            key: formKey,
            child: Column(
              children: [
                WelcomCard(),
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
                    } else if (value.trim().length < 3) {
                      return 'Name is too short';
                    } else if (value.trim().length > 20) {
                      return 'Name is too long';
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
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Bio is required';
                    } else if (value.trim().length < 3) {
                      return 'Bio is too short';
                    } else if (value.trim().length > 25) {
                      return 'Bio is too Long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DefaultTextFormFieled(
                  hintText: "Search for skills",
                  label: 'Skills you offer',
                  isPassword: false,
                  controller: offeredSkillsController,
                  onPressed: offeredViewModel.offredLoadSkillsFromAssets,
                ),
                WarbWidget(
                  skills: offeredViewModel.offerdSelectedSkills,
                  onSelectionChanged: offeredViewModel.offredonSelectionChanged,
                ),
                Divider(),
                SkillSelector(
                  skills: offeredViewModel.offeredShowedSkills,
                  selectedSkills: offeredViewModel.offerdSelectedSkills,
                  onSelectionChanged: offeredViewModel.offredonSelectionChanged,
                ),
                SizedBox(height: 20),
                DefaultTextFormFieled(
                  hintText: "Search for skills",
                  label: 'Skills you want',
                  isPassword: false,
                  controller: wantedSkillsController,
                  onPressed: wantedViewModel.wantedLoadSkillsFromAssets,
                ),
                WarbWidget(
                  skills: wantedViewModel.wantedSelectedSkills,
                  onSelectionChanged: wantedViewModel.wantedonSelectionChanged,
                ),
                Divider(),
                SkillSelector(
                  skills: wantedViewModel.wantedShowedSkills,
                  selectedSkills: wantedViewModel.wantedSelectedSkills,
                  onSelectionChanged: wantedViewModel.wantedonSelectionChanged,
                ),
                SizedBox(height: 20),
                DefaultElevetedBotton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      if (wantedViewModel.offerdSelectedSkills.isEmpty ||
                          wantedViewModel.wantedSelectedSkills.isEmpty) {
                        UiUtils.showSnackBar(
                          context,
                          'Add at least one skill to your offered or wanted skills',
                        );
                      } else {
                        UiUtils.showLoading(context);
                        try {
                          final user = UserProfileModel(
                            userDetailId: userId,
                            name: nameController.text,
                            bio: bioController.text,
                            offeredSkills: wantedViewModel.offerdSelectedSkills,
                            wantedSkills: wantedViewModel.wantedSelectedSkills,
                          );

                          await wantedViewModel.addUserDetails(userId, user);
                          UiUtils.hideLoading(context);
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            HomeScreen.routeName,
                            (route) => false,
                          );
                        } catch (e) {
                          UiUtils.hideLoading(context);
                          UiUtils.showSnackBar(
                            context,
                            'Something went wrong. Please try again.',
                          );
                        }
                      }
                    } else {
                      UiUtils.showSnackBar(context, 'Complete your profile');
                    }
                  },
                  text: 'Save and Continue',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
