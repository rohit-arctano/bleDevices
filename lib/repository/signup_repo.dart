import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../model/debug.dart';
import '../model/enums/sign_in_exceptions.dart';
import '../model/enums/signup_enum.dart';

class FbAuthSignUp {
  User? user;

  Future<dynamic> createSignUpAuth(
      {required String email, required String password}) async {
    try {
      return await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      return SignUpException.values
          .firstWhere((element) => _enumToErrorCode(element) == e.code);
    }
  }

  String _enumToErrorCode(SignUpException se) {
    return se.name.replaceAll(RegExp(r'_'), '-');
  }
  // FirebaseFirestore.instance.collection("sellers").doc(currentUser.uid).set({
  //   "sellerUID": user?.uid,
  //   "sellerEmail": user?.email,
  //   "sellerName": namecontroller.text.trim(),
  //   // "sellerAvatarUrl":imageurl,
  //   // "address":locationcontroller.text,
  //   "phone": phonecontroller.text,
  //   "sellerPassword": passwordcontroller.text.trim(),
  //   "status": "approved",
  //   "earnings": 0.0,
  //   // "lat":position!.latitude,
  //   // "lng":position!.longitude
  // });
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
}
