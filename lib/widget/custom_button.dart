import 'package:bldevice_connection/constant/colors_const.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  final GestureTapCallback? onTap;
  final Color? colors;
  Widget childWidget;

  CustomButton({Key? key, required this.childWidget, this.onTap, this.colors})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: RawMaterialButton(
        fillColor: colors,
        onPressed: onTap,
        splashColor: Colors.black12,
        elevation: 2.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
            side: const BorderSide(width: 2, color: kL1)),
        child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 18.0),
            child: childWidget),
      ),
    );
  }
}
