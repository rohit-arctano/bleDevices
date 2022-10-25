import 'dart:io';
import 'package:bldevice_connection/global/global.dart';
import 'package:bldevice_connection/view/auth/firebase_auth/login.dart';
import 'package:bldevice_connection/widget/customTextField.dart';
import 'package:bldevice_connection/widget/error_msg.dart';
import 'package:bldevice_connection/widget/loading_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController namecontroller = TextEditingController(text: "");
  TextEditingController emailcontroller = TextEditingController(text: "");
  TextEditingController passwordcontroller = TextEditingController(text: "");
  TextEditingController confirmpasswordcontroller =
      TextEditingController(text: "");
  TextEditingController phonecontroller = TextEditingController(text: "");
  // TextEditingController locationcontroller = TextEditingController(text: "");
  late Size size;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  formValidation() async {
    if (namecontroller.text.length < 2) {
      showDialog(
          context: context,
          builder: (c) => ErrorMessage(
                message: "No valid name found",
                pos: false,
              ));
    } else if (emailcontroller.text.length < 5) {
      showDialog(
          context: context,
          builder: (c) => ErrorMessage(
                message: "email not found",
                pos: false,
              ));
    } else if (phonecontroller.text.length != 10) {
      showDialog(
          context: context,
          builder: (c) => ErrorMessage(
                message: "Invalid number",
                pos: false,
              ));
    } else if (passwordcontroller.text.length < 3) {
      showDialog(
          context: context,
          builder: (c) => ErrorMessage(
                message: "Password length greater than 3 required",
                pos: false,
              ));
    } else if (passwordcontroller.text != confirmpasswordcontroller.text) {
      showDialog(
          context: context,
          builder: (c) => ErrorMessage(
                message: "Password not matched",
                pos: false,
              ));
      // } else if (locationcontroller.text.length < 3) {
      //   showDialog(
      //       context: context,
      //       builder: (c) => Error_Message(
      //             message: "Invalid location",
      //             pos: false,
      //           ));
    } else {
      showDialog(
          context: context,
          builder: (c) => LoadingDialog(
                message: "",
              ));
      // showDialog(context: context, builder:(c) => Error_Message(message: "Registration successful",pos: true,));
      String filename = DateTime.now().millisecondsSinceEpoch.toString();

      authenticateSeller();
    }
  }

  // late String imageurl;

  Future<void> savaDataToFireStore(User currentUser) async {
    FirebaseFirestore.instance.collection("sellers").doc(currentUser.uid).set({
      "sellerUID": currentUser.uid,
      "sellerEmail": currentUser.email,
      "sellerName": namecontroller.text.trim(),
      // "sellerAvatarUrl":imageurl,
      // "address":locationcontroller.text,
      "phone": phonecontroller.text,
      "sellerPassword": passwordcontroller.text.trim(),
      "status": "approved",
      "earnings": 0.0,
      // "lat":position!.latitude,
      // "lng":position!.longitude
    });

    //save data locally
    // sharedPreferences = await SharedPreferences.getInstance();
    // sharedPreferences!.setString("uid", currentUser.uid);
    // sharedPreferences!.setString("email", currentUser.email.toString());
    // sharedPreferences!.setString("name", namecontroller.text.trim());
    // sharedPreferences!.setString("photoUrl", imageurl);
    fsellerUid = await currentUser.uid;
    femail = currentUser.email;
    fname = namecontroller.text.trim();
    // fphotoUrl = imageurl;
    // faddress = locationcontroller.text;
    fphone = phonecontroller.text;
    fpassword = passwordcontroller.text.trim();
    fstatus = "approved";
    fearning = 0.0;

    final abc = await FirebaseDatabase.instance
        .ref("users")
        .child("")
        // .child(fsellerUid!)
        // .child(widget.dev)
        // .child("SWITCHES")
        .ref;
    Map<dynamic, dynamic> values;
    await abc.once().then((DatabaseEvent event) {
      values = event.snapshot.value as Map<dynamic, dynamic>;
      values.addAll({
        fsellerUid: {
          "Device 1": {
            "SWITCHES": {
              "Total": 1,
              "Switch": {"NAME": "dummy", "STATUS": 0, "ENABLE": 0 == 1}
            }
          }
        }
      });
      abc.set(values);
      print(values.toString());
    });

    // flat = position!.latitude;
    // flng = position!.longitude;
  }

  void authenticateSeller() async {
    // User? currentUser;

    await firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailcontroller.text.trim(),
            password: passwordcontroller.text.trim())
        .then((auth) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) => ErrorMessage(
                message: error.message.toString(),
                pos: false,
              ));
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Form(
              key: _formkey,
              child: Column(
                children: [
                  CustomTextField(
                    data: Icons.person,
                    controller: namecontroller,
                    hintText: "Enter the username",
                    isObsecure: false,
                    enabled: true,
                  ),
                  CustomTextField(
                    data: Icons.email,
                    controller: emailcontroller,
                    hintText: "Enter the email",
                    isObsecure: false,
                    enabled: true,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: passwordcontroller,
                    hintText: "Enter the password",
                    isObsecure: true,
                    enabled: true,
                  ),
                ],
              )),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {
              formValidation();
            },
            child: const Text("Sign up"),
            style: ElevatedButton.styleFrom(
                primary: Colors.purple,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
          )
        ],
      ),
    );
  }
}
