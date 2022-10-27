import 'dart:async';
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
      Timer(const Duration(seconds: 1), () => setState(() {}));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(0),
      child: Material(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            Animation<Offset> offsetAnimation = Tween<Offset>(
                    begin: const Offset(1.1, 0), end: const Offset(0, 0))
                .animate(animation);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
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
        ),
      ),
    );
  }
}
