import 'package:bldevice_connection/constant/colors_const.dart';
import 'package:bldevice_connection/repository/signup_repo.dart';
import 'package:bldevice_connection/widget/customtextField.dart';
import 'package:flutter/material.dart';

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
  dynamic result;

  Future<void> signUp({required String email, required String password}) async {
    bool isValidated = _formkey.currentState?.validate() ?? false;
    if (isValidated) {
      result = await FbAuthSignUp()
          .createSignUpAuth(email: email, password: password);

      // if (result is UserCredential) {
      //   if (currentUser != null) {
      //     currentUser = (result as UserCredential).user;
      //     await AuthUserLogin().readAndSaveDataLocally(
      //         currentUser: currentUser!, context: context);
      //   }
      // } else if (result is SignInExceptions) {
      //   switch (result) {
      //     case SignInExceptions.invalidEmail:
      //       AlertSnackBar.show(
      //           errorText: "Please check the email", context: context);

      //       break;
      //     case SignInExceptions.user_disabled:
      //       break;
      //     case SignInExceptions.user_not_found:
      //       AlertSnackBar.show(
      //           errorText: "User not found in the DataBase", context: context);
      //       break;
      //     case SignInExceptions.wrong_password:
      //       AlertSnackBar.show(
      //           errorText: "You have entered Password", context: context);
      //       break;
      //   }
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    // size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
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
                    ),
                    CustomTextField(
                      data: Icons.email,
                      controller: emailcontroller,
                      hintText: "Enter the email",
                      isObscure: false,
                      enabled: true,
                    ),
                    CustomTextField(
                      data: Icons.mobile_friendly,
                      controller: phonecontroller,
                      hintText: "Enter the Mobile",
                      isObscure: false,
                      enabled: true,
                    ),
                    CustomTextField(
                      data: Icons.lock,
                      controller: passwordcontroller,
                      hintText: "Enter the password",
                      isObscure: true,
                      enabled: true,
                    ),
                    CustomTextField(
                      data: Icons.password,
                      controller: confirmpasswordcontroller,
                      hintText: "Enter the confirm password",
                      isObscure: true,
                      enabled: true,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
              child: const Text("Sign up"),
            )
          ],
        ),
      ),
    );
  }
}
