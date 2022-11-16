import 'dart:async';

import 'package:bldevice_connection/constant/widget.dart';
import 'package:bldevice_connection/model/enums/enums.dart';
import 'package:bldevice_connection/view/auth/registration.dart';
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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool toSignUp = true;
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        key: scaffoldKey,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: deviceHeight * 0.1,
                      ),
                      Image.asset(
                        logoImage,
                        height: deviceHeight * 0.15,
                        width: deviceWidth * 0.75,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          children: const [
                            Icon(
                              Icons.home,
                              size: 30,
                              color: kPrimaryColor,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                "Smart Home",
                                style: kPMediumTextStyle,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    child: Form(
                      key: formKey,
                      child: toSignUp
                          ? SignIn(
                              formKey: formKey,
                              onSignUpPressed: () {
                                print("the bool value is  $toSignUp");
                                setState(() {
                                  toSignUp = false;
                                });
                              },
                            )
                          : SignUp(signIncall: () {
                              print("the signupvalue value is  $toSignUp");
                              setState(() {
                                toSignUp = true;
                              });
                            }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
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

class SignIn extends StatefulWidget {
  const SignIn(
      {required this.formKey, required this.onSignUpPressed, super.key});
  final GlobalKey<FormState> formKey;
  final Function() onSignUpPressed;
  @override
  State<SignIn> createState() => _SignUpState();
}

class _SignUpState extends State<SignIn> {
  final TextEditingController _emailController =
      TextEditingController(text: "");
  final TextEditingController _passwordController =
      TextEditingController(text: "");

  dynamic result;
  User? currentUser;
  User? user;
  Timer? timer;
  Future<void> _signIn() async {
    bool isValidated = widget.formKey.currentState?.validate() ?? false;
    if (isValidated) {
      result = await AuthUserLogin().signInWithEmailAndPassword(
          emailAddress: _emailController.text,
          password: _passwordController.text);

      if (result is UserCredential) {
        currentUser = (result as UserCredential).user;
        print("thhe user name is ${currentUser!.displayName}");
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
        timer.cancel();

        await FirebaseAuth.instance.signOut();
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _emailController.text;
    _passwordController.text;
    super.dispose();
  }

  bool passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return Wrap(
      children: [
        Column(
          children: [
            SizedBox(
              height: deviceHeight * 0.05,
            ),
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
            SizedBox(
              height: deviceHeight * 0.017,
            ),
            CustomTextField(
              suffixAdd: IconButton(
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                },
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  passwordVisible ? Icons.visibility_off : Icons.visibility,
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
              data: Icons.lock,
              controller: _passwordController,
              hintText: "Enter the password",
              isObscure: passwordVisible,
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
            SizedBox(
              height: deviceHeight * 0.017,
            ),
            Container(
              height: 50,
              child: CustomButton(
                onTap: () async {
                  await _signIn();
                },
                colors: kPrimaryColor,
                childWidget: const Text(
                  "Log in",
                  style: kWhiteLrgTextStyle,
                ),
              ),
            ),
            SizedBox(
              height: deviceHeight * 0.017,
            ),
            Text.rich(TextSpan(
                text: "Don't have an account?",
                style: const TextStyle(color: kPrimaryColor),
                children: [
                  TextSpan(
                    text: " Sign Up",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        print("calling the signup");
                        widget.onSignUpPressed();
                      },
                  )
                ]))
          ],
        ),
      ],
    );
  }
}
