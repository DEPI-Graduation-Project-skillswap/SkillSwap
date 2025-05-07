import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/requests/data/models/friend_request_model.dart';
import 'package:skill_swap/requests/data/repisatory/friends_requests_repisatory.dart';
import 'package:skill_swap/requests/view_model.dart/friend_requsts_state.dart';
import 'package:skill_swap/shared/server_locator.dart';
import 'package:skill_swap/user_profile/data/models/user_profile_model.dart';

class FriendRequestsCubit extends Cubit<FriendRequestsState> {
  final FriendsRequestsRepository friendsRequestsRepository;

  FriendRequestsCubit()
    : friendsRequestsRepository = FriendsRequestsRepository(
        friendRequestsDataSource: ServerLocator.friendRequestsDataSource,
      ),
      super(FriendRequestsInitial());

  Future<void> getReceivedFriendRequests() async {
    emit(ReceivedFriendRequestsLoading());
    try {
      final list = await friendsRequestsRepository.getReceivedFriendRequests();
      if (list.isEmpty) {
        emit(ReceivedFriendRequestsEmpty());
      } else {
        emit(ReceivedFriendRequestsSuccess(list));
      }
    } catch (e) {
      emit(ReceivedFriendRequestsError());
    }
  }

  Future<void> getSentFriendRequests() async {
    emit(SentFriendRequestsLoading());
    try {
      final list = await friendsRequestsRepository.getSentFriendRequests();
      if (list.isEmpty) {
        emit(SentFriendRequestsEmpty());
      } else {
        emit(SentFriendRequestsSuccess(list));
      }
    } catch (e) {
      emit(SentFriendRequestsError());
    }
  }

  Future<bool> addFriend(UserProfileModel user) async {
    try {
      await friendsRequestsRepository.addFriend(user);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> acceptFriendRequest(FriendRequestModel request) async {
    try {
      await friendsRequestsRepository.acceptFriendRequest(request);
      await getReceivedFriendRequests(); // Refresh the list after action
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> declineFriendRequest(FriendRequestModel request) async {
    try {
      await friendsRequestsRepository.declineFriendRequest(request);
      await getReceivedFriendRequests(); // Refresh the list after action
      return true;
    } catch (_) {
      return false;
    }
  }
}
