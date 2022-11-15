import 'dart:async';
import 'package:bldevice_connection/model/enums/signup_enum.dart';
import 'package:bldevice_connection/repository/signup_repo.dart';
import 'package:bldevice_connection/widget/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constant/widget.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController phonecontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController confirmPasswordcontroller =
      TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController _phoneNumberValue = TextEditingController();

  Future<void> signUp({required String email, required String password}) async {
    bool isValidated = _formkey.currentState?.validate() ?? false;
    if (isValidated) {
      signUpResponse = await FbAuthSignUp()
          .createSignUpAuth(email: email, password: password);

      if (signUpResponse is UserCredential) {
        user = auth.currentUser;
        print("the user email is $user");
        await user?.sendEmailVerification();
        AlertSnackBar.show(
            errorText: "Please check the email verification has been sent ",
            context: context);
        timer = Timer.periodic(const Duration(seconds: 2), (timer) {
          checkEmailVerified();
        });
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
    if (user?.emailVerified == true) {
      timer.cancel();
      await FbAuthSignUp.saveSignUpData(
          password: passwordcontroller.text,
          context: context,
          name: namecontroller.text,
          mobile: phonecontroller.text,
          currentUser: user!);
      await FirebaseAuth.instance.signOut();
      Navigator.pop(context);
    }
  }

  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Image.asset(
                            logoImage,
                            height: deviceHeight * 0.2,
                            width: deviceWidth * 0.68,
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
                                    style: kPLTextStyle,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: deviceHeight * 0.01,
                      ),
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
                        height: deviceHeight * 0.01,
                      ),
                      CustomTextField(
                        onTextChanged: (String? mobileNo) {
                          print(
                              "the mobile no is $mobileNo, _phoneNumberValue: ${_phoneNumberValue.text}");
                          if ((mobileNo ?? "") != "") {
                            _phoneNumberValue.value =
                                TextEditingValue(text: mobileNo ?? "");
                            print(
                                "the mobile no is in if:  $mobileNo, _phoneNumberValue: ${_phoneNumberValue.text}");
                          } else {
                            print(
                                "the mobile no is in else: $mobileNo, _phoneNumberValue: ${_phoneNumberValue.text}");
                          }
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'(^[0-9]{0,10})'),
                              replacementString: ""),
                        ],
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
                            passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                        data: Icons.lock,
                        controller: passwordcontroller,
                        hintText: "Enter the password",
                        isObscure: passwordVisible,
                        enabled: true,
                        onValidation: (String? value) {
                          if (value!.isEmpty) {
                            return "Enter the password";
                          } else if (value.length < 6) {
                            return "Password should be atleast 6 String length";
                          } else if (value.length >= 15) {
                            return "Password should  be Grerater than 15 String length";
                          } else if (RegExp(
                                  r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,15}')
                              .hasMatch(value)) {
                            return "Password should be atleast one character";
                          } else {
                            return null;
                          }
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
                          if (value!.isEmpty) {
                            return "Please Confirm the password";
                          } else if (value.length < 6) {
                            return "Password should be atleast 6 String length";
                          }
                          if (value.isEmpty) {
                            return 'Please re-enter password';
                          }

                          if (passwordcontroller.text !=
                              confirmPasswordcontroller.text) {
                            return "Password does not match";
                          }
                          return null;
                        },
                      ),
                    ],
                  )),
              SizedBox(
                height: deviceHeight * 0.01,
              ),
              CustomButton(
                colors: kPrimaryColor,
                onTap: () async {
                  if (_formkey.currentState!.validate()) {
                    await signUp(
                        email: emailcontroller.text,
                        password: passwordcontroller.text);
                  }
                },
                childWidget: const Text(
                  "Sign up",
                  style: kWLTextStyle,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  dynamic signUpResponse;
  late Timer timer;
  final auth = FirebaseAuth.instance;
  User? user;
  User? currentUser;
}
