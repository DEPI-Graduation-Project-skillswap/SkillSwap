import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skill_swap/auth/data/data_source/auth_firebase.dart';
import 'package:skill_swap/user_profile/data/models/user_profile_model.dart';

class UserProfileFirebase {
  static CollectionReference<UserProfileModel> getUserDetails(String userID) {
    return AuthFirebase.getuserCollections()
        .doc(userID)
        .collection('userDetails')
        .withConverter(
          fromFirestore:
              (snapshot, _) => UserProfileModel.fromJson(snapshot.data()!),

          toFirestore: (userProfileModel, _) => userProfileModel.toJson(),
        );
  }

  static Future<void> addUserDetails(
    String userID,
    UserProfileModel userProfileModel,
  ) async {
    CollectionReference<UserProfileModel> userDetailsCollection =
        getUserDetails(userID);
    DocumentReference<UserProfileModel> doc = userDetailsCollection.doc();

    userProfileModel.userDetailId = doc.id;

    await userDetailsCollection.add(userProfileModel);
  }
}
