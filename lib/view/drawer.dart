import 'dart:convert';

import 'package:bldevice_connection/constant/widget.dart';
import 'package:bldevice_connection/model/fb_user.dart';
import 'package:bldevice_connection/shared_preferences/shared_preferences.dart';
import 'package:bldevice_connection/view/dashboard/profile_page.dart';
import 'package:bldevice_connection/widget/widget.dart';
import 'dashboard/drawer_item/aboutus_page.dart';
import 'dashboard/drawer_item/contactus_page.dart';
import 'widget_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});
  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  FbUser? userData;
  final auth = FirebaseAuth.instance;
  User? user;
  Future getData() async {
    user = auth.currentUser;
    userData = await SavePreferences().getUserData();
  }

  Future updateUsername(String newName) async {
    FbUser editName = FbUser(
        uid: user!.uid, email: user!.email ?? "", name: newName, mobileNo: "");
    String encodedMap = jsonEncode(editName.toJson());
    await user?.updateDisplayName(newName);
    await SavePreferences().setUserData(data: encodedMap);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
              decoration: const BoxDecoration(
                color: kDarkGreyColor,
              ),
              child: Row(
                children: [
                  FutureBuilder(
                      future: getData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Row(
                            children: [
                              SizedBox(
                                child: DecoratedBox(
                                  decoration: const BoxDecoration(
                                      color: kl2, shape: BoxShape.circle),
                                  child: FittedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Image.asset(
                                        logoImage,
                                        height: 70,
                                        width: 70,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Row(
                                children: [
                                  Text(
                                    user?.displayName!.toUpperCase() ??
                                        "No user Found",
                                    style: kWDXLTextStyle,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        String userName = await Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              opaque: false,
                                              pageBuilder: (context, __, _) =>
                                                  PopUpTemplate(
                                                hintText: "Edit your Name",
                                              ),
                                            ));
                                        print("the  newuser name is $userName");
                                        await updateUsername(userName);
                                      },
                                      icon: const Icon(Icons.edit))
                                ],
                              )
                            ],
                          );
                        } else {
                          return const Loader();
                        }
                      }),
                ],
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            const DivideLine(),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Footer(currentTab: 0)));
              },
              leading: const Icon(Icons.home),
              title: const Text(
                "Home",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            const DivideLine(),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()));
              },
              leading: const Icon(Icons.person),
              title: const Text(
                "Profile",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            const DivideLine(),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AboutUs()));
              },
              leading: const Icon(Icons.comment),
              title: const Text(
                "About us",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            const DivideLine(),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ContactUs()));
              },
              leading: const Icon(Icons.phone),
              title: const Text(
                "Contact us",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            const DivideLine(),
            ListTile(
              onTap: () {
                // Share.share(
                //     'https://play.google.com/store/apps/details?id=com.quickplayers.quickplayers');
              },
              leading: const Icon(Icons.share),
              title: const Text(
                "Share the App",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            const DivideLine(),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey,
                child: IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    // await getData();
                    await SavePreferences().logOut();
                    await FirebaseAuth.instance.signOut();

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  color: Colors.black,
                ),
              ),
              title: const Text("LogOut"),
            ),
            const Spacer(),
            Column(
              children: const [
                Text("Arctano Switch", style: kMediumTextStyle),
                const Text("v 1.0", style: kMediumTextStyle)
              ],
            ),
          ],
        ));
  }
}

class DivideLine extends StatelessWidget {
  const DivideLine({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: Colors.grey[300],
    );
  }
}
