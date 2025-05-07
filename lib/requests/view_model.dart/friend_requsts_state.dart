import 'package:skill_swap/requests/data/models/friend_request_model.dart';

abstract class FriendRequestsState {}

class FriendRequestsInitial extends FriendRequestsState {}

class ReceivedFriendRequestsLoading extends FriendRequestsState {}

class ReceivedFriendRequestsError extends FriendRequestsState {}

class ReceivedFriendRequestsEmpty extends FriendRequestsState {}

class ReceivedFriendRequestsSuccess extends FriendRequestsState {
  late final List<FriendRequestModel> list;
  ReceivedFriendRequestsSuccess(this.list);
}

class SentFriendRequestsLoading extends FriendRequestsState {}

class SentFriendRequestsError extends FriendRequestsState {}

class SentFriendRequestsEmpty extends FriendRequestsState {}

class SentFriendRequestsSuccess extends FriendRequestsState {
  late final List<FriendRequestModel> list;
  SentFriendRequestsSuccess(this.list);
}
