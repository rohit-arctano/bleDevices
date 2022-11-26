import 'package:bldevice_connection/constant/colors_const.dart';
import 'package:bldevice_connection/constant/container_design.dart';
import 'package:bldevice_connection/constant/textstyle_constant.dart';
import 'package:bldevice_connection/view/auth/wifi_credential/wifi_setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';

class FindDevicesScreen extends StatefulWidget {
  const FindDevicesScreen({super.key});

  @override
  State<FindDevicesScreen> createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      StreamBuilder<List<BluetoothDevice>>(
                          stream: Stream.periodic(const Duration(seconds: 2))
                              .asyncMap(
                                  (_) => FlutterBlue.instance.connectedDevices),
                          initialData: const [],
                          builder: (c, snapshot) {
                            if (snapshot.hasData) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: snapshot.data!
                                      .map((d) => ListTile(
                                            title: Text(d.name),
                                            subtitle: Text(d.id.toString()),
                                            trailing: StreamBuilder<
                                                BluetoothDeviceState>(
                                              stream: d.state,
                                              initialData: BluetoothDeviceState
                                                  .disconnected,
                                              builder: (c, snapshot) {
                                                if (snapshot.data ==
                                                    BluetoothDeviceState
                                                        .connected) {
                                                  return ElevatedButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(
                                                                      kPrimaryColor),
                                                          textStyle: MaterialStateProperty
                                                              .all(const TextStyle(
                                                                  fontSize:
                                                                      kTextSizeSmall))),
                                                      child: const Text('OPEN'),
                                                      onPressed: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        WifiSetUp(
                                                                          device:
                                                                              d,
                                                                        )));
                                                      });
                                                }
                                                return Text(
                                                    snapshot.data.toString());
                                              },
                                            ),
                                          ))
                                      .toList(),
                                ),
                              );
                            } else {
                              return const Center(
                                  child: Text("No device Connected"));
                            }
                          }),
                      const Text(
                        "Device Scan List",
                        style: kDBXLTextStyle,
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      StreamBuilder<List<ScanResult>>(
                        stream: FlutterBlue.instance.scanResults,
                        initialData: const [],
                        builder: (c, snapshot) => Column(
                          children: snapshot.data != null
                              ? snapshot.data!.map((r) {
                                  // print("the scan result${r.device.id}");
                                  // if (r.device.name.contains("De")) {
                                  return Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(6),
                                        decoration: productCon,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListTile(
                                            onTap: () async {
                                              await r.device
                                                  .connect(
                                                autoConnect: true,
                                              )
                                                  .then(
                                                (value) async {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return WifiSetUp(
                                                        device: r.device);
                                                  }));
                                                },
                                              );
                                            },
                                            title: Text(r.device.name,
                                                style: kLTextStyle),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(r.device.id.toString(),
                                                    style: kLTextStyle),
                                                Text(
                                                  r.device.type.toString(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                            trailing: const CircleAvatar(
                                                radius: 25,
                                                backgroundColor: kDarkGreyColor,
                                                child: Icon(
                                                  Icons.bluetooth,
                                                  color: kWhiteColor,
                                                  size: 25,
                                                )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                  // } else {
                                  //   return Container();
                                  // }
                                }).toList()
                              : [],
                        ),
                      ),
                      // StreamBuilder<List<ScanResult>>(
                      //     stream: FlutterBlue.instance.scanResults,
                      //     initialData: const [],
                      //     builder: (c, snapshot) {
                      //       print("the scan result first${snapshot.data}");
                      //       return Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: snapshot.data != null
                      //             ? snapshot.data!.map((r) {
                      //                 print("the scan result${r.device.id}");
                      //                 // if (r.device.name.contains("De")) {
                      //                 return Container(
                      //                   margin: const EdgeInsets.all(6),
                      //                   decoration: productCon,
                      //                   child: Padding(
                      //                     padding: const EdgeInsets.all(8.0),
                      //                     child: ListTile(
                      //                       onTap: () async {
                      //                         await r.device.connect(
                      //                             autoConnect: true,
                      //                             timeout:
                      //                                 const Duration(seconds: 2));
                      //                         print(
                      //                             "your bluetooth device is coonected");
                      //                         Navigator.of(context).push(
                      //                             MaterialPageRoute(
                      //                                 builder: (context) {
                      //                           r.device.connect();
                      //                           return WifiSetUp(
                      //                               device: r.device);
                      //                         }));
                      //                       },
                      //                       title: Text(r.device.name,
                      //                           style: kLTextStyle),
                      //                       subtitle: Column(
                      //                         crossAxisAlignment:
                      //                             CrossAxisAlignment.start,
                      //                         children: [
                      //                           Text(r.device.id.toString(),
                      //                               style: kLTextStyle),
                      //                           Text(
                      //                             r.device.type.toString(),
                      //                             style: const TextStyle(
                      //                                 fontWeight: FontWeight.w300,
                      //                                 fontSize: 16),
                      //                           ),
                      //                         ],
                      //                       ),
                      //                       trailing: const CircleAvatar(
                      //                           radius: 25,
                      //                           backgroundColor: kDarkGreyColor,
                      //                           child: Icon(
                      //                             Icons.bluetooth,
                      //                             color: kWhiteColor,
                      //                             size: 25,
                      //                           )),
                      //                     ),
                      //                   ),
                      //                 );
                      //                 // } else {
                      //                 //   return Container();
                      //                 // }
                      //               }).toList()
                      //             : [],
                      //       );
                      //     }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: StreamBuilder<bool>(
              stream: FlutterBlue.instance.isScanning,
              initialData: false,
              builder: (c, snapshot) {
                if (snapshot.data!) {
                  return FloatingActionButton(
                    child: Icon(Icons.stop),
                    onPressed: () => FlutterBlue.instance.stopScan(),
                    backgroundColor: Colors.red,
                  );
                } else {
                  return FloatingActionButton(
                    child: const Icon(
                      Icons.search,
                    ),
                    onPressed: () async {
                      PermissionStatus status =
                          await Permission.bluetoothScan.request();
                      if (status.isGranted) {
                        await FlutterBlue.instance.startScan(
                            scanMode: ScanMode.lowPower,
                            timeout: const Duration(seconds: 1));
                        // We didn't ask for permission yet or the permission has been denied before but not permanently.
                      }

// You can can also directly ask the permission about its status.
                      if (await Permission.location.isRestricted) {
                        //
                      }
                    },
                    backgroundColor: kPrimaryColor,
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
