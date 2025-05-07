import 'package:flutter/material.dart';
import 'package:skill_swap/home/view/widgets/account_cart_eleveted_bottom.dart';
import 'package:skill_swap/user_profile/data/models/user_profile_model.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({super.key, required this.user, required this.onPressed});
  final VoidCallback? onPressed;
  final UserProfileModel user;
  @override
  Widget build(BuildContext context) {
    final skills = user.offeredSkills ?? [];
    final showMore = skills.length > 4;
    final displayedSkills = showMore ? skills.take(3).toList() : skills;

    return Container(
      height: 390,
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 201,
              width: double.infinity,
              child: Image.asset(
                'assets/images/account_image.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                user.name ?? '',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(fontSize: 20),
              ),
              Text(
                user.bio ?? '',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.black54,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),

          const SizedBox(height: 4),
          Text(
            "Offered Skills:",
            style: Theme.of(
              context,
            ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              ...displayedSkills.map(
                (skill) => Chip(
                  label: Text(skill),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.black12),
                  ),
                ),
              ),
              if (showMore)
                Chip(
                  label: const Text("more..."),
                  backgroundColor: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.black12),
                  ),
                ),
            ],
          ),
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: AccountCartElevetedBottom(
              text: 'Add Friend',
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    );
  }
}
