import 'dart:async';

import 'package:bldevice_connection/constant/string_constant.dart';
import 'package:bldevice_connection/constant/widget.dart';
import 'package:bldevice_connection/model/enums/enums.dart';
import 'package:bldevice_connection/view/auth/registration.dart';
import 'package:bldevice_connection/view/footer_page.dart';
import 'package:bldevice_connection/widget/widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../repository/login_repo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController =
      TextEditingController(text: "");
  final TextEditingController _passwordController =
      TextEditingController(text: "");

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  dynamic result;
  User? currentUser;
  User? user;
  Timer? timer;
  Future<void> _signIn() async {
    bool isValidated = _formKey.currentState?.validate() ?? false;
    if (isValidated) {
      result = await AuthUserLogin().signInWithEmailAndPassword(
          emailAddress: _emailController.text,
          password: _passwordController.text);

      if (result is UserCredential) {
        currentUser = (result as UserCredential).user;
        print(currentUser?.emailVerified);
        if (currentUser != null) {
          if (currentUser!.emailVerified == true) {
            await AuthUserLogin().readAndSaveDataLocally(
                currentUser: currentUser!, context: context);
          } else if (currentUser!.emailVerified == false) {
            // show the dialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Error"),
                  content: const Text(emailVerifyError),
                  actions: [
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () async {
                        await emailverify();
                      },
                    ),
                  ],
                );
              },
            );
          }
        }
      } else if (result is SignInExceptions) {
        switch (result) {
          case SignInExceptions.invalidEmail:
            AlertSnackBar.show(
                errorText: "Please check the email", context: context);

            break;
          case SignInExceptions.user_disabled:
            break;
          case SignInExceptions.user_not_found:
            AlertSnackBar.show(
                errorText: "User not found in the DataBase", context: context);
            break;
          case SignInExceptions.wrong_password:
            AlertSnackBar.show(
                errorText: "You have entered Password", context: context);
            break;
        }
      }
    }
  }

  Future<void> emailverify() async {
    final auth = FirebaseAuth.instance;
    currentUser = auth.currentUser;
    await currentUser?.sendEmailVerification();

    timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      await currentUser?.reload();
      user = auth.currentUser;
      if (currentUser!.emailVerified) {
        print("the current user is $currentUser");

        timer.cancel();
        await FirebaseAuth.instance.signOut();
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: ListView(
        children: [
          const SizedBox(
            height: 250,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  data: Icons.person,
                  controller: _emailController,
                  hintText: "Enter the email",
                  isObscure: false,
                  enabled: true,
                  onValidation: (String? value) {
                    if (value == null) {
                      return 'Required';
                    } else if (value == '') {
                      return 'Required';
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return 'Invalid email';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  data: Icons.lock,
                  controller: _passwordController,
                  hintText: "Enter the password",
                  isObscure: true,
                  enabled: true,
                  onValidation: (String? value) {
                    if (value == null) {
                      return 'Required';
                    } else if (value == '') {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    // await _signIn();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Footer()));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10)),
                  child: const Text("Log in"),
                ),
                const SizedBox(
                  height: 150,
                ),
                Center(
                  child: Text.rich(TextSpan(
                      text: "Don't have an account?",
                      style: const TextStyle(color: kPrimaryColor),
                      children: [
                        TextSpan(
                          text: "SignUp",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Register()));
                            },
                        )
                      ])),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
}

class AlertSnackBar {
  static const _snackBarDur = Duration(seconds: 3);

  /// Pass the error text to show in SnackBar
  static void show(
      {required String errorText,
      IconData errorIcon = Icons.error_outline_sharp,
      required BuildContext context,
      Duration? duration}) {
    final snackBar = SnackBar(
      duration: duration ?? _snackBarDur,
      content: Row(
        children: [
          Icon(
            errorIcon,
            color: const Color.fromARGB(255, 70, 67, 67),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
          ),
          Expanded(
            child: Text(
              errorText,
              style: const TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {},
      ),
      shape: const StadiumBorder(),
      width: MediaQuery.of(context).size.width * 0.85,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
