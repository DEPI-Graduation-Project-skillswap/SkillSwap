import 'package:flutter/material.dart';

import 'package:skill_swap/shared/app_theme.dart';
import 'package:skill_swap/user_profile/data/models/user_profile_model.dart';
import 'package:skill_swap/user_profile/view_model/user_profile_setup_view_model.dart';
import 'package:skill_swap/user_profile/views/screens/user_profile_setup.dart';
import 'package:skill_swap/user_profile/views/widget/warb_widget.dart';
import 'package:skill_swap/widgets/default_eleveted_botton.dart';

class Profile extends StatelessWidget {
  static const String routeName = '/profile';
  const Profile({super.key});
  @override
  Widget build(BuildContext context) {
    final userProfileModel =
        ModalRoute.of(context)?.settings.arguments as UserProfileModel?;
    late UserProfileModel user;
    if (userProfileModel == null) {
      user = UserProfileSetupViewModel.currentuser!;
    } else {
      user = userProfileModel;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ' Profile',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              radius: 70,
              backgroundColor: Apptheme.gray,
              child: Icon(
                Icons.person,
                size: 100,
                color: Apptheme.primaryColor,
              ),
            ),
            SizedBox(height: 20),
            Text(
              textAlign: TextAlign.center,
              user.name ?? "",
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(fontSize: 25),
            ),
            Text(
              textAlign: TextAlign.center,
              user.bio ?? "",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 20,
                color: Apptheme.textColor,
              ),
            ),
            SizedBox(height: 50),
            Row(
              children: [
                Icon(Icons.local_offer_outlined, color: Apptheme.primaryColor),
                Text(
                  ' Offerd Skills',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Apptheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            WarbWidget(
              skills: user.offeredSkills ?? [],
              onSelectionChanged: () {},
              isReadOnly: true,
            ),
            Divider(height: 50),
            Row(
              children: [
                Icon(Icons.local_offer_outlined, color: Apptheme.primaryColor),
                Text(
                  ' Wanted Skills',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Apptheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            WarbWidget(
              skills: user.wantedSkills ?? [],
              onSelectionChanged: () {},
              isReadOnly: true,
            ),
            Spacer(),
            userProfileModel == null
                ? DefaultElevetedBotton(
                  text: 'Edit Profile',
                  onPressed: () {
                    Navigator.of(context).pushNamed(UserProfileSetup.routeName);
                  },
                )
                : DefaultElevetedBotton(text: 'Add Friend', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
