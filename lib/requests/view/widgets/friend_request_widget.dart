import 'package:flutter/material.dart';
import 'package:skill_swap/requests/data/models/friend_request_model.dart';
import 'package:skill_swap/shared/app_theme.dart';
import 'package:skill_swap/widgets/default_eleveted_botton.dart';

class FriendRequestWidget extends StatelessWidget {
  const FriendRequestWidget({
    super.key,
    required this.friendRequestModel,
    required this.onAcceptPressed,
    required this.onDeclinePressed,
    this.isOutgoing = false,
  });
  final FriendRequestModel? friendRequestModel;
  final VoidCallback onAcceptPressed;
  final VoidCallback onDeclinePressed;
  final bool isOutgoing;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/images/account_image.png'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      friendRequestModel != null
                          ? friendRequestModel!.name
                          : 'xxxxxxxxxxxxxx',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      friendRequestModel != null
                          ? friendRequestModel!.bio
                          : 'xxxxxxxxxxxxxxxxxxxxxx',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          isOutgoing
              ? DefaultElevatedButton(
                onPressed: onDeclinePressed,
                text: 'Cancel request',
                backGroundColor: Apptheme.red,
              )
              : Row(
                children: [
                  Expanded(
                    child: DefaultElevatedButton(
                      onPressed: onAcceptPressed,
                      text: 'Accept',
                      backGroundColor: Apptheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DefaultElevatedButton(
                      onPressed: onDeclinePressed,
                      text: "Decline",
                      backGroundColor: Apptheme.red,
                    ),
                  ),
                ],
              ),
        ],
      ),
    );
  }
}
