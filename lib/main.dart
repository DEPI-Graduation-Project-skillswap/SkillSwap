import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:skill_swap/shared/app_theme.dart';
import 'package:skill_swap/auth/view/screens/login_screen.dart';
import 'package:skill_swap/auth/view/screens/register_screen.dart';
import 'package:skill_swap/auth/view/screens/verfication_screen.dart';

import 'package:skill_swap/auth/view_model/auth_view_model.dart';
import 'package:skill_swap/shared/firebase_options.dart';
import 'package:skill_swap/home_screen.dart';
import 'package:skill_swap/landing/landing_page1.dart';
import 'package:skill_swap/landing/landing_page2.dart';
import 'package:skill_swap/landing/landing_page3.dart';
import 'package:skill_swap/user_profile/view_model/user_profile_setup_view_model.dart';
import 'package:skill_swap/user_profile/views/screens/profile.dart';

import 'package:skill_swap/user_profile/views/screens/user_profile_setup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        BlocProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(
          create: (context) => UserProfileSetupViewModel(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        Profile.routeName: (_) => const Profile(),
        UserProfileSetup.routeName: (_) => const UserProfileSetup(),
      },
      initialRoute: HomeScreen.routeName,
      darkTheme: Apptheme.darkTheme,
      theme: Apptheme.lightTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
    );
  }
}
