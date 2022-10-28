import 'package:bldevice_connection/constant/colors_const.dart';
import 'package:bldevice_connection/global/global.dart';
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
  User? userData;
  String? profileImage;
  Map? loginData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 40.0, 0.0, 0.0),
        child: ListView(padding: EdgeInsets.zero, children: [
          // FutureBuilder(
          //     future: getCurrentUser(),
          //     builder: (context, snapshot) {
          //       return ListTile(
          //         leading: const CircleAvatar(
          //           radius: 30,
          //           backgroundColor: kPrimaryColor,
          //           //   foregroundImage: NetworkImage(loginData?['profile'] ??
          //           //       "https://st.depositphotos.com/2101611/3925/v/600/depositphotos_39258143-stock-illustration-businessman-avatar-profile-picture.jpg"),
          //         ),
          //         title: Text(
          //           loginData?["email"],
          //           style: const TextStyle(
          //               color: kDarkGreyColor,
          //               fontWeight: FontWeight.bold,
          //               fontSize: 16),
          //         ),
          //       );
          //     }),
          const SizedBox(
            height: 60,
          ),
          const DivideLine(),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateCategories()));
            },
            leading: const Icon(Icons.home),
            title: const Text(
              "Add the Device",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
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
            leading: Icon(Icons.leaderboard_rounded),
            title: Text(
              "Leaderboard",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          const DivideLine(),
          const ListTile(
            leading: Icon(Icons.comment),
            title: Text(
              "About",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          const DivideLine(),
          const ListTile(
            leading: Icon(Icons.phone),
            title: Text(
              "Contact",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          const DivideLine(),
          const SizedBox(
            height: 50,
          ),
          ListTile(
              leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey,
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await SavePreferences().logOut();
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              color: Colors.black,
            ),
          )),
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
