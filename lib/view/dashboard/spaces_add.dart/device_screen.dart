import 'package:bldevice_connection/constant/textstyle_constant.dart';
import 'package:bldevice_connection/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

// ignore: must_be_immutable
class DeviceScreen extends StatelessWidget {
  DeviceScreen({Key? key, required this.device}) : super(key: key);

  final BluetoothDevice device;

  TextEditingController textEditingController = TextEditingController();

  List<Widget> _buildServiceTiles(
      BuildContext context, List<BluetoothService> services) {
    // ignore: unnecessary_null_comparison

    void _discoverDeviceServices() async {
      for (BluetoothService service in services) {
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          var value = await characteristic.read();
          print(value);
          // print(AsciiDecoder().convert(value)); /*** TAG-1***/
          // print(utf8.decode(value)); /*** TAG-2***/
          if (characteristic.properties.write) {
            if (characteristic.properties.notify) {
              // _rx_Write_Characteristic = characteristic;
              // _sendCommandToDevice();
            }
          }
        }
      }
    }

    return services != null
        ? services
            .map((s) => ServiceTile(
                service: s,
                characteristicTiles: s.characteristics.map((c) {
                  return CharacteristicTile(
                    characteristic: c,
                    onReadPressed: () => c.read(),
                    onWritePressed: () async {
                      // var result = await Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (BuildContext context) =>
                      //           const FullScreenDialog(),
                      //       fullscreenDialog: true,
                      //     ));
                      // if (result != null) {
                      //   if (result is String) {
                      //     await c.write(result.codeUnits,
                      //         withoutResponse: true);
                      //     await c.read();
                      //   }
                      // }
                    },
                    onNotificationPressed: () async {
                      await c.setNotifyValue(!c.isNotifying);
                      await c.read();
                    },
                    descriptorTiles: c.descriptors
                        .map(
                          (d) => DescriptorTile(
                              descriptor: d,
                              onReadPressed: () => d.read(),
                              onWritePressed: () async {
                                // var result = await Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (BuildContext context) =>
                                //           const FullScreenDialog(),
                                //       fullscreenDialog: true,
                                //     ));
                                // if (result != null) {
                                //   if (result is String) {
                                //     await c.write(result.codeUnits,
                                //         withoutResponse: true);
                                //     await c.read();
                                //   }
                                // }
                              }),
                        )
                        .toList(),
                  );
                }).toList()))
            .toList()
        : [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(device.name),
      //   actions: <Widget>[
      //     StreamBuilder<BluetoothDeviceState>(
      //       stream: device.state,
      //       initialData: BluetoothDeviceState.connecting,
      //       builder: (c, snapshot) {
      //         VoidCallback? onPressed;
      //         String text;
      //         switch (snapshot.data) {
      //           case BluetoothDeviceState.connected:
      //             onPressed = () => device.disconnect();
      //             text = 'DISCONNECT';
      //             break;
      //           case BluetoothDeviceState.disconnected:
      //             onPressed = () => device.connect();
      //             text = 'CONNECT';
      //             break;
      //           default:
      //             onPressed = null;
      //             text = snapshot.data.toString().substring(21).toUpperCase();
      //             break;
      //         }
      //         return ElevatedButton(
      //             onPressed: onPressed,
      //             child: Text(
      //               text,
      //             ));
      //       },
      //     )
      //   ],
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
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
                    Text(
                      device.name,
                      style: kDBXLTextStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // StreamBuilder<BluetoothDeviceState>(
              //     stream: device.state,
              //     initialData: BluetoothDeviceState.connecting,
              //     builder: (c, snapshot) {
              //       return ListTile(
              //         leading: (snapshot.data == BluetoothDeviceState.connected)
              //             ? const Icon(Icons.bluetooth_connected)
              //             : const Icon(Icons.bluetooth_disabled),
              //         title: Text(
              //             'Device is ${snapshot.data.toString().split('.')[1]}.'),
              //         subtitle: Text(device.toString()),
              //         trailing: StreamBuilder<bool>(
              //           stream: device.isDiscoveringServices,
              //           initialData: false,
              //           builder: (c, snapshot) => IndexedStack(
              //             index: snapshot.data! ? 1 : 0,
              //             children: <Widget>[
              //               IconButton(
              //                 icon: const Icon(Icons.refresh),
              //                 onPressed: () => device.discoverServices(),
              //               ),
              //               const IconButton(
              //                 icon: SizedBox(
              //                   width: 18.0,
              //                   height: 18.0,
              //                   child: CircularProgressIndicator(
              //                     valueColor:
              //                         AlwaysStoppedAnimation(Colors.grey),
              //                   ),
              //                 ),
              //                 onPressed: null,
              //               )
              //             ],
              //           ),
              //         ),
              //       );
              //     }),
              StreamBuilder<int>(
                stream: device.mtu,
                initialData: 0,
                builder: (c, snapshot) => ListTile(
                  title: const Text('MTU Size'),
                  subtitle: Text('${snapshot.data} bytes'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => device.requestMtu(223),
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    device.discoverServices();
                  },
                  child: const Text("SHow the services")),
              StreamBuilder<List<BluetoothService>>(
                stream: device.services,
                initialData: const [],
                builder: (c, snapshot) {
                  return Column(
                    children: _buildServiceTiles(context, snapshot.data ?? []),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
