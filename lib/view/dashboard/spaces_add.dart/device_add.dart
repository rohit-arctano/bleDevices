import 'package:bldevice_connection/constant/colors_const.dart';
import 'package:bldevice_connection/constant/container_design.dart';
import 'package:bldevice_connection/constant/textstyle_constant.dart';
import 'package:bldevice_connection/view/auth/wifi_credential/wifi_setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class FindDevicesScreen extends StatefulWidget {
  const FindDevicesScreen({super.key});

  @override
  State<FindDevicesScreen> createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
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
                            return Column(
                              children: snapshot.data!
                                  .map((d) => ListTile(
                                        title: Text(d.name),
                                        subtitle: Text(d.id.toString()),
                                        trailing:
                                            StreamBuilder<BluetoothDeviceState>(
                                          stream: d.state,
                                          initialData:
                                              BluetoothDeviceState.disconnected,
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
                                                                      device: d,
                                                                    )));
                                                  });
                                            }
                                            return Text(
                                                snapshot.data.toString());
                                          },
                                        ),
                                      ))
                                  .toList(),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: snapshot.data != null
                            ? snapshot.data!
                                .map(
                                  (r) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        // Navigator.of(context)
                                        //     .push(MaterialPageRoute(builder: (context) {
                                        //   r.device.connect();
                                        //   return DeviceScreen(device: r.device);
                                        // }));
                                      },
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              r.device.id.toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18),
                                            ),
                                            Text(
                                              r.device.name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 18),
                                            ),
                                            Text(
                                              r.device.type.toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 18),
                                            ),
                                            const Divider(
                                              color: Colors.black,
                                            )
                                          ]),
                                    ),
                                  ),
                                )
                                .toList()
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
              StreamBuilder<bool>(
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
                        child: const Icon(Icons.search),
                        onPressed: () => FlutterBlue.instance.startScan(
                            scanMode: ScanMode.lowPower,
                            timeout: const Duration(seconds: 1)));
                  }
                },
              )
            ],
          ),
        ),
      ),

      // ),
    );
  }
}
