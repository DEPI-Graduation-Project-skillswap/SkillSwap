import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skill_swap/auth/data/models/user_model.dart';
import 'package:skill_swap/auth/view_model/auth_view_model.dart'; // Assuming AuthViewModel.currentUser.id is accessible
import 'package:skill_swap/home/data/data_source/home_data_source.dart';
import 'package:skill_swap/user_profile/data/models/user_profile_model.dart';
import 'package:skill_swap/user_profile/view_model/user_profile_setup_view_model.dart'; // Assuming UserProfileSetupViewModel.currentUser.wantedSkills is accessible

class HomeFirebaseDataSource extends HomeDataSource {
  static CollectionReference<UserModel> getUserCollections() =>
      FirebaseFirestore.instance
          .collection('users')
          .withConverter<UserModel>(
            fromFirestore:
                (snapshot, _) => UserModel.fromJson(snapshot.data()!),
            toFirestore: (userModel, _) => userModel.toJson(),
          );

  static CollectionReference<UserProfileModel> getUserDetails(String userID) {
    return getUserCollections()
        .doc(userID)
        .collection('userdetails')
        .withConverter(
          fromFirestore:
              (snapshot, _) => UserProfileModel.fromJson(snapshot.data()!),
          toFirestore: (userProfileModel, _) => userProfileModel.toJson(),
        );
  }

  @override
  Future<List<UserProfileModel>> getHomeUsers() async {
    // Safely access current user's wanted skills and ID
    final currentUserProfile = UserProfileSetupViewModel.currentUser;
    final currentUserAuth = AuthViewModel.currentUser;

    if (currentUserAuth == null || currentUserAuth.id.isEmpty) {
      // If current user ID is not available, we cannot proceed.
      print("Error: Current user ID is not available.");
      throw Exception("User not authenticated or ID missing.");
    }
    String currentUserID = currentUserAuth.id;

    // Handle cases where wantedSkills might be null or empty.
    // If currentUserProfile is null, or wantedSkills is null, treat as empty list.
    List<String> currentUserWantedSkills =
        currentUserProfile?.wantedSkills ?? [];

    try {
      final usersSnapshot = await getUserCollections().get();
      List<Map<String, dynamic>> usersWithScores = [];

      for (var userDoc in usersSnapshot.docs) {
        // userDoc.id is the ID of a user in the 'users' collection
        final userDetailsSnapshot = await getUserDetails(userDoc.id).get();
        for (var detailDoc in userDetailsSnapshot.docs) {
          UserProfileModel userProfile = detailDoc.data();

          // Skip the current user's profile
          if (userProfile.userDetailId == currentUserID) {
            continue;
          }

          int compatibilityScore = 0;
          // Calculate compatibility score if the other user has offered skills
          // and the current user has wanted skills.
          if (userProfile.offeredSkills != null &&
              userProfile.offeredSkills!.isNotEmpty &&
              currentUserWantedSkills.isNotEmpty) {
            for (String wantedSkill in currentUserWantedSkills) {
              if (userProfile.offeredSkills!.contains(wantedSkill)) {
                compatibilityScore++;
              }
            }
          }
          usersWithScores.add({
            'profile': userProfile,
            'score': compatibilityScore,
          });
        }
      }

      // Sort users:
      // 1. By compatibility score (descending)
      // 2. Optional: Add a secondary sort key if needed (e.g., by name for tie-breaking)
      usersWithScores.sort((a, b) {
        int scoreA = a['score'] as int;
        int scoreB = b['score'] as int;
        // Sort by score descending
        int scoreComparison = scoreB.compareTo(scoreA);
        if (scoreComparison != 0) {
          return scoreComparison;
        }
        // Optional: if scores are equal, you could sort by another criterion, e.g., name
        // String nameA = (a['profile'] as UserProfileModel).name ?? '';
        // String nameB = (b['profile'] as UserProfileModel).name ?? '';
        // return nameA.compareTo(nameB);
        return 0; // Keep original relative order for ties if no secondary sort
      });

      // Extract the sorted UserProfileModel list
      List<UserProfileModel> sortedUserProfiles =
          usersWithScores
              .map((item) => item['profile'] as UserProfileModel)
              .toList();

      return sortedUserProfiles;
    } catch (e) {
      print(
        "Error fetching home users: $e",
      ); // It's good practice to log the actual error
      throw Exception("Error fetching home users. Please try again later.");
    }
  }
}
