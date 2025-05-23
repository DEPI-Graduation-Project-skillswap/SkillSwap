import 'package:flutter/material.dart';
import 'package:skill_swap/settings/data/repo/settings_repo.dart';
import 'package:skill_swap/shared/server_locator.dart';

class SettingsProvider with ChangeNotifier {
  late final SettingsRepo settingsRepo;

  SettingsProvider() {
    settingsRepo = SettingsRepo(dataSource: ServerLocator.settingsDataSource);
  }

  ThemeMode themeMode = ThemeMode.light;
  String languageCode = 'en';
  bool isDarkMode = false;

  void signOut() {
    settingsRepo.signOut();
    notifyListeners();
  }

  void changeLanguage(String code) {
    languageCode = code;
    notifyListeners();
  }

  void changeMode() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}
