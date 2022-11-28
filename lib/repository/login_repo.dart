import 'dart:convert';
import 'package:bldevice_connection/shared_preferences/shared_preferences.dart';
import 'package:bldevice_connection/view/footer_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/model.dart';
import '../widget/loader.dart';

class AuthUserLogin {
  User? user;

  Future<dynamic> signInWithEmailAndPassword({
    required String emailAddress,
    required String password,
  }) async {
    print("the email is $emailAddress");
    try {
      UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailAddress, password: password);
      print("User created.");
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Debug.printing('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Debug.printing('Wrong password provided for that user.');
      }
      print("the error is $e");
      return SignInExceptions.values.firstWhere((element) => _enumToErrorCode(element) == e.code);
    }
  }

  String _enumToErrorCode(SignInExceptions se) {
    return se.name.replaceAll(RegExp(r'_'), '-');
  }

  Future<void> readAndSaveDataLocally({required User currentUser, required BuildContext context}) async {
    // await data.then((value) => value.docs.forEach((element) {
    //       element.currentUser.;
    //     }));
    FbUser userData = FbUser(uid: currentUser.uid, email: currentUser.email ?? "", name: currentUser.displayName ?? "", mobileNo: currentUser.phoneNumber ?? "");
    String encodedMap = jsonEncode(userData);
    await SavePreferences().logIn();
    await SavePreferences().setUserData(data: encodedMap);
    showDialog(
        context: context,
        builder: (context) => const Center(
                child: Loader(
              height: 50,
              width: 50,
            )),
        barrierDismissible: false);

    Route newRoute = MaterialPageRoute(builder: (c) => Footer());
    Navigator.pushReplacement(context, newRoute);
  }
}
