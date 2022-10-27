import 'dart:convert';

import 'package:bldevice_connection/global/global.dart';
import 'package:bldevice_connection/shared_preferences/shared_preferences.dart';
import 'package:bldevice_connection/view/footer_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/model.dart';

class AuthUserLogin {
  /// Returns UserCredential on successful sign in
  ///
  /// Returns SignInException on failure
  User? user;
  Future<dynamic> signInWithEmailAndPassword({
    required String emailAddress,
    required String password,
  }) async {
    try {
      return await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Debug.printing('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Debug.printing('Wrong password provided for that user.');
      }
      return SignInExceptions.values
          .firstWhere((element) => _enumToErrorCode(element) == e.code);
    }
  }

  String _enumToErrorCode(SignInExceptions se) {
    return se.name.replaceAll(RegExp(r'_'), '-');
  }

  Future<void> readAndSaveDataLocally(
      {required User currentUser, required BuildContext context}) async {
    FbUser userData = FbUser(
        email: currentUser.email ?? "",
        name: currentUser.displayName ?? "",
        url: currentUser.photoURL ?? "");
    String encodedMap = jsonEncode(userData);
    await SavePreferences().setUserData(data: encodedMap);
    await SavePreferences().logIn();
    Route newRoute = MaterialPageRoute(builder: (c) => const Footer());
    Navigator.pushReplacement(context, newRoute);
  }
}
