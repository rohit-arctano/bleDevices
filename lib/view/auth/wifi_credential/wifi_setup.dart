import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart' as flutter_blue;
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:convert';
import '../../../constant/widget.dart';
import '../../../model/wifisetup_model.dart';

class WifiSetUp extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  const WifiSetUp({Key? key, required this.device}) : super(key: key);
  final flutter_blue.BluetoothDevice device;
  @override
  State<WifiSetUp> createState() => _WifiSetUpState();
}

class _WifiSetUpState extends State<WifiSetUp> {
  final TextEditingController userAccountController = TextEditingController();
  final TextEditingController ssidController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late final flutter_blue.BluetoothDevice _device;
  List<int> message = [];
  @override
  void initState() {
    super.initState();
    _device = widget.device;
    _device.requestMtu(512);
    print("the devie is $_device");
  }

  @override
  void dispose() {
    super.dispose();
    userAccountController.dispose();
    ssidController.dispose();
    passwordController.dispose();
  }

  Future login() async {
    // await _device.requestMtu(512);
    // await Future.delayed(const Duration(milliseconds: 1000));
    List<flutter_blue.BluetoothService> services =
        await _device.discoverServices();
    for (flutter_blue.BluetoothService service in services) {
      for (flutter_blue.BluetoothCharacteristic characteristic
          in service.characteristics) {
        if (characteristic.properties.write) {
          final data = await sendCommandToDevice();
          await characteristic.write(data, withoutResponse: true);
        }
        if (characteristic.properties.read) {
          message = await characteristic.read();

          print(
              "the device master id message is ${String.fromCharCodes(Uint8List.fromList(message))}");
        }
      }
    }
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => const AddDevice()));
  }

  sendCommandToDevice() async {
    CustomDeviceCredentials cd = CustomDeviceCredentials(
        // user: userAccountController.text,
        ssid: ssidController.text,
        password: passwordController.text);

    Map<String, dynamic> cdMap = cd.toJson();

    String cdString = jsonEncode(cdMap);
    final Uint8List convertedCommand = Uint8List.fromList(cdString.codeUnits);
    return convertedCommand;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(const Duration(seconds: 1))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                initialData: const [],
                builder: (c, snapshot) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      child: Column(
                        children: snapshot.data!
                            .map((d) => ListTile(
                                  title: Text(d.name),
                                  subtitle: Text(d.id.toString()),
                                  trailing: StreamBuilder<BluetoothDeviceState>(
                                    stream: d.state,
                                    initialData:
                                        BluetoothDeviceState.disconnected,
                                    builder: (c, snapshot) {
                                      if (snapshot.data ==
                                          BluetoothDeviceState.connected) {
                                        return ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        kPrimaryColor),
                                                textStyle: MaterialStateProperty
                                                    .all(const TextStyle(
                                                        fontSize:
                                                            kTextSizeSmall))),
                                            child: const Text('Connected'),
                                            onPressed: () {
                                              // Navigator.of(context).push(
                                              //     MaterialPageRoute(
                                              //         builder: (context) =>
                                              //             WifiSetUp(
                                              //               device: d,
                                              //             )));
                                            });
                                      } else {
                                        return Text("Disconnected");
                                      }

                                      return Text(snapshot.data.toString());
                                    },
                                  ),
                                ))
                            .toList(),
                      ),
                    );
                  } else {
                    return const Center(child: Text("No device Connected"));
                  }
                }),
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

                  // TextFormField(

                  //   controller: userAccountController,

                  //   style: const TextStyle(),

                  //   decoration: InputDecoration(

                  //     label: const Text("User Account"),

                  //     labelStyle: MaterialStateTextStyle.resolveWith(

                  //         (Set<MaterialState> states) {

                  //       return const TextStyle(letterSpacing: 1.3);

                  //     }),

                  //     contentPadding:

                  //         const EdgeInsets.fromLTRB(16, 10, 16, 10),

                  //     hintText: "Enter the UserAccount",

                  //     hintStyle: const TextStyle(),

                  //     enabledBorder: OutlineInputBorder(

                  //       borderRadius: BorderRadius.circular(4),

                  //     ),

                  //     focusedBorder: OutlineInputBorder(

                  //       borderRadius: BorderRadius.circular(4),

                  //     ),

                  //   ),

                  // ),

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
                      contentPadding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
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
                        return const TextStyle(letterSpacing: 1.3);
                      }),
                      contentPadding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                      hintText: "Enter the Password",
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
                        onPressed: () async {
                          await login();
                        },
                        child: const Text("Sign in "),
                      )),
                    ],
                  ),

                  Text(message.toString(), style: kLTextStyle)
                ],
              ),
            )
          ],
        ),
      ),
    )));
  }
}
