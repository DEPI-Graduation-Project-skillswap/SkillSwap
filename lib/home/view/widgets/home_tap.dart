import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skill_swap/home/view/widgets/account_card.dart';
import 'package:skill_swap/home/view_model/home_state.dart';
import 'package:skill_swap/home/view_model/home_view_model.dart';
import 'package:skill_swap/requests/view_model.dart/friend_requst_cubit.dart';
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
    context.read<HomeViewModel>().getHomeUsers();
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
                                name: " ",
                                bio: '',
                                offeredSkills: [],
                                wantedSkills: [],
                              ),
                              onPressed: () {},
                            ),
                          ),
                    ),
                  );
                } else if (state is HomeSuccessState) {
                  return ListView.builder(
                    itemCount: state.users.length,
                    itemBuilder: (_, index) {
                      final user = state.users[index];
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
                            onPressed: () async {
                              final success = await context
                                  .read<FriendRequestsCubit>()
                                  .addFriend(user);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success
                                        ? 'Friend added successfully'
                                        : 'Failed to add friend',
                                  ),
                                  backgroundColor:
                                      success ? Colors.green : Colors.red,
                                ),
                              );
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
