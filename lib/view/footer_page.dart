import 'package:bldevice_connection/constant/widget.dart';
import 'package:bldevice_connection/view/dashboard/homepage.dart';
import 'package:bldevice_connection/view/dashboard/spaces.dart';
import 'package:flutter/material.dart';

import 'drawer.dart';

class Footer extends StatefulWidget {
  dynamic currentTab;
  RouteArgument? routeArgument;
  Footer({this.currentTab, Key? key}) : super(key: key) {
    if (currentTab != null) {
      if (currentTab is RouteArgument) {
        routeArgument = currentTab;
        currentTab = int.parse(currentTab.id);
      }
    } else {
      currentTab = 0;
    }
  }

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  // List<DrawerCategory> list = [];
  Widget currentPage = Footer();
  final tabs = [
    const HomePage(),
    const Spaces(),
    // const ProfilePage(),
  ];

  int _selectedIndex = 0;

  void _selectTab(Widget tabItem, int index) {
    setState(() {
      currentPage = tabs[index];
      _selectedIndex = index;
    });
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const Drawer(child: DrawerScreen()),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                      child: const Icon(
                        Icons.menu,
                        color: kBlackColor,
                        size: 30,
                      ),
                      onTap: () {
                        scaffoldKey.currentState?.openDrawer();
                      }),
                  const Text(
                    "Hello! \nGood morning ${"Buddy"}",
                    style: kBXLTextStyle,
                  ),
                  CircleAvatar(
                    radius: 35.0,
                    backgroundColor: Colors.transparent,
                    child: Image.asset(
                      'assets/images/arctanoLogoFull.png',
                    ),
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.78,
                child: Stack(
                  children: [
                    tabs[_selectedIndex],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: BottomNavigationBar(
          selectedLabelStyle: const TextStyle(fontSize: 14),
          unselectedFontSize: 13,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 25),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings, size: 25),
              label: 'Setting',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.person, size: 25),
            //   label: 'Profile',
            // ),
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

class RouteArgument {
  String? id;
  String? heroTag;
  dynamic param;

  RouteArgument({this.id, this.heroTag, this.param});

  @override
  String toString() {
    return '{id: $id, heroTag:${heroTag.toString()}}';
  }
}
