import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/requests/data/models/friend_request_model.dart';
import 'package:skill_swap/requests/data/repisatory/friends_requests_repisatory.dart'; // Corrected typo likely
import 'package:skill_swap/requests/view_model.dart/friend_requsts_state.dart';
import 'package:skill_swap/user_profile/data/models/user_profile_model.dart';
import 'package:skill_swap/auth/view_model/auth_view_model.dart';

class FriendRequestsCubit extends Cubit<FriendRequestsState> {
  final FriendsRequestsRepository _repository;

  // Keep track of the last successfully loaded lists internally
  List<FriendRequestModel> _currentSentRequests = [];
  List<FriendRequestModel> _currentReceivedRequests = [];

  FriendRequestsCubit(this._repository) : super(FriendRequestsInitial()) {
    // Optionally load initial state here or trigger from UI
    // loadInitialRequests(); // Example: Load both on startup
  }

  // Helper to get IDs of users the current user sent requests to
  Set<String> get pendingOutgoingRecipientIds =>
      _currentSentRequests.map((req) => req.receiverId).toSet();

  // Method to check pending status for a specific user
  bool isRequestSentTo(String userId) =>
      pendingOutgoingRecipientIds.contains(userId);

  // Optional: Load both initially
  // Future<void> loadInitialRequests() async {
  //   await getSentFriendRequests();
  //   await getReceivedFriendRequests();
  // }

  Future<void> getSentFriendRequests() async {
    // Avoid emitting loading if we already have data maybe? Or always show loading.
    // if (state is! SentFriendRequestsSuccess) { // Example: only load if not already loaded
    emit(SentFriendRequestsLoading());
    // }
    try {
      _currentSentRequests = await _repository.getSentFriendRequests();
      if (_currentSentRequests.isEmpty) {
        emit(SentFriendRequestsEmpty());
      } else {
        // Emit success with the fetched list
        emit(SentFriendRequestsSuccess(List.from(_currentSentRequests)));
      }
    } catch (e) {
      print("Error fetching sent requests: $e");
      emit(SentFriendRequestsError());
    }
  }

  Future<void> getReceivedFriendRequests() async {
    // Similar logic as getSentFriendRequests
    // if (state is! ReceivedFriendRequestsSuccess) {
    emit(ReceivedFriendRequestsLoading());
    // }
    try {
      _currentReceivedRequests = await _repository.getReceivedFriendRequests();
      if (_currentReceivedRequests.isEmpty) {
        emit(ReceivedFriendRequestsEmpty());
      } else {
        emit(
          ReceivedFriendRequestsSuccess(List.from(_currentReceivedRequests)),
        );
      }
    } catch (e) {
      print("Error fetching received requests: $e");
      emit(ReceivedFriendRequestsError());
    }
  }

  // *** MODIFIED addFriend ***
  Future<bool> addFriend(UserProfileModel recipient) async {
    final recipientId = recipient.userDetailId;
    final currentUserId = AuthViewModel.currentUser?.id;

    if (currentUserId == null) {
      print("Error: Missing user IDs for friend request.");
      return false; // Return false
    }

    if (isRequestSentTo(recipientId)) {
      print("Request already sent to user: $recipientId");
      // Optionally, you can return true here if you consider "already sent" a success
      // For now, let's say it's not a *new* success, so return false.
      return false; // Return false
    }

    try {
      await _repository.addFriend(recipient);

      final newRequest = FriendRequestModel(
        senderId: currentUserId,
        receiverId: recipientId,
        name: recipient.name ?? '',
        bio: recipient.bio ?? '',
        timestamp: DateTime.now().toIso8601String(),
      );
      _currentSentRequests.add(newRequest);
      emit(SentFriendRequestsSuccess(List.from(_currentSentRequests)));
      return true; // Return true on success
    } catch (e) {
      print("Error sending friend request: $e");
      return false; // Return false on error
    }
  }

  Future<void> acceptFriendRequest(FriendRequestModel request) async {
    try {
      await _repository.acceptFriendRequest(request);
      // Remove from internal received list
      _currentReceivedRequests.removeWhere(
        (r) => r.senderId == request.senderId,
      );
      // Re-emit the updated received list state
      emit(ReceivedFriendRequestsSuccess(List.from(_currentReceivedRequests)));
      // Potentially update friend list state if managed elsewhere
    } catch (e) {
      print("Error accepting request: $e");
      // Handle error
    }
  }

  Future<void> declineFriendRequest(FriendRequestModel request) async {
    // Determine if it's cancelling an outgoing or declining an incoming
    final currentUserId = AuthViewModel.currentUser?.id;
    bool isCancellingOutgoing = request.senderId == currentUserId;

    try {
      await _repository.declineFriendRequest(
        request,
      ); // Repository handles DB deletion

      if (isCancellingOutgoing) {
        // Remove from internal sent list
        _currentSentRequests.removeWhere(
          (r) => r.receiverId == request.receiverId,
        );
        // Re-emit updated sent list state
        emit(SentFriendRequestsSuccess(List.from(_currentSentRequests)));
      } else {
        // Remove from internal received list
        _currentReceivedRequests.removeWhere(
          (r) => r.senderId == request.senderId,
        );
        // Re-emit updated received list state
        emit(
          ReceivedFriendRequestsSuccess(List.from(_currentReceivedRequests)),
        );
      }
    } catch (e) {
      print("Error declining/cancelling request: $e");
      // Handle error
    }
  }
}
