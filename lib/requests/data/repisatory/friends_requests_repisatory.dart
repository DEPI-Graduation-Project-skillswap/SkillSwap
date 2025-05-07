import 'package:skill_swap/requests/data/models/friend_request_model.dart';
import 'package:skill_swap/requests/data/data_source/friend_requests_data_source.dart';
import 'package:skill_swap/user_profile/data/models/user_profile_model.dart';

class FriendsRequestsRepository {
  FriendRequestsDataSource friendRequestsDataSource;
  FriendsRequestsRepository({required this.friendRequestsDataSource});
  Future<void> addFriend(UserProfileModel user) async {
    await friendRequestsDataSource.addFriend(user);
  }

  Future<List<FriendRequestModel>> getReceivedFriendRequests() async {
    return await friendRequestsDataSource.getReceivedFriendRequests();
  }

  Future<List<FriendRequestModel>> getSentFriendRequests() async {
    return await friendRequestsDataSource.getSentFriendRequests();
  }

  Future<void> acceptFriendRequest(FriendRequestModel request) async {
    await friendRequestsDataSource.acceptFriendRequest(request);
  }

  Future<void> declineFriendRequest(FriendRequestModel request) async {
    await friendRequestsDataSource.declineFriendRequest(request);
  }
}
