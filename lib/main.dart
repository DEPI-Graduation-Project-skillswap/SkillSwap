import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:skill_swap/home/view_model/home_view_model.dart';
import 'package:skill_swap/requests/view_model.dart/friend_requst_cubit.dart';
import 'package:skill_swap/settings/view_model/settings_provider.dart';
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
import 'package:skill_swap/chat/view/screens/chat_list_screen.dart';
import 'package:skill_swap/chat/view/screens/chat_conversation_screen.dart';
import 'package:skill_swap/notifications/view/screens/notification_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        BlocProvider(create: (context) => AuthViewModel()),
        BlocProvider(create: (context) => HomeViewModel()),
        BlocProvider(create: (context) => FriendRequestsCubit()),
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
      debugShowCheckedModeBanner: false,

      onGenerateRoute: (settings) {
        if (settings.name == HomeScreen.routeName) {
          final tabIndex = settings.arguments as int?;
          return MaterialPageRoute(
            builder: (context) => HomeScreen(initialTabIndex: tabIndex),
          );
        }
        return null;
      },
      routes: {
        LandingPage1.routeName: (_) => const LandingPage1(),
        RegisterScreen.routeName: (_) => const RegisterScreen(),
        LoginScreen.routeName: (_) => LoginScreen(),
        VerficationScreen.routeName: (_) => VerficationScreen(),
        LandingPage2.routeName: (_) => const LandingPage2(),
        LandingPage3.routeName: (_) => const LandingPage3(),
        Profile.routeName: (_) => const Profile(),
        UserProfileSetup.routeName: (_) => const UserProfileSetup(),
        ChatListScreen.routeName: (_) => const ChatListScreen(),
        NotificationScreen.routeName: (_) => const NotificationScreen(),
        ChatConversationScreen.routeName: (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          return ChatConversationScreen(
            conversationId: args['conversationId'] ?? '',
            otherUserId: args['otherUserId'] ?? '',
            otherUserName: args['otherUserName'] ?? 'Chat',
          );
        },
      },
      initialRoute: LoginScreen.routeName,

      darkTheme: Apptheme.darkTheme,
      theme: Apptheme.lightTheme,
      themeMode: ThemeMode.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(Provider.of<SettingsProvider>(context).languageCode),
    );
  }
}
