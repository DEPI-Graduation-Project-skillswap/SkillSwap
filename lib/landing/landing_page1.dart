import 'package:flutter/material.dart';
import 'package:skill_swap/app_theme.dart';
import 'package:skill_swap/home/home_screen.dart';
import 'package:skill_swap/landing/landing_page2.dart';

import 'package:skill_swap/widgets/default_eleveted_botton.dart';

class LandingPage1 extends StatelessWidget {
  static const String routeName = '/landing_page1';
  const LandingPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 150),
              Image.asset('assets/images/landing_page1_photo.png'),
              SizedBox(height: 10),
              Text(
                'Learn Something New',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'Exchange skills instead of money',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: Apptheme.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: Apptheme.gray,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: Apptheme.gray,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pushReplacementNamed(HomeScreen.routeName);
                    },
                    child: Text(
                      'Skip',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: DefaultElevetedBotton(
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pushReplacementNamed(LandingPage2.routeName);
                      },
                      text: "Next",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
