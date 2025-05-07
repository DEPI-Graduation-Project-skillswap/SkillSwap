import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skill_swap/requests/view/widgets/friend_request_widget.dart';
import 'package:skill_swap/requests/view_model.dart/friend_requst_cubit.dart';
import 'package:skill_swap/requests/view_model.dart/friend_requsts_state.dart';
import 'package:skill_swap/shared/app_theme.dart';
import 'package:skill_swap/shared/ui_utils.dart';

class RequestsTap extends StatefulWidget {
  const RequestsTap({super.key});

  @override
  State<RequestsTap> createState() => _RequestsTapState();
}

class _RequestsTapState extends State<RequestsTap> {
  String selectedTab = 'Incoming';

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  void _fetchRequests() {
    final cubit = context.read<FriendRequestsCubit>();
    if (selectedTab == 'Incoming') {
      cubit.getReceivedFriendRequests();
    } else {
      cubit.getSentFriendRequests();
    }
  }

  void _switchTab(String tab) {
    if (selectedTab != tab) {
      setState(() {
        selectedTab = tab;
        _fetchRequests();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            "Friend Requests",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () => _switchTab('Incoming'),
                child: Text(
                  'Incoming',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color:
                        selectedTab == 'Incoming'
                            ? Apptheme.primaryColor
                            : null,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _switchTab('Outgoing'),
                child: Text(
                  'Outgoing',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color:
                        selectedTab == 'Outgoing'
                            ? Apptheme.primaryColor
                            : null,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: BlocListener<FriendRequestsCubit, FriendRequestsState>(
              listener: (context, state) {
                if (state is ReceivedFriendRequestsError ||
                    state is SentFriendRequestsError) {
                  UiUtils.showSnackBar(context, "Something went wrong");
                }
              },
              child: BlocBuilder<FriendRequestsCubit, FriendRequestsState>(
                builder: (_, state) {
                  if (state is ReceivedFriendRequestsLoading ||
                      state is SentFriendRequestsLoading) {
                    return Skeletonizer(
                      child: ListView.separated(
                        itemBuilder:
                            (_, index) => FriendRequestWidget(
                              friendRequestModel: null,
                              onAcceptPressed: () {},
                              onDeclinePressed: () {},
                            ),
                        separatorBuilder:
                            (_, index) => const SizedBox(height: 20),
                        itemCount: 8,
                      ),
                    );
                  } else if (state is ReceivedFriendRequestsEmpty ||
                      state is SentFriendRequestsEmpty) {
                    return Center(
                      child: Text(
                        'There are no friend requests',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    );
                  } else if (state is ReceivedFriendRequestsSuccess &&
                      selectedTab == 'Incoming') {
                    return ListView.separated(
                      itemBuilder: (_, index) {
                        final request = state.list[index];
                        return FriendRequestWidget(
                          friendRequestModel: request,
                          onAcceptPressed: () async {
                            await context
                                .read<FriendRequestsCubit>()
                                .acceptFriendRequest(request);
                            UiUtils.showSnackBar(
                              context,
                              color: Apptheme.primaryColor,
                              "Friend request accepted    ",
                            );
                            await context
                                .read<FriendRequestsCubit>()
                                .getReceivedFriendRequests();
                          },
                          onDeclinePressed: () async {
                            await context
                                .read<FriendRequestsCubit>()
                                .declineFriendRequest(request);
                            UiUtils.showSnackBar(
                              context,
                              "Friend request declined",
                            );
                            await context
                                .read<FriendRequestsCubit>()
                                .getReceivedFriendRequests();
                          },
                        );
                      },
                      separatorBuilder:
                          (_, index) => const SizedBox(height: 20),
                      itemCount: state.list.length,
                    );
                  } else if (state is SentFriendRequestsSuccess &&
                      selectedTab == 'Outgoing') {
                    return ListView.separated(
                      itemBuilder: (_, index) {
                        final request = state.list[index];
                        return FriendRequestWidget(
                          friendRequestModel: request,
                          onAcceptPressed: () {},
                          onDeclinePressed: () async {
                            await context
                                .read<FriendRequestsCubit>()
                                .declineFriendRequest(request);
                            UiUtils.showSnackBar(context, "Request canceled");
                            await context
                                .read<FriendRequestsCubit>()
                                .getReceivedFriendRequests();
                          },
                          isOutgoing: true,
                        );
                      },
                      separatorBuilder:
                          (_, index) => const SizedBox(height: 20),
                      itemCount: state.list.length,
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
