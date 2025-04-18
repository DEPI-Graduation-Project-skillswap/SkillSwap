import 'package:flutter/material.dart';
import 'package:skill_swap/home/view/widgets/account_card.dart';

class HomeTap extends StatefulWidget {
  const HomeTap({super.key});

  @override
  State<HomeTap> createState() => _HomeTapState();
}

class _HomeTapState extends State<HomeTap> {
  List<Widget> accounts = List.generate(10, (index) => AccountCard());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15),

            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return accounts[index];
              },
              itemCount: accounts.length,
            ),
          ),
        ),
      ],
    );
  }
}
