import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:convert';
import '../../../constant/widget.dart';
import '../../../model/wifisetup_model.dart';

class WifiSetUp extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  const WifiSetUp({Key? key, required this.device}) : super(key: key);
  final BluetoothDevice device;
  @override
  State<WifiSetUp> createState() => _WifiSetUpState();
}

class _WifiSetUpState extends State<WifiSetUp> {
  final TextEditingController userAccountController = TextEditingController();
  final TextEditingController ssidController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  List<int> message = [];
  bool _isConnected = false;
  Stream<List<BluetoothService>>? services;
  @override
  void initState() {
    super.initState();
    widget.device.mtu.listen((mtuSet) async {
      print("mtu old size: $mtuSet");
      if (mtuSet != 512) {
        await widget.device.requestMtu(512);
        print("mtu size set: 512");
      }
    });
    // widget.device.state.listen((event) {
    //   if (event == BluetoothDeviceState.connected) {
    //     _isConnected = true;
    //     services = widget.device.services;
    //     services?.listen(
    //       (service) async {
    //         print("No of service found : ${service.length}");
    //         for (int i = 0; i < service.length; i++) {
    //           print(
    //               "$i ${service[i].uuid},  isPrimary: ${service[i].isPrimary}");
    //         }
    //         // BluetoothService ourService = service.firstWhere((element) =>
    //         //     element.uuid.toString() ==
    //         //     "6e400001-b5a3-f393-e0a9-e50e24dcca9e");
    //         // List<BluetoothCharacteristic> chars = ourService.characteristics;
    //       //   print("No of characteristics found : ${chars.length}");
    //       //   for (int i = 0; i < chars.length; i++) {
    //       //     print(
    //       //         "$i ${chars[i].uuid}, isNotifying: ${chars[i].isNotifying}");
    //       //   }
    //       // },
    //     );
    //   } else {
    //     _isConnected = false;
    //     services = null;
    //   }
    // });
  }

  @override
  void dispose() {
    super.dispose();
    userAccountController.dispose();
    ssidController.dispose();
    passwordController.dispose();
  }

  Future<void> _login() async {
    // ignore: unrelated_type_equality_checks
    if (widget.device.mtu != 512) {
      await widget.device.requestMtu(512);

      print("mtu size set: 512");
      await Future.delayed(const Duration(milliseconds: 1000));
      List<BluetoothService> services = await widget.device.discoverServices();
      for (BluetoothService service in services) {
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          if (characteristic.properties.write) {
            final data = await _sendCommandToDevice();
            await characteristic.write(data, withoutResponse: true);
          }
        }
      }
    }
  }

  _sendCommandToDevice() async {
    CustomDeviceCredentials cd = CustomDeviceCredentials(
        // user: userAccountController.text,
        ssid: ssidController.text,
        password: passwordController.text);

    Map<String, dynamic> cdMap = cd.toJson();

    String cdString = jsonEncode(cdMap);
    final Uint8List convertedCommand = Uint8List.fromList(cdString.codeUnits);
    return convertedCommand;
  }

  Future _readprop() async {
    // for (flutter_blue.BluetoothCharacteristic c
    //     in service.characteristics) {
    //   if (c.properties.read) {
    //     List<int> messa = await c.read();
    //     String readconvert =
    //         String.fromCharCodes(Uint8List.fromList(messa));
    //     print("the read data is  $readconvert");
    //     // if (characteristic.uuid.toString() ==
    //     //     "6e400003-b5a3-f393-e0a9-e50e24dcca9e") {

    //     // }
    //   }
    // }
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
                    .asyncMap((_) => FlutterBluePlus.instance.connectedDevices),
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
                                        return const Text("Disconnected");
                                      }
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
                          await _login();
                          // await Future.delayed(
                          //     const Duration(milliseconds: 500));
                          await widget.device.discoverServices();
                        },
                        child: const Text("Sign in "),
                      )),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await _readprop();
                      // await Future.delayed(
                      //     const Duration(milliseconds: 500));
                      await widget.device.discoverServices();
                    },
                    child: const Text("Read Prop"),
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
