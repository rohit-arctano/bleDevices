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
    return RawMaterialButton(
      fillColor: colors,
      onPressed: onTap,
      shape: const StadiumBorder(),
      child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 10, 6, 10), child: childWidget),
    );
  }
}
