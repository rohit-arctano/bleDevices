import 'package:bldevice_connection/model/enums/enums.dart';
import 'package:bldevice_connection/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../repository/login_repo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController(text: "");
  final TextEditingController _passwordController = TextEditingController(text: "");

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _signIn() async {
    bool isValidated = _formKey.currentState?.validate() ?? false;
    if (isValidated){
      var result = await AuthUserLogin().signInWithEmailAndPassword(emailAddress: _emailController.text, password: _passwordController.text);
      if(result is UserCredential) {
        // TODO
      } else if (result is SignInExceptions){
        switch(result) {
          case SignInExceptions.invalidEmail:
            // TODO: Handle this case.
            break;
          case SignInExceptions.user_disabled:
            // TODO: Handle this case.
            break;
          case SignInExceptions.user_not_found:
            // TODO: Handle this case.
            break;
          case SignInExceptions.wrong_password:
            // TODO: Handle this case.
            break;
        }
      }
    }
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
                    if(value == null) {
                      return 'Required';
                    } else if (value == '') {
                      return 'Required';
                    } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                      return 'Invalid email';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  data: Icons.person,
                  controller: _passwordController,
                  hintText: "Enter the password",
                  isObscure: true,
                  enabled: true,
                  onValidation: (String? value) {
                    if(value == null) {
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
                    await _signIn();
                  },
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
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
