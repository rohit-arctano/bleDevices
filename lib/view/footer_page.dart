import 'package:bldevice_connection/constant/colors_const.dart';
import 'package:bldevice_connection/view/dashboard/homepage.dart';
import 'package:bldevice_connection/view/dashboard/places.dart';
import 'package:bldevice_connection/view/dashboard/profile_page.dart';
import 'package:bldevice_connection/view/dashboard/spaces.dart';
import 'package:flutter/material.dart';

class Footer extends StatefulWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  // List<DrawerCategory> list = [];
  Widget currentPage = const Footer();
  final tabs = [
    const HomePage(),
    const Spaces(),
    const ProfilePage(),
  ];

  int _selectedIndex = 0;

  void _selectTab(Widget tabItem, int index) {
    setState(() {
      currentPage = tabs[index];
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          tabs[_selectedIndex],
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: BottomNavigationBar(
          selectedLabelStyle: const TextStyle(fontSize: 10),
          unselectedFontSize: 9,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 18),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.space_bar, size: 18),
              label: 'Space',
            ),
         
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 18),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: kPrimaryColor,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          onTap: (int index) {
            _selectTab(tabs[index], index);
          },
        ),
      ),
    );
  }
}
