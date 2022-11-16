import 'dart:io';
import 'package:bldevice_connection/constant/widget.dart';
import 'package:bldevice_connection/model/fb_user.dart';
import 'package:bldevice_connection/shared_preferences/shared_preferences.dart';
import 'package:bldevice_connection/widget/customTextField.dart';
import 'package:bldevice_connection/widget/loader.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  // final TextEditingController nameController = TextEditingController();

  FbUser? data;
  getUser() async {
    // User? auth = FirebaseAuth.instance.currentUser;
    data = await SavePreferences().getUserData();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SafeArea(
      child: FutureBuilder(
          future: getUser(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // mobileController.text = data?.mobileNo ?? "";
            if (snapshot.connectionState == ConnectionState.done) {
              nameController.text = data!.name.toUpperCase();
              emailController.text = data!.email!;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
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
                              height: 190,
                              width: 100,
                            ),
                          ),
                        ),
                      ),
                    ),
                    CustomTextField(
                      controller: nameController,
                      data: Icons.person,
                      hintText: "Enter the name",
                      isObscure: false,
                    ),
                    SizedBox(
                      height: deviceHeight * 0.02,
                    ),
                    CustomTextField(
                      controller: emailController,
                      data: Icons.email,
                      hintText: "Enter the name",
                      isObscure: false,
                    ),
                    SizedBox(
                      height: deviceHeight * 0.02,
                    ),
                    CustomTextField(
                      controller: mobileController,
                      data: Icons.phone,
                      hintText: "Enter the Mobile Number",
                      isObscure: false,
                    ),
                    SizedBox(
                      height: deviceHeight * 0.02,
                    ),
                  ],
                ),
              );
            } else {
              return const Loader();
            }
          }),
    ));
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
