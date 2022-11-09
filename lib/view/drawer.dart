import 'package:bldevice_connection/constant/textstyle_constant.dart';
import 'package:bldevice_connection/constant/widget.dart';
import 'package:bldevice_connection/model/fb_user.dart';
import 'package:bldevice_connection/shared_preferences/shared_preferences.dart';
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
                  child: Image.asset('assets/images/arctanoLogoFull.png',
                      width: 60, height: 45, fit: BoxFit.fill),
                ),
                // currentAccountPictureSize: const Size.square(30.0),
              );
            }),
        const SizedBox(
          height: 60,
        ),
        const DivideLine(),
        const ListTile(
          leading: Icon(Icons.home),
          title: Text(
            "Home",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        const DivideLine(),
        const ListTile(
          leading: Icon(Icons.comment),
          title: Text(
            "About us",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        const DivideLine(),
        const ListTile(
          leading: Icon(Icons.phone),
          title: Text(
            "Contact us",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        const DivideLine(),
        const ListTile(
          leading: Icon(Icons.share),
          title: Text(
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

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              color: Colors.black,
            ),
          ),
          title: const Text("LogOut"),
        ),
        Spacer(),
        Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: kWhiteColor.withOpacity(0.2)),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Arctano Switch", style: kLTextStyle),
                ],
              ),
              const Text("v 1.0", style: kLTextStyle)
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
