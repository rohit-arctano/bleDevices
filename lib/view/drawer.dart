import 'package:bldevice_connection/constant/widget.dart';
import 'package:bldevice_connection/model/fb_user.dart';
import 'package:bldevice_connection/shared_preferences/shared_preferences.dart';
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
  Future getData() async {
    userData = await SavePreferences().getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              return UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: kDarkGreyColor,
                ),
                accountName: Text(
                  userData?.name.toUpperCase() ?? "Profile",
                  style: kWBXLTextStyle,
                ),
                accountEmail: Text(
                  userData?.email ?? "Profile",
                  style: kWLTextStyle,
                ),
                currentAccountPicture: CircleAvatar(
                  radius: 70,
                  backgroundColor: kl2,
                  child: Image.asset(logoImage,
                      width: 60, height: 45, fit: BoxFit.fill),
                ),
                // currentAccountPictureSize: const Size.square(30.0),
              );
            }),
        const SizedBox(
          height: 60,
        ),
        const DivideLine(),
        ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Footer(currentTab: 0)));
          },
          leading: const Icon(Icons.home),
          title: const Text(
            "Home",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
        Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: kWhiteColor.withOpacity(0.2)),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Arctano Switch", style: kMediumTextStyle),
                ],
              ),
              const Text("v 1.0", style: kMediumTextStyle)
            ],
          ),
        ),
      ]),
    );
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
