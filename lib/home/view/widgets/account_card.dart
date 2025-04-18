import 'package:flutter/material.dart';
import 'package:skill_swap/home/view/widgets/account_cart_eleveted_bottom.dart';
import 'package:skill_swap/shared/app_theme.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 300,
      decoration: BoxDecoration(
        color: Apptheme.gray,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/images/account_image.png', fit: BoxFit.fill),

          Center(
            child: Text(
              'Account Name',
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(fontSize: 20),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Flutter , Dart',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              AccountCartElevetedBottom(
                text: 'Requset Skill',
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
