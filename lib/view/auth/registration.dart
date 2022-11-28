import 'dart:async';
import 'package:bldevice_connection/model/debug.dart';
import 'package:bldevice_connection/model/enums/signup_enum.dart';
import 'package:bldevice_connection/model/validators.dart';
import 'package:bldevice_connection/repository/signup_repo.dart';
import 'package:bldevice_connection/widget/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constant/widget.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({required this.signIncall, super.key});

  final Function() signIncall;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController namecontroller = TextEditingController();

  final TextEditingController emailcontroller = TextEditingController();

  final TextEditingController phonecontroller = TextEditingController();

  final TextEditingController passwordcontroller = TextEditingController();

  final TextEditingController confirmPasswordcontroller = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController phoneNumberValue = TextEditingController();

  Future<void> _signUp({required String email, required String password, required BuildContext context}) async {
    bool isValidated = _formkey.currentState?.validate() ?? false;
    print("Sign up form validated: $isValidated");
    if (isValidated) {
      signUpResponse = await FbAuthSignUp().createSignUpAuth(email: email, password: password);
      Debug.printing("SignUp response : $signUpResponse");

      if (signUpResponse is UserCredential) {
        Debug.printing("SignUp response is userCredential: $signUpResponse");
        user = auth.currentUser;
        await user?.sendEmailVerification();

        AlertSnackBar.show(errorText: "Please check the email verification has been sent ", context: context);
        timer = Timer.periodic(const Duration(seconds: 2), (timer) {
          checkEmailVerified(buildContext: context);
        });
      }
    } else if (signUpResponse is SignUpException) {
      switch (signUpResponse) {
        case SignUpException.email_already_in_use:
          AlertSnackBar.show(errorText: "This email already user for signup", context: context);
          break;
        case SignUpException.invalid_email:
          AlertSnackBar.show(errorText: "Please enter the valid email", context: context);
          break;
        case SignUpException.operation_not_allowed:
          AlertSnackBar.show(errorText: "User not found in the DataBase", context: context);
          break;
        case SignUpException.weak_password:
          AlertSnackBar.show(errorText: "please enter the Strong password", context: context);
          break;
      }
    }
  }

  @override
  void dispose() {
    namecontroller.text;
    phonecontroller.text;
    passwordcontroller.text;
    emailcontroller.text;
    confirmPasswordcontroller.text;

    super.dispose();
  }

  Future<void> checkEmailVerified({required BuildContext buildContext}) async {
    user = auth.currentUser;

    await user?.reload();
    if (user?.emailVerified == true) {
      timer.cancel();
      await FbAuthSignUp.saveSignUpData(password: passwordcontroller.text, context: context, name: namecontroller.text, mobile: phonecontroller.text, currentUser: user!);
      await FirebaseAuth.instance.signOut();
      Navigator.pop(buildContext);
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Form(
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
          SizedBox(
            height: deviceHeight * 0.01,
          ),
          CustomTextField(
            data: Icons.email,
            controller: emailcontroller,
            hintText: "Enter the email",
            isObscure: false,
            enabled: true,
            onValidation: (input) => Validators.email(input),
          ),
          SizedBox(
            height: deviceHeight * 0.01,
          ),
          CustomTextField(
            onTextChanged: (String? mobileNo) {
              if ((mobileNo ?? "") != "") {
                phoneNumberValue.value = TextEditingValue(text: mobileNo ?? "");
                print("the mobile no is in if:  $mobileNo, _phoneNumberValue: ${phoneNumberValue.text}");
              }
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'(^[0-9]{0,10})'), replacementString: ""),
            ],
            data: Icons.mobile_friendly,
            controller: phonecontroller,
            hintText: "Enter the Mobile",
            isObscure: false,
            enabled: true,
            onValidation: (String? value) {
              print("the value is $value");
              if (value == null) {
                return 'Mobile Numuber is Required';
              } else if (value == '') {
                return 'Mobile Numuber is Required';
              }
              print("the value is $value");
              return null;
            },
          ),
          SizedBox(
            height: deviceHeight * 0.01,
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
            controller: passwordcontroller,
            hintText: "Enter the password",
            isObscure: passwordVisible,
            enabled: true,
            onValidation: (String? value) {
              print("the value is $value");
              return Validators.password(value);
            },
          ),
          SizedBox(
            height: deviceHeight * 0.01,
          ),
          CustomTextField(
            data: Icons.password,
            controller: confirmPasswordcontroller,
            hintText: "Enter the  Confirm password",
            isObscure: true,
            enabled: true,
            onValidation: (String? value) {
              if(passwordcontroller.value.text != value) {
                return "Password does not match";
              }
              return null;
            },
          ),
          SizedBox(
            height: deviceHeight * 0.01,
          ),
          Center(
            child: CustomButton(
              colors: kPrimaryColor,
              onTap: () async {
                if (_formkey.currentState!.validate()) {
                  await _signUp(email: emailcontroller.text, password: passwordcontroller.text, context: context);
                }
              },
              childWidget: const Text(
                "Sign up",
                style: kWLTextStyle,
              ),
            ),
          ),
          SizedBox(
            height: deviceHeight * 0.02,
          ),
          Text.rich(TextSpan(text: "Already have an account?", style: const TextStyle(color: kPrimaryColor), children: [
            TextSpan(
              text: " Sign In",
              style: const TextStyle(fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  print("calling the signup");
                  widget.signIncall();
                },
            )
          ])),
        ],
      ),
    );
  }

  dynamic signUpResponse;
  late Timer timer;
  final auth = FirebaseAuth.instance;
  User? user;
  User? currentUser;
  bool passwordVisible = false;
}
