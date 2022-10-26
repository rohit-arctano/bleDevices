import 'dart:async';
import 'dart:typed_data';
import 'package:bldevice_connection/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FlutterBlueApp());
}

class FlutterBlueApp extends StatelessWidget {
  const FlutterBlueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.lightBlue,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return const SplashScreen();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.state}) : super(key: key);

  final BluetoothState? state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              // style: Theme.of(context)
              //     .primaryTextTheme
              //     .subhead
              //     ?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatelessWidget {
  const FindDevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Devices'),
      ),
      body:
          //  RefreshIndicator(
          //   onRefresh: () => FlutterBlue.instance.startScan(
          //       scanMode: ScanMode.lowPower, timeout: const Duration(seconds: 4)),
          //   child:
          SingleChildScrollView(
        child: Column(
          children: [
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
                                  onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
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
                    ? snapshot.data!
                        .map(
                          (r) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  r.device.connect();
                                  return DeviceScreen(device: r.device);
                                }));
                              },
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
          ],
        ),
      ),
      // ),
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
            return FloatingActionButton(
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

// ignore: must_be_immutable
class DeviceScreen extends StatelessWidget {
  DeviceScreen({Key? key, required this.device}) : super(key: key);

  final BluetoothDevice device;

  TextEditingController textEditingController = TextEditingController();

  List<Widget> _buildServiceTiles(
      BuildContext context, List<BluetoothService> services) {
    // ignore: unnecessary_null_comparison
    return services != null
        ? services
            .map((s) => ServiceTile(
                service: s,
                characteristicTiles: s.characteristics
                    .map((c) => CharacteristicTile(
                          characteristic: c,
                          onReadPressed: () => c.read(),
                          onWritePressed: () async {
                            var result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      FullScreenDialog(),
                                  fullscreenDialog: true,
                                ));
                            if (result != null) {
                              if (result is String) {
                                await c.write(result.codeUnits,
                                    withoutResponse: true);
                                await c.read();
                              }
                            }
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
                                      var result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                FullScreenDialog(),
                                            fullscreenDialog: true,
                                          ));
                                      if (result != null) {
                                        if (result is String) {
                                          await c.write(result.codeUnits,
                                              withoutResponse: true);
                                          await c.read();
                                        }
                                      }
                                    }),
                              )
                              .toList(),
                        ))
                    .toList()))
            .toList()
        : [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback? onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () => device.disconnect();
                  text = 'DISCONNECT';
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () => device.connect();
                  text = 'CONNECT';
                  break;
                default:
                  onPressed = null;
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return ElevatedButton(
                  onPressed: onPressed,
                  child: Text(
                    text,
                  ));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<BluetoothDeviceState>(
                stream: device.state,
                initialData: BluetoothDeviceState.connecting,
                builder: (c, snapshot) {
                  return ListTile(
                    leading: (snapshot.data == BluetoothDeviceState.connected)
                        ? const Icon(Icons.bluetooth_connected)
                        : const Icon(Icons.bluetooth_disabled),
                    title: Text(
                        'Device is ${snapshot.data.toString().split('.')[1]}.'),
                    subtitle: Text(device.toString()),
                    trailing: StreamBuilder<bool>(
                      stream: device.isDiscoveringServices,
                      initialData: false,
                      builder: (c, snapshot) => IndexedStack(
                        index: snapshot.data! ? 1 : 0,
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: () => device.discoverServices(),
                          ),
                          const IconButton(
                            icon: SizedBox(
                              width: 18.0,
                              height: 18.0,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(Colors.grey),
                              ),
                            ),
                            onPressed: null,
                          )
                        ],
                      ),
                    ),
                  );
                }),
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
    );
  }
}

// ignore: must_be_immutable
class FullScreenDialog extends StatefulWidget {
  const FullScreenDialog({super.key});

  @override
  FullScreenDialogState createState() => FullScreenDialogState();
}

class FullScreenDialogState extends State<FullScreenDialog> {
  TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("PLease send the Text"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView(
            children: [
              TextField(
                controller: textController,
              ),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(textController.text);
                    },
                    child: const Text("Save"),
                  ))
                ],
              )
            ],
          ),
        ));
  }
}

class CharacteristicTile extends StatelessWidget {
  final BluetoothCharacteristic characteristic;
  final List<DescriptorTile> descriptorTiles;
  final VoidCallback? onReadPressed;
  final VoidCallback? onWritePressed;
  final VoidCallback? onNotificationPressed;

  const CharacteristicTile(
      {Key? key,
      required this.characteristic,
      required this.descriptorTiles,
      this.onReadPressed,
      this.onWritePressed,
      this.onNotificationPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
      stream: characteristic.value,
      initialData: characteristic.lastValue,
      builder: (c, snapshot) {
        return ExpansionTile(
          title: ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text((() {
                  if (characteristic.uuid.toString() ==
                      "beb5483e-36e1-4688-b7f5-ea07361b26a8") {
                    return "Read";
                  } else if (characteristic.uuid.toString() ==
                      "beb6483e-36e1-4688-b7f5-ea07361b26a8") {
                    return "Write";
                  }
                  return " ";
                })()),
                Text(
                    // '0x${characteristic.uuid.toString().toUpperCase()}',
                    '${characteristic.uuid}')
              ],
            ),
            subtitle: Text(
                String.fromCharCodes(Uint8List.fromList(snapshot.data ?? []))),
            contentPadding: const EdgeInsets.all(0.0),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.file_download,
                  color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
                ),
                onPressed: onReadPressed,
              ),
              IconButton(
                icon: Icon(Icons.file_upload,
                    color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
                onPressed: onWritePressed,
              ),
              IconButton(
                icon: Icon(
                    characteristic.isNotifying
                        ? Icons.sync_disabled
                        : Icons.sync,
                    color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
                onPressed: onNotificationPressed,
              )
            ],
          ),
          children: descriptorTiles,
        );
      },
    );
  }
}

class ServiceTile extends StatelessWidget {
  final BluetoothService service;
  final List<CharacteristicTile> characteristicTiles;

  const ServiceTile(
      {Key? key, required this.service, required this.characteristicTiles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (characteristicTiles.isNotEmpty) {
      return ExpansionTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Service'),
            Text('${service.uuid}'

                // '0x${service.uuid.toString().toUpperCase().substring(4, 8)}',
                ),
            // Text(service.toString())
          ],
        ),
        children: characteristicTiles,
      );
    } else {
      return ListTile(
        title: const Text('Service'),
        subtitle: Text(
            // '0x${service.uuid.toString().toUpperCase().substring(4, 8)}'
            '${service.uuid}'),
      );
    }
  }
}

class DescriptorTile extends StatelessWidget {
  final BluetoothDescriptor descriptor;
  final VoidCallback? onReadPressed;
  final VoidCallback? onWritePressed;

  const DescriptorTile(
      {Key? key,
      required this.descriptor,
      this.onReadPressed,
      this.onWritePressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Descriptor'),
          Text(
            '0x${descriptor.uuid.toString().toUpperCase().substring(4, 8)}',
          )
        ],
      ),
      subtitle: StreamBuilder<List<int>>(
        stream: descriptor.value,
        initialData: descriptor.lastValue,
        builder: (c, snapshot) => Text(snapshot.data.toString()),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.file_download,
              color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
            ),
            onPressed: onReadPressed,
          ),
          IconButton(
            icon: Icon(
              Icons.file_upload,
              color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
            ),
            onPressed: onWritePressed,
          )
        ],
      ),
    );
  }
}
