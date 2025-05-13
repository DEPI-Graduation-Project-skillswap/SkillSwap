import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skill_swap/auth/view/screens/login_screen.dart';
import 'package:skill_swap/settings/view/widgets/logout_dialog.dart';
import 'package:skill_swap/settings/view_model/settings_provider.dart';
import 'package:skill_swap/shared/app_theme.dart';
import 'package:skill_swap/shared/ui_utils.dart';
import 'package:skill_swap/widgets/default_eleveted_botton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsTap extends StatefulWidget {
  const SettingsTap({super.key});

  @override
  State<SettingsTap> createState() => _SettingsTapState();
}

class _SettingsTapState extends State<SettingsTap> {
  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    var local = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(local.settings, style: Theme.of(context).textTheme.titleLarge),
          Text(
            local.customize_experience,
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 50),
          Text(
            local.language,
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade100,
            ),
            child: Column(
              children: [
                RadioListTile<String>(
                  value: 'en',
                  groupValue: settingsProvider.languageCode,
                  onChanged: (value) {
                    if (value != null) {
                      settingsProvider.changeLanguage(value);
                    }
                  },
                  title: Text(
                    local.english,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  activeColor: Apptheme.primaryColor,
                  contentPadding: const EdgeInsets.all(2),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(indent: 16, endIndent: 16),
                ),
                RadioListTile<String>(
                  value: 'ar',
                  groupValue: settingsProvider.languageCode,
                  onChanged: (value) {
                    if (value != null) {
                      settingsProvider.changeLanguage(value);
                    }
                  },
                  title: Text(
                    local.arabic,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  activeColor: Apptheme.primaryColor,
                  contentPadding: const EdgeInsets.all(2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            local.appearance,
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
                    const SizedBox(width: 20),
                    settingsProvider.isDarkMode
                        ? const Icon(
                          Icons.nightlight_round,
                          color: Colors.purpleAccent,
                          size: 30,
                        )
                        : const Icon(
                          Icons.sunny,
                          color: Colors.yellow,
                          size: 30,
                        ),
                    const SizedBox(width: 20),
                    Text(
                      local.dark_mode,
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
          const SizedBox(height: 20),
          DefaultElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return LogoutDialog(
                    onPressed: () {
                      try {
                        settingsProvider.signOut();
                        logout();
                      } catch (e) {
                        if (mounted) {
                          UiUtils.showSnackBar(context, local.error_occurred);
                        }
                      }
                    },
                  );
                },
              );
            },
            text: local.logout,
            backGroundColor: Apptheme.red,
            icon: Icons.logout,
          ),
        ],
      ),
    );
  }

  void logout() {
    Navigator.of(context, rootNavigator: true).pop(); // Close dialog
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }
}
