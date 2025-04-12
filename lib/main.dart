import 'package:flutter/material.dart';
import 'package:skill_swap/app_theme.dart';
import 'package:skill_swap/auth/login_screen.dart';
import 'package:skill_swap/auth/register_screen.dart';
import 'package:skill_swap/auth/verfication_screen.dart';
import 'package:skill_swap/home/home_screen.dart';
import 'package:skill_swap/landing/landing_page1.dart';
import 'package:skill_swap/landing/landing_page2.dart';
import 'package:skill_swap/landing/landing_page3.dart';
import 'package:skill_swap/profile/profile_setup_page.dart'; // Import the profile page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        LandingPage1.routeName: (_) => const LandingPage1(),
        RegisterScreen.routeName: (_) => const RegisterScreen(),
        LoginScreen.routeName: (_) => LoginScreen(),
        VerficationScreen.routeName: (_) => VerficationScreen(),
        HomeScreen.routeName: (_) => const HomeScreen(),
        LandingPage2.routeName: (_) => const LandingPage2(),
        LandingPage3.routeName: (_) => const LandingPage3(),
        ProfileSetupPage.routeName:
            (_) => const ProfileSetupPage(), 
      },
      initialRoute:
          ProfileSetupPage.routeName, 
      darkTheme: Apptheme.darkTheme,
      theme: Apptheme.lightTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
    );
  }
}
