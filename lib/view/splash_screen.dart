import 'dart:async';
import 'package:bldevice_connection/model/fb_user.dart';
import 'package:bldevice_connection/view/widget_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool? _userSignedIn;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((Duration dur) async {
      _userSignedIn = await SavePreferences().getLogInStatus() ?? false;
      // FbUser userData = await SavePreferences().getUserData();
      // print(userData);
      Timer(const Duration(seconds: 1), () => setState(() {}));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(0),
      child: _userSignedIn == null
          ? Scaffold(
              body: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/splashScreen.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            )
          : _userSignedIn!
              ? const Footer()
              : const LoginScreen(),
    );
  }
}
