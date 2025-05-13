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
      // Refresh sent requests list after adding a new friend request
      await getSentFriendRequests();
      return true;
    } catch (e) {
      print('Error adding friend: $e');
      return false;
    }
  }

  Future<bool> acceptFriendRequest(FriendRequestModel request) async {
    try {
      await friendsRequestsRepository.acceptFriendRequest(request);
      // Refresh the lists after action to update UI
      await getReceivedFriendRequests();
      await getSentFriendRequests();
      return true;
    } catch (e) {
      print('Error accepting friend request: $e');
      return false;
    }
  }

  Future<bool> declineFriendRequest(FriendRequestModel request) async {
    try {
      await friendsRequestsRepository.declineFriendRequest(request);
      
      // Always refresh both lists regardless of current state to keep everything in sync
      await getSentFriendRequests();
      await getReceivedFriendRequests();
      
      // Emit a special state to force UI updates in the home tab
      final currentState = state;
      if (currentState is SentFriendRequestsSuccess) {
        emit(SentFriendRequestsSuccess(
          // Filter out the cancelled request from the list
          currentState.list.where((req) => 
            !(req.senderId == request.senderId && req.receiverId == request.receiverId)
          ).toList()
        ));
      }
      
      return true;
    } catch (e) {
      print('Error declining friend request: $e');
      return false;
    }
  }
}
