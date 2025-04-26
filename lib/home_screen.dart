import 'package:flutter/material.dart';
import 'package:skill_swap/home/view/widgets/home_tap.dart';
import 'package:skill_swap/requests/requests_tap.dart';
import 'package:skill_swap/search/search_tap.dart';
import 'package:skill_swap/settings/settings_tap.dart';
import 'package:skill_swap/shared/app_theme.dart';
import 'package:skill_swap/user_profile/views/screens/profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> taps = [HomeTap(), SearchTap(), RequestsTap(), SettingsTap()];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsetsDirectional.only(start: 20),
          child: Text(
            'SkillSwap',
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(color: Apptheme.primaryColor),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, size: 30),
            onPressed: () {},
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.chat_outlined, size: 30),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(end: 20, start: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Profile.routeName);
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/account_image.png'),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          selectedIndex = index;
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_add_outlined),
            label: 'Requests',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
      body: taps[selectedIndex],
    );
  }
}
