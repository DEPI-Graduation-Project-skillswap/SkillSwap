import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserProfileSetupViewModel extends ChangeNotifier {
  List<String> skills = [];
  List<String> selectedSkills = [];
  List<String> showedSkills = [];

  void onSelectionChanged(List<String> newSelectedSkills) {
    selectedSkills = newSelectedSkills;
    notifyListeners();
  }

  Future<void> loadSkillsFromAssets(String searchKeyWord) async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/skills.json',
    );
    final jsonMap = jsonDecode(jsonString);
    skills = List<String>.from(jsonMap['skills']);
    if (searchKeyWord.isEmpty) {
      showedSkills = skills.take(5).toList();
    } else {
      showedSkills =
          skills
              .where(
                (skill) =>
                    skill.toLowerCase().contains(searchKeyWord.toLowerCase()),
              )
              .toList();
      if (showedSkills.length > 5) {
        showedSkills = showedSkills.take(5).toList();
      }
    }
    notifyListeners();
  }
}
