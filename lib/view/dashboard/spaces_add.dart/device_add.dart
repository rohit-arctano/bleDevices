import 'package:bldevice_connection/constant/colors_const.dart';
import 'package:bldevice_connection/constant/textstyle_constant.dart';
import 'package:bldevice_connection/view/auth/wifi_credential/wifi_setup.dart';
import 'package:flutter/material.dart';

import 'package:flutter_blue/flutter_blue.dart';

class FindDevicesScreen extends StatelessWidget {
  const FindDevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          //  RefreshIndicator(
          //   onRefresh: () => FlutterBlue.instance.startScan(
          //       scanMode: ScanMode.lowPower, timeout: const Duration(seconds: 4)),
          //   child:
          SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      GestureDetector(
                        child: const Icon(Icons.arrow_back, color: Colors.grey),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(
                        width: 100,
                      ),
                      const Text(
                        "Our Device List",
                        style: kDBXLTextStyle,
                      ),
                    ],
                  ),
                ),
                StreamBuilder<List<BluetoothDevice>>(
                  stream: Stream.periodic(const Duration(seconds: 1))
                      .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                  initialData: const [],
                  builder: (c, snapshot) => Column(
                    children: snapshot.data!
                        .map((d) => ListTile(
                              title: Text(d.name),
                              subtitle: Text(d.id.toString()),
                              trailing: StreamBuilder<BluetoothDeviceState>(
                                stream: d.state,
                                initialData: BluetoothDeviceState.disconnected,
                                builder: (c, snapshot) {
                                  if (snapshot.data ==
                                      BluetoothDeviceState.connected) {
                                    return ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    kPrimaryColor),
                                            textStyle:
                                                MaterialStateProperty.all(
                                                    const TextStyle(
                                                        fontSize:
                                                            kTextSizeSmall))),
                                        child: const Text('OPEN'),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      WifiSetUp(
                                                        device: d,
                                                      )));
                                        });
                                  }
                                  return Text(snapshot.data.toString());
                                },
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const Divider(),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Device Scan List",
                  style: kDBXLTextStyle,
                ),
                StreamBuilder<List<ScanResult>>(
                  stream: FlutterBlue.instance.scanResults,
                  initialData: const [],
                  builder: (c, snapshot) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: snapshot.data != null
                        ? snapshot.data!.map((r) {
                            if (r.device.name.contains("De")) {
                              return ListTile(
                                onTap: () async {
                                  await r.device.connect(
                                      autoConnect: true,
                                      timeout: const Duration(seconds: 2));
                                  print("your bluetooth device is coonected");
                                  // Navigator.of(context).push(
                                  //     MaterialPageRoute(builder: (context) {
                                  //   r.device.connect();
                                  //   return WifiSetUp(device: r.device);
                                  // }));
                                },
                                title: Text(r.device.name, style: kLTextStyle),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(r.device.id.toString(),
                                        style: kLTextStyle),
                                    Text(
                                      r.device.type.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                trailing: const CircleAvatar(
                                    radius: 25,
                                    backgroundColor: kPrimaryColor,
                                    child: Icon(
                                      Icons.bluetooth,
                                      color: kWhiteColor,
                                      size: 25,
                                    )),
                              );
                            } else {
                              return Container();
                            }
                          }).toList()
                        : [],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
              child: const Icon(Icons.stop),
            );
          } else {
            return FloatingActionButton(
                backgroundColor: kPrimaryColor,
                child: const Icon(Icons.search),
                onPressed: () => FlutterBlue.instance.startScan(
                    scanMode: ScanMode.lowPower,
                    timeout: const Duration(seconds: 1)));
          }
        },
      ),
    );
  }
}
