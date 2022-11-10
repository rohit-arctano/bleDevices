import "package:bldevice_connection/main.dart";
import 'package:bldevice_connection/view/auth/wifi_credential/wifi_setup.dart';
import "package:flutter/material.dart";
import "package:flutter_blue/flutter_blue.dart";

class ScannningDevices extends StatefulWidget {
  const ScannningDevices({super.key});

  @override
  State<ScannningDevices> createState() => _ScannningDevicesState();
}

class _ScannningDevicesState extends State<ScannningDevices> {
  bool isNextPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanning Page'),
      ),
      body: RefreshIndicator(
        onRefresh: () => FlutterBlue.instance.startScan(
            scanMode: ScanMode.lowPower, timeout: const Duration(seconds: 2)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: const [],
                builder: (c, snapshot) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: snapshot.data != null
                      ? snapshot.data!.map((r) {
                          if (r.device.name.contains("Device")) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        title: Text(
                                          r.device.id.toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18),
                                        ),
                                        subtitle: Text(
                                          r.device.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 18),
                                        ),
                                        trailing:
                                            StreamBuilder<BluetoothDeviceState>(
                                          stream: r.device.state,
                                          initialData:
                                              BluetoothDeviceState.connecting,
                                          builder: (c, snapshot) {
                                            VoidCallback? onPressed;
                                            String text;
                                            switch (snapshot.data) {
                                              case BluetoothDeviceState
                                                  .connected:
                                                onPressed = () async {
                                                  return await r.device
                                                      .disconnect();
                                                };
                                                text = 'DISCONNECT';
                                                break;
                                              case BluetoothDeviceState
                                                  .disconnected:
                                                onPressed =
                                                    () => r.device.connect();
                                                text = 'CONNECT';
                                                break;
                                              default:
                                                onPressed = null;
                                                text = snapshot.data
                                                    .toString()
                                                    .substring(21)
                                                    .toUpperCase();
                                                break;
                                            }
                                            return ElevatedButton(
                                                onPressed: onPressed,
                                                child: Text(
                                                  text,
                                                ));
                                          },
                                        ),
                                      ),
                                      const Divider(
                                        color: Colors.black,
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             const WifiSetUp()));
                                          },
                                          child:
                                              Text("Next page to WIfi set uup"))
                                    ]),
                              ),
                            );
                          }
                          return Container();
                        }).toList()
                      : [],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
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
            return FloatingActionButton.extended(
                label: const Text("Scan"),
                onPressed: () => FlutterBlue.instance.startScan(
                    scanMode: ScanMode.lowPower,
                    timeout: const Duration(seconds: 1)));
          }
        },
      ),
    );
  }
}
