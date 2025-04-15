import 'package:flutter/material.dart';
import 'package:skill_swap/profile/views/profile_setup_page.dart';
import 'package:skill_swap/profile/views/profile_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home', style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to the Home Screen',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, ProfileSetupPage.routeName);
              },
              child: const Text('Go to Profile Setup'),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, ProfilePage.routeName);
              },
              child: const Text('Go to My Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
