import 'package:app_settings/app_settings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart' show BluetoothState;

class BluetoothOffScreen extends StatefulWidget {
  const BluetoothOffScreen({Key? key, this.state}) : super(key: key);

  final BluetoothState? state;

  @override
  State<BluetoothOffScreen> createState() => _BluetoothOffScreenState();
}

class _BluetoothOffScreenState extends State<BluetoothOffScreen> {
  final TapGestureRecognizer _recognizer = TapGestureRecognizer();

  @override
  void initState() {
    super.initState();
    _recognizer.onTap = () async {
      print("Settings");
      await AppSettings.openBluetoothSettings();
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.bluetooth_disabled,
              size: 100.0,
              color: Color.fromRGBO(0, 117, 189, 1),
            ),
            Text.rich(
              TextSpan(
                text:
                    'Bluetooth is ${widget.state != null ? widget.state!.name.toUpperCase() : 'not available'}.',
                style: const TextStyle(
                  fontSize: 24,
                ),
                children: [
                  const TextSpan(text: '\nTurn on bluetooth to proceed'),
                  TextSpan(
                    text: '\nClick to go to settings',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                    ),
                    recognizer: _recognizer,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
