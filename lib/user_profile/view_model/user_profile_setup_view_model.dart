import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skill_swap/user_profile/data/data_source/user_profile_firebase.dart';
import 'package:skill_swap/user_profile/data/models/user_profile_model.dart';

class UserProfileSetupViewModel extends ChangeNotifier {
  List<String> skills = [];
  List<String> offerdSelectedSkills = [];
  List<String> offeredShowedSkills = [];
  List<String> wantedSelectedSkills = [];
  List<String> wantedShowedSkills = [];

  void offredonSelectionChanged(List<String> newSelectedSkills) {
    offerdSelectedSkills = newSelectedSkills;
    notifyListeners();
  }

  Future<void> offredLoadSkillsFromAssets(String searchKeyWord) async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/skills.json',
    );
    final jsonMap = jsonDecode(jsonString);
    skills = List<String>.from(jsonMap['skills']);
    if (searchKeyWord.isEmpty) {
      offeredShowedSkills = skills.take(5).toList();
    } else {
      offeredShowedSkills =
          skills
              .where(
                (skill) =>
                    skill.toLowerCase().contains(searchKeyWord.toLowerCase()),
              )
              .toList();
      if (offeredShowedSkills.length > 5) {
        offeredShowedSkills = offeredShowedSkills.take(5).toList();
      }
    }
    notifyListeners();
  }

  void wantedonSelectionChanged(List<String> newSelectedSkills) {
    wantedSelectedSkills = newSelectedSkills;
    notifyListeners();
  }

  Future<void> wantedLoadSkillsFromAssets(String searchKeyWord) async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/skills.json',
    );
    final jsonMap = jsonDecode(jsonString);
    skills = List<String>.from(jsonMap['skills']);
    if (searchKeyWord.isEmpty) {
      wantedShowedSkills = skills.take(5).toList();
    } else {
      wantedShowedSkills =
          skills
              .where(
                (skill) =>
                    skill.toLowerCase().contains(searchKeyWord.toLowerCase()),
              )
              .toList();
      if (wantedShowedSkills.length > 5) {
        wantedShowedSkills = wantedShowedSkills.take(5).toList();
      }
    }
    notifyListeners();
  }

  Future<void> addUserDetails(
    String userID,
    UserProfileModel userProfileModel,
  ) async {
    UserProfileFirebase.addUserDetails(userID, userProfileModel);
  }
}
