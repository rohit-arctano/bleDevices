import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart' as flutter_blue;
import 'dart:convert';

import '../../model/wifisetup_model.dart';

class WifiSetUp extends StatefulWidget {
  const WifiSetUp({super.key});

  @override
  State<WifiSetUp> createState() => _WifiSetUpState();
}

class _WifiSetUpState extends State<WifiSetUp> {
  final TextEditingController userAccountController = TextEditingController();
  final TextEditingController ssidController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    userAccountController.dispose();
    ssidController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "Put Your Wifi Crendential",
                      maxLines: 20,
                      style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    TextFormField(
                      controller: userAccountController,
                      style: const TextStyle(),
                      decoration: InputDecoration(
                        label: const Text("User Account"),
                        labelStyle: MaterialStateTextStyle.resolveWith(
                            (Set<MaterialState> states) {
                          return const TextStyle(letterSpacing: 1.3);
                        }),
                        contentPadding:
                            const EdgeInsets.fromLTRB(16, 10, 16, 10),
                        hintText: "Enter the UserAccount",
                        hintStyle: const TextStyle(),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: ssidController,
                      style: const TextStyle(),
                      decoration: InputDecoration(
                        label: const Text("SSID"),
                        labelStyle: MaterialStateTextStyle.resolveWith(
                            (Set<MaterialState> states) {
                          return const TextStyle(letterSpacing: 1.3);
                        }),
                        contentPadding:
                            const EdgeInsets.fromLTRB(16, 10, 16, 10),
                        hintText: "Enter the SSID",
                        hintStyle: const TextStyle(),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: passwordController,
                      style: const TextStyle(),
                      decoration: InputDecoration(
                        label: const Text("Password"),
                        labelStyle: MaterialStateTextStyle.resolveWith(
                            (Set<MaterialState> states) {
                          return TextStyle(letterSpacing: 1.3);
                        }),
                        contentPadding:
                            const EdgeInsets.fromLTRB(16, 10, 16, 10),
                        hintText: "Enter the Password",
                        // hintStyle: const TextStyle(color: kGreyColor),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: ElevatedButton(
                          onPressed: () {
                            // login(device);
                            // otpSend();

                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => OtpScreen()));
                            // toasty(context, "Sign in clicked");
                          },
                          child: Text("Sign in "),
                        )),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  sendCommandToDevice() async {
    // Map data = {
    //   'newid': userAccountController.text,
    //   "new password": ssidController.text,
    //   'user iD': passwordController.text,
    // };
    CustomDeviceCredentials cd = CustomDeviceCredentials(
        user: userAccountController.text,
        ssid: ssidController.text,
        password: passwordController.text);
    Map<String, dynamic> cdMap = cd.toJson();
    String cdString = jsonEncode(cdMap);
    final Uint8List convertedCommand = Uint8List.fromList(cdString.codeUnits);
    print(convertedCommand);
    return convertedCommand;
  }

  Future login(flutter_blue.BluetoothDevice device) async {
    await device.connect();
    List<flutter_blue.BluetoothService> services =
        await device.discoverServices();
    for (flutter_blue.BluetoothService service in services) {
      for (flutter_blue.BluetoothCharacteristic characteristic
          in service.characteristics) {
        if (characteristic.properties.write) {
          final data = sendCommandToDevice();
          print(data);
        }
      }
    }

    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => FooterPage()));
  }
}
