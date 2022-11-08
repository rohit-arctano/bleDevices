import 'package:bldevice_connection/constant/textstyle_constant.dart';
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 40.0, 0.0, 0.0),
        child: ListView(padding: EdgeInsets.zero, children: [
          FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                return ListTile(
                  title: Text(
                    userData?.name.toUpperCase() ?? "Profile",
                    style: kDBXLTextStyle,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        userData?.email ?? "Profile",
                        style: kBLTextStyle,
                      ),
                    ],
                  ),
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
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          const DivideLine(),
          const ListTile(
            leading: Icon(Icons.comment),
            title: Text(
              "About us",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          const DivideLine(),
          const ListTile(
            leading: Icon(Icons.phone),
            title: Text(
              "Contact us",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          const DivideLine(),
          const ListTile(
            leading: Icon(Icons.share),
            title: Text(
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
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                color: Colors.black,
              ),
            ),
            title: Text("LogOut"),
          ),
        ]),
      ),
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
