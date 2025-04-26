import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skill_swap/auth/data/models/user_model.dart';
import 'package:skill_swap/auth/view_model/auth_view_model.dart';
import 'package:skill_swap/home/data/data_source/home_data_source.dart';
import 'package:skill_swap/user_profile/data/models/user_profile_model.dart';
import 'package:skill_swap/user_profile/view_model/user_profile_setup_view_model.dart';

class HomeFirebaseDataSource extends HomeDataSource {
  static CollectionReference<UserModel> getuserCollections() =>
      FirebaseFirestore.instance
          .collection('users')
          .withConverter<UserModel>(
            fromFirestore:
                (snapshot, _) => UserModel.fromJson(snapshot.data()!),
            toFirestore: (userModel, _) => userModel.toJson(),
          );

  static CollectionReference<UserProfileModel> getUserDetails(String userID) {
    return getuserCollections()
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
        UserProfileSetupViewModel.currentuser!.wantedSkills!;
    String currentUserID = AuthViewModel.currentUser!.id;
    try {
      final usersSnapshot = await getuserCollections().get();
      List<UserProfileModel> userProfiles = [];

      for (var userDoc in usersSnapshot.docs) {
        final userDetailsSnapshot = await getUserDetails(userDoc.id).get();
        for (var detailDoc in userDetailsSnapshot.docs) {
          if (detailDoc.data().userDetailId != currentUserID &&
              currentUserWantedSkills.any((skill) {
                return detailDoc.data().offeredSkills!.contains(skill);
              })) {
            userProfiles.add(detailDoc.data());
          }
        }
      }
      return userProfiles;
    } catch (e) {
      throw Exception("Error fetching home users: $e");
    }
  }
}
