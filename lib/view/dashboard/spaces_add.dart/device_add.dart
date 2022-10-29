import 'package:bldevice_connection/constant/colors_const.dart';
import 'package:bldevice_connection/constant/textstyle_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'device_screen.dart';

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
              children: [
                SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      GestureDetector(
                        child: const Icon(Icons.arrow_back, color: Colors.grey),
                        // onTap: () => scaffoldKey.currentState?.openDrawer(),
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
                const SizedBox(
                  height: 20,
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
                                      child: const Text('OPEN'),
                                      onPressed: () => Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  DeviceScreen(device: d))),
                                    );
                                  }
                                  return Text(snapshot.data.toString());
                                },
                              ),
                            ))
                        .toList(),
                  ),
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
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    r.device.connect();
                                    return DeviceScreen(device: r.device);
                                  }));
                                },
                                title:
                                    Text(r.device.name, style: kDBXLTextStyle),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(r.device.id.toString(),
                                        style: kBXLTextStyle),
                                    Text(
                                      r.device.type.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                                trailing: const CircleAvatar(
                                    radius: 25,
                                    backgroundColor: kDarkGreyColor,
                                    child: Icon(
                                      Icons.bluetooth,
                                      color: kWhiteColor,
                                      size: 30,
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
