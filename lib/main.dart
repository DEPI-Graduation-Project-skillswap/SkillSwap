import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

// --- Import App Modules ---
import 'package:skill_swap/auth/view/screens/login_screen.dart';
import 'package:skill_swap/auth/view/screens/register_screen.dart';
import 'package:skill_swap/auth/view/screens/verfication_screen.dart';
import 'package:skill_swap/auth/view_model/auth_view_model.dart';
import 'package:skill_swap/home/view_model/home_view_model.dart';
import 'package:skill_swap/home_screen.dart';
import 'package:skill_swap/landing/landing_page1.dart';
import 'package:skill_swap/landing/landing_page2.dart';
import 'package:skill_swap/landing/landing_page3.dart';
import 'package:skill_swap/requests/data/data_source/friend_request_firebase_data_source.dart';
import 'package:skill_swap/requests/data/repisatory/friends_requests_repisatory.dart';
import 'package:skill_swap/settings/view_model/settings_provider.dart';
import 'package:skill_swap/shared/app_theme.dart';
import 'package:skill_swap/shared/firebase_options.dart';
import 'package:skill_swap/user_profile/view_model/user_profile_setup_view_model.dart';
import 'package:skill_swap/user_profile/views/screens/profile.dart';
import 'package:skill_swap/user_profile/views/screens/user_profile_setup.dart';

// --- Import Friend Request Dependencies ---
import 'package:skill_swap/requests/data/data_source/friend_requests_data_source.dart'; // Abstract data source (optional but good practice)
import 'package:skill_swap/requests/view_model.dart/friend_requst_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // --- Instantiate Dependencies Needed for Providers ---
  // Instantiate dependencies for FriendRequestsCubit
  final FriendRequestsDataSource friendRequestsDataSource =
      FriendRequestFirebaseDataSource();
  // Ensure the class name 'FriendsRequestsRepository' matches your file exactly (potential typo 'reposetory'?)
  final FriendsRequestsRepository friendRequestsRepository =
      FriendsRequestsRepository(
        friendRequestsDataSource: friendRequestsDataSource,
      );
  // Instantiate dependencies for HomeViewModel if needed (using ServerLocator example if you have one)
  // final homeRepository = HomeRepository(homeDataSource: ServerLocator.homeDataSource);

  runApp(
    MultiProvider(
      providers: [
        BlocProvider(create: (context) => AuthViewModel()),
        // If HomeViewModel needs dependencies, provide them here
        BlocProvider(
          create:
              (context) => HomeViewModel(/* pass homeRepository if needed */),
        ),
        // *** FIX HERE: Provide the repository to FriendRequestsCubit ***
        BlocProvider(
          create:
              (context) => FriendRequestsCubit(
                friendRequestsRepository,
              ), // Pass the instantiated repository
        ),
        ChangeNotifierProvider(
          create: (context) => UserProfileSetupViewModel(),
        ),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
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
      initialRoute: LoginScreen.routeName,
      darkTheme: Apptheme.darkTheme,
      theme: Apptheme.lightTheme,
      // themeMode: ThemeMode.light, // You can control this via SettingsProvider later
      themeMode:
          Provider.of<SettingsProvider>(
            context,
          ).themeMode, // Example using provider
      debugShowCheckedModeBanner: false,
    );
  }
}
