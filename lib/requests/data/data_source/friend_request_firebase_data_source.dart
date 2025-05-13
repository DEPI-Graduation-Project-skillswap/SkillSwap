import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skill_swap/auth/data/models/user_model.dart';
import 'package:skill_swap/requests/data/models/friend_request_model.dart';
import 'package:skill_swap/requests/data/data_source/friend_requests_data_source.dart';
import 'package:skill_swap/user_profile/data/models/user_profile_model.dart';
import 'package:skill_swap/user_profile/view_model/user_profile_setup_view_model.dart';
import 'package:skill_swap/notifications/utils/notification_helper.dart';

class FriendRequestFirebaseDataSource extends FriendRequestsDataSource {
  @override
  CollectionReference<UserModel> getUserCollections() {
    return FirebaseFirestore.instance
        .collection('users')
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
          toFirestore: (userModel, _) => userModel.toJson(),
        );
  }

  @override
  Future<void> addFriend(UserProfileModel user) async {
    final currentUser = UserProfileSetupViewModel.currentUser!;

    final friendRequestSend = FriendRequestModel(
      senderId: currentUser.userDetailId,
      receiverId: user.userDetailId,
      timestamp: DateTime.now().toIso8601String(),
      bio: user.bio ?? '',
      name: user.name ?? '',
    );

    final friendRequestReceived = FriendRequestModel(
      senderId: currentUser.userDetailId,
      receiverId: user.userDetailId,
      timestamp: DateTime.now().toIso8601String(),
      bio: currentUser.bio ?? '',
      name: currentUser.name ?? '',
    );

    final requestsSentRef = getUserCollections()
        .doc(currentUser.userDetailId)
        .collection('requestsSent')
        .withConverter<FriendRequestModel>(
          fromFirestore:
              (snapshot, _) => FriendRequestModel.fromJson(snapshot.data()!),
          toFirestore: (model, _) => model.toJson(),
        );

    await requestsSentRef.doc(user.userDetailId).set(friendRequestSend);

    final requestsReceivedRef = getUserCollections()
        .doc(user.userDetailId)
        .collection('requestsReceived')
        .withConverter<FriendRequestModel>(
          fromFirestore:
              (snapshot, _) => FriendRequestModel.fromJson(snapshot.data()!),
          toFirestore: (model, _) => model.toJson(),
        );

    await requestsReceivedRef
        .doc(currentUser.userDetailId)
        .set(friendRequestReceived);
    
    // Create notification for the receiver
    await NotificationHelper.createFriendRequestNotification(
      receiverId: user.userDetailId,
      receiverName: user.name ?? 'User',
    );
  }

  @override
  Future<List<FriendRequestModel>> getReceivedFriendRequests() async {
    final currentUserId = UserProfileSetupViewModel.currentUser!.userDetailId;

    final requestsReceivedRef = getUserCollections()
        .doc(currentUserId)
        .collection('requestsReceived')
        .withConverter<FriendRequestModel>(
          fromFirestore:
              (snapshot, _) => FriendRequestModel.fromJson(snapshot.data()!),
          toFirestore: (model, _) => model.toJson(),
        );

    final snapshot = await requestsReceivedRef.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Future<List<FriendRequestModel>> getSentFriendRequests() async {
    final currentUserId = UserProfileSetupViewModel.currentUser!.userDetailId;

    final requestsSentRef = getUserCollections()
        .doc(currentUserId)
        .collection('requestsSent')
        .withConverter<FriendRequestModel>(
          fromFirestore:
              (snapshot, _) => FriendRequestModel.fromJson(snapshot.data()!),
          toFirestore: (model, _) => model.toJson(),
        );

    final snapshot = await requestsSentRef.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Future<void> acceptFriendRequest(FriendRequestModel request) async {
    final currentUser = UserProfileSetupViewModel.currentUser!;
    final currentUserId = currentUser.userDetailId;
    final senderId = request.senderId;

    try {
      // Add sender to current user's friends
      await getUserCollections()
          .doc(currentUserId)
          .collection('friends')
          .doc(senderId)
          .set({
            'userDetailId': senderId,
            'name': request.name,
            'bio': request.bio,
          });

      // Add current user to sender's friends
      await getUserCollections()
          .doc(senderId)
          .collection('friends')
          .doc(currentUserId)
          .set({
            'userDetailId': currentUserId,
            'name': currentUser.name,
            'bio': currentUser.bio,
          });

      // Remove from requestsReceived
      await getUserCollections()
          .doc(currentUserId)
          .collection('requestsReceived')
          .doc(senderId)
          .delete();

      // Remove from sender's requestsSent
      await getUserCollections()
          .doc(senderId)
          .collection('requestsSent')
          .doc(currentUserId)
          .delete();
          
      // Create notification for the sender that their request was accepted
      await NotificationHelper.createFriendAcceptedNotification(
        receiverId: senderId,
        receiverName: request.name,
      );
    } catch (e) {
      throw Exception("Failed to accept friend request: $e");
    }
  }

  @override
  Future<void> declineFriendRequest(FriendRequestModel request) async {
    final currentUserId = UserProfileSetupViewModel.currentUser!.userDetailId;

    try {
      // Cancel outgoing request
      if (request.senderId == currentUserId) {
        // Current user is the sender (cancel request)
        await getUserCollections()
            .doc(currentUserId)
            .collection('requestsSent')
            .doc(request.receiverId)
            .delete();

        await getUserCollections()
            .doc(request.receiverId)
            .collection('requestsReceived')
            .doc(currentUserId)
            .delete();
      } else {
        // Current user is the receiver (decline request)
        await getUserCollections()
            .doc(currentUserId)
            .collection('requestsReceived')
            .doc(request.senderId)
            .delete();

        await getUserCollections()
            .doc(request.senderId)
            .collection('requestsSent')
            .doc(currentUserId)
            .delete();
      }
    } catch (e) {
      throw Exception("Failed to decline friend request: $e");
    }
  }
}
