import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skill_swap/home/view/widgets/account_card.dart';
import 'package:skill_swap/home/view_model/home_state.dart';
import 'package:skill_swap/home/view_model/home_view_model.dart';
import 'package:skill_swap/requests/data/models/friend_request_model.dart';
import 'package:skill_swap/requests/view_model.dart/friend_requst_cubit.dart';
import 'package:skill_swap/requests/view_model.dart/friend_requsts_state.dart';
import 'package:skill_swap/user_profile/data/models/user_profile_model.dart';
import 'package:skill_swap/user_profile/views/screens/profile.dart';

class HomeTap extends StatefulWidget {
  const HomeTap({super.key});

  @override
  State<HomeTap> createState() => _HomeTapState();
}

class _HomeTapState extends State<HomeTap> {
  // Track users with pending requests
  Map<String, bool> sentRequestsMap = {};
  
  @override
  void initState() {
    super.initState();
    context.read<HomeViewModel>().getHomeUsers();
    _loadSentRequests();
  }
  
  // Load sent friend requests to keep track of which users already have pending requests
  void _loadSentRequests() async {
    final cubit = context.read<FriendRequestsCubit>();
    await cubit.getSentFriendRequests();
    
    // Listen for ALL changes in friend requests state to keep button state in sync
    cubit.stream.listen((state) {
      if (state is SentFriendRequestsSuccess) {
        // Update our local map of sent requests when the state changes
        setState(() {
          sentRequestsMap = {}; // Clear existing map
          // Rebuild the map with current requests
          for (var request in state.list) {
            sentRequestsMap[request.receiverId] = true;
          }
        });
      } else if (state is SentFriendRequestsEmpty) {
        // Clear the map if there are no sent requests
        setState(() {
          sentRequestsMap = {};
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: BlocConsumer<HomeViewModel, HomeState>(
              listener: (context, state) {
                if (state is HomeErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is HomeLoadingState) {
                  return Skeletonizer(
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder:
                          (_, index) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: AccountCard(
                              user: UserProfileModel(
                                name: "Anonymous",
                                bio: 'No bio available',
                                offeredSkills: [],
                                wantedSkills: [],
                              ),
                              onPressed: () {},
                            ),
                          ),
                    ),
                  );
                } else if (state is HomeSuccessState) {
                  // Make sure we have a valid list of users
                  final safeUsers = state.users;
                  
                  return ListView.builder(
                    itemCount: safeUsers.length,
                    itemBuilder: (_, index) {
                      final user = safeUsers[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Profile.routeName,
                              arguments: user,
                            );
                          },
                          child: AccountCard(
                            user: user,
                            // Pass sentRequestsMap status to show the appropriate button state
                            isRequestSent: sentRequestsMap.containsKey(user.userDetailId),
                            onPressed: () async {
                              if (sentRequestsMap.containsKey(user.userDetailId)) {
                                // If request exists, cancel it
                                // Find the request to cancel
                                final friendRequestsCubit = context.read<FriendRequestsCubit>();
                                await friendRequestsCubit.getSentFriendRequests();
                                final state = friendRequestsCubit.state;
                                
                                if (state is SentFriendRequestsSuccess) {
                                  // Find the request with matching receiverId
                                  FriendRequestModel? request;
                                  try {
                                    request = state.list.firstWhere(
                                      (req) => req.receiverId == user.userDetailId,
                                    );
                                  } catch (e) {
                                    // No matching request found
                                    request = null;
                                  }
                                  
                                  if (request != null) {
                                    await friendRequestsCubit.declineFriendRequest(request);
                                    setState(() {
                                      sentRequestsMap.remove(user.userDetailId);
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Friend request cancelled'),
                                        backgroundColor: Colors.orange,
                                      ),
                                    );
                                  }
                                }
                              } else {
                                // Send new request
                                final success = await context
                                    .read<FriendRequestsCubit>()
                                    .addFriend(user);
                                    
                                if (success) {
                                  setState(() {
                                    sentRequestsMap[user.userDetailId] = true;
                                  });
                                }
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      success
                                          ? 'Friend request sent successfully'
                                          : 'Failed to send friend request',
                                    ),
                                    backgroundColor:
                                        success ? Colors.green : Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is HomeEmptyState) {
                  return Center(
                    child: Text(
                      'No users found!',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
      ],
    );
  }
}
