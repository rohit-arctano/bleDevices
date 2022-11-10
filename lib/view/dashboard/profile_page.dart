import 'dart:io';

import 'package:bldevice_connection/constant/colors_const.dart';
import 'package:bldevice_connection/constant/textstyle_constant.dart';
import 'package:bldevice_connection/model/fb_user.dart';
import 'package:bldevice_connection/shared_preferences/shared_preferences.dart';
import 'package:bldevice_connection/widget/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FbUser? data;
  getUser() async {
    // User? auth = FirebaseAuth.instance.currentUser;
    data = await SavePreferences().getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Stack(
              children: [
                FutureBuilder(
                    future: getUser(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          CircleAvatar(
                            radius: 65,
                            backgroundColor: kl2,
                            child: Image.asset(
                                'assets/images/arctanoLogoFull.png',
                                width: 100,
                                height: 70,
                                fit: BoxFit.fill),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                  hintText: data?.name.toUpperCase() ??
                                      "Username Found",
                                  hintStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white70,
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30.0)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30.0)),
                                    borderSide: BorderSide(
                                        color: Colors.pink, width: 2),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.grey[400],
                                    size: 25,
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: TextFormField(
                              obscureText: true,
                              // validator: (value) {},
                              decoration: InputDecoration(
                                  hintText: data?.email,
                                  hintStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white70,
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30.0)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30.0)),
                                    borderSide: BorderSide(
                                        color: Colors.pink, width: 2),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.mail,
                                    color: Colors.grey[400],
                                    size: 25,
                                  )),
                            ),
                          ),
                        ],
                      );
                    }),
              ],
            ),
          ),

          // _usermodel == null ? Text("no data") : buildFutureBuilder(),
          // Text("Full name",
          //     textAlign: TextAlign.left,
          //     style: TextStyle(color: Colors.pink,
          //     fontSize: 18,
          //     fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }

  var image = File;
  // final picker = ImagePicker();
}

class UserDetailField extends StatelessWidget {
  final String hinttext;
  final String text;

  const UserDetailField({
    required this.hinttext,
    key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                hinttext,
                style: kLTextStyle,
              ),
            ),
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.90,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color(0xFF000000),
                      width: 1.0,
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  text,
                  style: kLTextStyle,
                ),
              ),
            ),
          ],
        ));
  }
}
