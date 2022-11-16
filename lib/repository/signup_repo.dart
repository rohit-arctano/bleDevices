import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/debug.dart';
import '../model/enums/signup_enum.dart';

class FbAuthSignUp {
  User? user;
  Future<dynamic> createSignUpAuth(
      {required String email, required String password}) async {
    try {
      return await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Debug.printing('No user found for that email.');
      } else if (e.code == 'weak-password') {
        Debug.printing('Wrong password provided for that user.');
      }
      return SignUpException.values
          .firstWhere((element) => _enumToErrorCode(element) == e.code);
    }
  }

  String _enumToErrorCode(SignUpException se) {
    return se.name.replaceAll(RegExp(r'_'), '-');
  }

  static Future<dynamic> saveSignUpData(
      {required String name,
      required String mobile,
      required User currentUser,
      required String password,
      required BuildContext context}) async {
    await currentUser.updateDisplayName(name);
  }
}




 // final abc = FirebaseDatabase.instance
  //     .ref("users")
  //     .child("")
  //     // .child(fsellerUid!)
  //     // .child(widget.dev)
  //     // .child("SWITCHES")
  //     .ref;
  // Map<dynamic, dynamic> values;
  // await abc.once().then((DatabaseEvent event) {
  //   values = event.snapshot.value as Map<dynamic, dynamic>;
  //   values.addAll({
  //     // fsellerUid: {
  //     //   "Device 1": {
  //     //     "SWITCHES": {
  //     //       "Total": 1,
  //     //       "Switch": {"NAME": "dummy", "STATUS": 0, "ENABLE": 0 == 1}
  //     //     }
  //     //   }
  //     // }
  //   });
  //   abc.set(values);
  //   print(values.toString());
  // });

  // flat = position!.latitude;
  // flng = position!.longitude;
