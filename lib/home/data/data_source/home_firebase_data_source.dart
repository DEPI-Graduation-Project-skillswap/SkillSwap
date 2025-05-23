import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skill_swap/auth/data/models/user_model.dart';
import 'package:skill_swap/auth/view_model/auth_view_model.dart';
import 'package:skill_swap/home/data/data_source/home_data_source.dart';
import 'package:skill_swap/user_profile/data/models/user_profile_model.dart';
import 'package:skill_swap/user_profile/view_model/user_profile_setup_view_model.dart';

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
    List<String> currentUserWantedSkills =
        UserProfileSetupViewModel.currentUser!.wantedSkills!;
    String currentUserID = AuthViewModel.currentUser!.id;
    try {
      final usersSnapshot = await getUserCollections().get();
      List<UserProfileModel> compatibleUsers = [];
      List<UserProfileModel> otherUsers = [];

      for (var userDoc in usersSnapshot.docs) {
        final userDetailsSnapshot = await getUserDetails(userDoc.id).get();
        for (var detailDoc in userDetailsSnapshot.docs) {
          if (detailDoc.data().userDetailId != currentUserID) {
            if (currentUserWantedSkills.any((skill) {
                  return detailDoc.data().offeredSkills!.contains(skill);
                })) {
              compatibleUsers.add(detailDoc.data());
            } else {
              otherUsers.add(detailDoc.data());
            }
          }
        }
      }
      return [...compatibleUsers, ...otherUsers];
    } catch (e) {
      throw Exception("Error fetching home users: $e");
    }
  }
}
