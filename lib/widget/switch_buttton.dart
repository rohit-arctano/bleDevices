import 'package:bldevice_connection/constant/colors_const.dart';
import 'package:flutter/material.dart';

class SwitchScreen extends StatefulWidget {
  SwitchScreen({required this.onTap, required this.status, super.key});
  String status;
  final Function(bool)? onTap;
  @override
  State<SwitchScreen> createState() => _SwitchScreenState();
}

class _SwitchScreenState extends State<SwitchScreen> {
  bool isSwitched = false;
  var textValue = 'Switch is OFF';

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        textValue = 'Switch Button is ON';
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isSwitched = false;
        textValue = 'Switch Button is OFF';
      });
      print('Switch Button is OFF');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
        scale: 1.5,
        child: Switch(
          onChanged: widget.onTap,
          value: widget.status.toLowerCase() != "false",
          activeColor: kLightGreyColor,
          activeTrackColor: kPrimaryColor,
          inactiveTrackColor: kLightGreyColor,
          inactiveThumbColor: kPrimaryColor,
        ));
  }
}
