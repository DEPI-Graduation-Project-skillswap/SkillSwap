import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skill_swap/auth/view/screens/login_screen.dart';
import 'package:skill_swap/settings/view/widgets/logout_dialog.dart';
import 'package:skill_swap/settings/view_model/settings_provider.dart';
import 'package:skill_swap/shared/app_theme.dart';
import 'package:skill_swap/widgets/default_eleveted_botton.dart';

class SettingsTap extends StatefulWidget {
  const SettingsTap({super.key});

  @override
  State<SettingsTap> createState() => _SettingsTapState();
}

class _SettingsTapState extends State<SettingsTap> {
  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Settings", style: Theme.of(context).textTheme.titleLarge),
          Text(
            'Customize Your SkillSwap Expeirence',
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(color: Colors.grey.shade600),
          ),
          SizedBox(height: 50),
          Text(
            "Language",
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(fontSize: 20),
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade100,
            ),
            child: Column(
              children: [
                RadioListTile<String>(
                  value: 'English',
                  groupValue: settingsProvider.languageCode,
                  onChanged: (value) {
                    settingsProvider.changeLanguage("English");
                  },
                  title: Text(
                    'English',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  activeColor: Apptheme.primaryColor,
                  contentPadding: EdgeInsets.all(2),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(indent: 16, endIndent: 16),
                ),
                RadioListTile<String>(
                  value: 'Arabic',
                  groupValue: settingsProvider.languageCode,
                  onChanged: (value) {
                    setState(() {
                      settingsProvider.changeLanguage("Arabic");
                    });
                  },
                  title: Text(
                    'Arabic',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  activeColor: Apptheme.primaryColor,
                  contentPadding: EdgeInsets.all(2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Appearance',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            height: 70,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(width: 20),
                    settingsProvider.isDarkMode
                        ? Icon(
                          Icons.nightlight_round,
                          color: Colors.purpleAccent,
                          size: 30,
                        )
                        : Icon(Icons.sunny, color: Colors.yellow, size: 30),
                    SizedBox(width: 20),
                    Text(
                      "Dark Mode",
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge!.copyWith(fontSize: 20),
                    ),
                  ],
                ),

                Switch(
                  value: settingsProvider.isDarkMode,
                  onChanged: (value) {
                    settingsProvider.changeMode();
                  },
                  activeColor: Apptheme.primaryColor,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          DefaultElevetedBotton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return LogoutDialog(
                    onPressed: () {
                      settingsProvider.signOut();
                      logout();
                    },
                  );
                },
              );
            },
            text: "Logout",
            backGroundColor: Apptheme.red,
            icon: Icons.logout,
          ),
        ],
      ),
    );
  }

  void logout() {
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }
}
