import 'package:bldevice_connection/global/global.dart';
import 'package:bldevice_connection/shared_preferences/shared_preferences.dart';

import 'package:bldevice_connection/view/footer_page.dart';
import 'package:bldevice_connection/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../repository/login_repo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailcontroller = TextEditingController(text: "");
  final TextEditingController passwordcontroller =
      TextEditingController(text: "");

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Future<void> formValidation(
      {required BuildContext context, required String email}) async {
    if (email.length < 8) {
      await showDialog(
          context: context,
          builder: (c) => ErrorMessage(
                message: "Please Enter the valid email",
                pos: false,
              ));
    } else {
      await AuthUserLogin().sendEmailLink(email: email);
    }
  }

  // await auth.signInWithEmailLink(
  //   email: emailcontroller.text,
  // );

  // auth.verifyPhoneNumber(
  //     phoneNumber: "+91 9999181009",
  //     timeout: const Duration(seconds: 60),
  //     verificationCompleted: (AuthCredential credential) async {
  //       Navigator.of(context).pop();

  //       UserCredential result = await auth.signInWithCredential(credential);

  //       User? user = result.user;

  //       if (user != null) {
  //         Navigator.push(
  //             context, MaterialPageRoute(builder: (context) => Footer()));
  //       } else {
  //         print("Error");
  //       }

  //       //This callback would gets called when verification is done auto maticlly
  //     },
  //     verificationFailed: (FirebaseAuthException exception) {
  //       print(exception);
  //     },
  //     codeSent: (String verificationId, int? forceResendingToken) {
  //       showDialog(
  //           context: context,
  //           barrierDismissible: false,
  //           builder: (context) {
  //             return AlertDialog(
  //               title: const Text("Give the code?"),
  //               content: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: <Widget>[
  //                   TextField(
  //                     controller: phonecontroller,
  //                   ),
  //                 ],
  //               ),
  //               actions: <Widget>[
  //                 ElevatedButton(
  //                   child: Text("Confirm"),
  //                   onPressed: () async {
  //                     final code = phonecontroller.text.trim();
  //                     AuthCredential credential =
  //                         PhoneAuthProvider.credential(
  //                             verificationId: verificationId, smsCode: code);
  //                     UserCredential result =
  //                         await auth.signInWithCredential(credential);

  //                     User? user = result.user;

  //                     if (user != null) {
  //                       Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                               builder: (BuildContext context) => Footer()));
  //                     } else {
  //                       print("Error");
  //                     }
  //                   },
  //                 )
  //               ],
  //             );
  //           });
  //     },
  //     codeAutoRetrievalTimeout: (String resedotp) {});

  Future<void> readAndSaveDataLocally({
    required BuildContext context2,
    required User? currentUser,
  }) async {
    Map loginData = {
      'name': currentUser?.displayName,
      'email': currentUser?.email,
      'profile': currentUser?.photoURL,
      'seller': currentUser?.uid
    };

    fname = loginData["name"];
    fsellerUid = loginData["seller"];
    await SavePreferences().setUserData(fname ?? "");
    await Navigator.pushReplacement(
        context2, MaterialPageRoute(builder: (context) => const Footer()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(
            height: 250,
          ),
          Form(
            key: _formkey,
            child: Column(
              children: [
                CustomTextField(
                  data: Icons.person,
                  controller: emailcontroller,
                  hintText: "Enter the email",
                  isObsecure: false,
                  enabled: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    // final email = emailcontroller.text.trim();
                    formValidation(
                        context: context, email: emailcontroller.text);
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => Footer()));
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10)),
                  child: const Text("Log in"),
                ),
                const SizedBox(
                  height: 270,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
