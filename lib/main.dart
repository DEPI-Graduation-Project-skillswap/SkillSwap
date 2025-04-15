import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/app_theme.dart';
import 'package:skill_swap/auth/view/screens/login_screen.dart';
import 'package:skill_swap/auth/view/screens/register_screen.dart';
import 'package:skill_swap/auth/view/screens/verfication_screen.dart';

import 'package:skill_swap/auth/view_model/auth_view_model.dart';
import 'package:skill_swap/firebase_options.dart';
import 'package:skill_swap/home/home_screen.dart';
import 'package:skill_swap/landing/landing_page1.dart';
import 'package:skill_swap/landing/landing_page2.dart';
import 'package:skill_swap/landing/landing_page3.dart';
import 'package:skill_swap/profile/views/profile_page.dart';
import 'package:skill_swap/profile/views/profile_setup_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    BlocProvider(create: (context) => AuthViewModel(), child: const MyApp()),
  );
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
        ProfileSetupPage.routeName: (_) => const ProfileSetupPage(),
        ProfilePage.routeName: (_) => ProfilePage(),
      },
      initialRoute: LoginScreen.routeName,
      darkTheme: Apptheme.darkTheme,
      theme: Apptheme.lightTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
    );
  }
}
