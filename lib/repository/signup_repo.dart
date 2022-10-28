import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

import '../model/debug.dart';
import '../model/enums/sign_in_exceptions.dart';
import '../model/enums/signup_enum.dart';

// Map actionCodeSettings = {
//   url: 'https://www.example.com/?email=',
//   iOS: {
//     bundleId: 'com.example.ios'
//   },
//   android: {
//     packageName: 'com.example.android',
//     installApp: true,
//     minimumVersion: '12'
//   },
//   handleCodeInApp: true,
//   // When multiple custom dynamic link domains are defined, specify which
//   // one to use.
//   dynamicLinkDomain: "example.page.link"
// };
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

  Future<dynamic> SaveSignUpData(
      {required String name,
      required String mobile,
      required User currentUser,
      required BuildContext context}) async {
    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(currentUser.uid)
        .set({
      "sellerUID": user?.uid,
      "sellerName": name,
      "sellerEmail": user?.email,
      "phone": mobile,
      "sellerPassword": mobile,
      "status": "approved",
      "earnings": 0.0,
    });
    Navigator.pop(context);
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
