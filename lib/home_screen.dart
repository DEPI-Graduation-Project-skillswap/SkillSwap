import 'package:flutter/material.dart';
import 'package:skill_swap/home/view/widgets/home_tap.dart';
import 'package:skill_swap/requests/requests_tap.dart';
import 'package:skill_swap/search/search_tap.dart';
import 'package:skill_swap/settings/settings_tap.dart';

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
        title: Text('SkillSwap', style: Theme.of(context).textTheme.titleLarge),
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
// bottomNavigationBar: BottomAppBar(
//         shape: CircularNotchedRectangle(),
//         notchMargin: 10,
//         color: Appthem.white,
//         padding: EdgeInsets.all(0),
//         clipBehavior: Clip.antiAliasWithSaveLayer,
//         child: BottomNavigationBar(
//             items: [
//               BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
//               BottomNavigationBarItem(
//                   icon: Icon(Icons.settings), label: 'Settings'),
//             ],
//             elevation: 0,
//             currentIndex: selectedIndex,
//             onTap: (index) {
//               setState(() {
//                 selectedIndex = index;
//               });
//             }),
//       ),