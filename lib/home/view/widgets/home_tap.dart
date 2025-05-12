import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skill_swap/home/view/widgets/account_card.dart';
import 'package:skill_swap/home/view_model/home_state.dart';
import 'package:skill_swap/home/view_model/home_view_model.dart';
import 'package:skill_swap/requests/view_model.dart/friend_requst_cubit.dart';
// Import the state definition for FriendRequestsCubit if needed for type checks
import 'package:skill_swap/requests/view_model.dart/friend_requsts_state.dart';
import 'package:skill_swap/user_profile/data/models/user_profile_model.dart';
import 'package:skill_swap/user_profile/views/screens/profile.dart';

class HomeTap extends StatefulWidget {
  const HomeTap({super.key});

  @override
  State<HomeTap> createState() => _HomeTapState();
}

class _HomeTapState extends State<HomeTap> {
  @override
  void initState() {
    super.initState();
    // Load home users
    context.read<HomeViewModel>().getHomeUsers();
    // Also load the sent friend requests to know the status for buttons
    context.read<FriendRequestsCubit>().getSentFriendRequests();
  }

  @override
  Widget build(BuildContext context) {
    // Get the cubit instance - needed for checking pending status
    final friendRequestCubit = context.read<FriendRequestsCubit>();

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15),
            // Listen to FriendRequestsCubit state changes as well, so UI updates
            // when a request is sent/cancelled elsewhere.
            child: BlocBuilder<FriendRequestsCubit, FriendRequestsState>(
              builder: (context, requestState) {
                // Now build based on HomeViewModel state
                return BlocConsumer<HomeViewModel, HomeState>(
                  listener: (context, homeState) {
                    if (homeState is HomeErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(homeState.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, homeState) {
                    if (homeState is HomeLoadingState) {
                      // Provide dummy data and required args for Skeletonizer's AccountCard
                      final dummyUser = UserProfileModel(
                        name: " ",
                        bio: '',
                        offeredSkills: [],
                        wantedSkills: [],
                      );
                      return Skeletonizer(
                        child: ListView.builder(
                          itemCount: 5, // Adjust skeleton count as needed
                          itemBuilder:
                              (_, index) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: AccountCard(
                                  user: dummyUser,
                                  onPressed: null, // Disable button in skeleton
                                  isRequestPending: false, // Required argument
                                ),
                              ),
                        ),
                      );
                    } else if (homeState is HomeSuccessState) {
                      return ListView.builder(
                        itemCount: homeState.users.length,
                        itemBuilder: (_, index) {
                          final user = homeState.users[index];

                          // *** Determine the pending status for this user ***
                          bool isPending = false;
                          // Use the helper method from the cubit instance
                          isPending = friendRequestCubit.isRequestSentTo(
                            user.userDetailId,
                          );

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
                                // *** Pass the required argument ***
                                isRequestPending: isPending,
                                onPressed: () async {
                                  // Prevent action if request is already pending
                                  if (isPending) return;

                                  final success = await friendRequestCubit
                                      .addFriend(user);

                                  // Check if the widget is still mounted before showing SnackBar
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          success
                                              ? 'Friend request sent successfully'
                                              : 'Failed to send friend request', // Or provide more specific error from cubit if needed
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
                    } else if (homeState is HomeEmptyState) {
                      return Center(
                        child: Text(
                          'No users found matching your criteria!', // Updated text
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    // Default case or other states (e.g., initial)
                    return const Center(child: CircularProgressIndicator());
                  },
                );
              }, // End of FriendRequestsCubit BlocBuilder
            ),
          ),
        ),
      ],
    );
  }
}
