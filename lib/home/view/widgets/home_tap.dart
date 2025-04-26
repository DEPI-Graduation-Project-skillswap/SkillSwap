import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skill_swap/home/view/widgets/account_card.dart';
import 'package:skill_swap/home/view_model/home_state.dart';
import 'package:skill_swap/home/view_model/home_view_model.dart';
import 'package:skill_swap/user_profile/data/models/user_profile_model.dart';
import 'package:skill_swap/user_profile/views/screens/profile.dart';

class HomeTap extends StatefulWidget {
  const HomeTap({super.key});

  @override
  State<HomeTap> createState() => _HomeTapState();
}

class _HomeTapState extends State<HomeTap> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: BlocProvider(
              create: (_) => HomeViewModel(),

              child: BlocBuilder<HomeViewModel, HomeState>(
                builder: (_, state) {
                  if (state is HomeLoadingState) {
                    return Skeletonizer(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: AccountCard(
                              userProfileModel: UserProfileModel(
                                name: "name index",
                                bio: " flutter is awesome",
                                offeredSkills: [
                                  "flutter",
                                  "dart",
                                  "firebase",
                                  "firebase",
                                  "firebase",
                                ],
                                wantedSkills: [],
                              ),
                            ),
                          );
                        },
                        itemCount: 10,
                      ),
                    );
                  } else if (state is HomeSuccessState) {
                    return ListView.builder(
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Profile.routeName,
                                arguments: state.users[index],
                              );
                            },
                            child: AccountCard(
                              userProfileModel: state.users[index],
                            ),
                          ),
                        );
                      },
                      itemCount: state.users.length,
                    );
                  } else if (state is HomeErrorState) {
                    return Center(child: Text(state.message));
                  }
                  return SizedBox();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
