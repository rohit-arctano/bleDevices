import 'dart:async';

import 'package:bldevice_connection/constant/colors_const.dart';
import 'package:bldevice_connection/model/enums/signup_enum.dart';
import 'package:bldevice_connection/repository/signup_repo.dart';
import 'package:bldevice_connection/view/footer_page.dart';
import 'package:bldevice_connection/widget/customtextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/enums/sign_in_exceptions.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmpasswordcontroller = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  dynamic signUpResponse;
  late Timer timer;
  final auth = FirebaseAuth.instance;
  User? user;
  User? currentUser;
  Future<void> signUp({required String email, required String password}) async {
    bool isValidated = _formkey.currentState?.validate() ?? false;
    if (isValidated) {
      signUpResponse = await FbAuthSignUp()
          .createSignUpAuth(email: email, password: password);

      if (signUpResponse is UserCredential) {
        user = auth.currentUser;
        // currentUser = (signUpResponse as UserCredential).user;
        print("the user email is $user");
        await user?.sendEmailVerification();
        timer = Timer.periodic(const Duration(seconds: 2), (timer) {
          checkEmailVerified();
        });

        // await FbAuthSignUp().SaveSignUpData(
        //     name: namecontroller.text,
        //     mobile: phonecontroller.text,
        //     currentUser: currentUser!,
        //     context: context);
      }
    } else if (signUpResponse is SignUpException) {
      switch (signUpResponse) {
        case SignUpException.email_already_in_use:
          AlertSnackBar.show(
              errorText: "This email already user for signup",
              context: context);
          break;
        case SignUpException.invalid_email:
          AlertSnackBar.show(
              errorText: "Please enter the valid email", context: context);
          break;
        case SignUpException.operation_not_allowed:
          AlertSnackBar.show(
              errorText: "User not found in the DataBase", context: context);
          break;
        case SignUpException.weak_password:
          AlertSnackBar.show(
              errorText: "please enter the Strong password", context: context);
          break;
      }
    }
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;

    await user?.reload();
    if (user!.emailVerified) {
      timer.cancel();
      await FirebaseAuth.instance.signOut();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      CustomTextField(
                        data: Icons.person,
                        controller: namecontroller,
                        hintText: "Enter the username",
                        isObscure: false,
                        enabled: true,
                        onValidation: (String? value) {
                          if (value == null) {
                            return 'Name is Required';
                          } else if (value == '') {
                            return 'Name is Required';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        data: Icons.email,
                        controller: emailcontroller,
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
                        data: Icons.mobile_friendly,
                        controller: phonecontroller,
                        hintText: "Enter the Mobile",
                        isObscure: false,
                        enabled: true,
                        onValidation: (String? value) {
                          if (value == null) {
                            return 'Mobile Numuber is Required';
                          } else if (value == '') {
                            return 'Mobile Numuber is Required';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        data: Icons.lock,
                        controller: passwordcontroller,
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
                      CustomTextField(
                        data: Icons.password,
                        controller: confirmpasswordcontroller,
                        hintText: "Enter the confirm password",
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
                    ],
                  )),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () async {
                  await signUp(
                      email: emailcontroller.text,
                      password: passwordcontroller.text);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10)),
                child: const Text("Sign up"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
