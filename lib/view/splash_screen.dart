import 'dart:async';
import 'package:bldevice_connection/model/permission_utility.dart';
import 'package:bldevice_connection/view/widget_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:permission_handler/permission_handler.dart';
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
      Timer(const Duration(seconds: 1), () async{
        await permissions();
        setState(() {});
      });
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
              begin: const Offset(1.1, 0),
              end: const Offset(0, 0),
            ).animate(animation);
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
                  ? Footer()
                  : const LoginScreen(),
        ),
      ),
    );
  }

  Future<void> permissions() async {
    List<Permission> requiredPermissions = [
      Permission.bluetooth,
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.location,
    ];
    await PermissionUtility.requiredPermissionsList(permissions: requiredPermissions);
  }
}
