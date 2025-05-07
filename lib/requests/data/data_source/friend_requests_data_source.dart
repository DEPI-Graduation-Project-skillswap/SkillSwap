import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skill_swap/auth/data/models/user_model.dart';
import 'package:skill_swap/requests/data/models/friend_request_model.dart';
import 'package:skill_swap/user_profile/data/models/user_profile_model.dart';

abstract class FriendRequestsDataSource {
  Future<void> addFriend(UserProfileModel user);
  CollectionReference<UserModel> getUserCollections();
  Future<List<FriendRequestModel>> getReceivedFriendRequests();
  Future<List<FriendRequestModel>> getSentFriendRequests();
  Future<void> acceptFriendRequest(FriendRequestModel request);
  Future<void> declineFriendRequest(FriendRequestModel request);
}
