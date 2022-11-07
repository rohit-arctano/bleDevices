import 'dart:ui';

import 'package:bldevice_connection/constant/colors_const.dart';
import 'package:bldevice_connection/constant/textstyle_constant.dart';
import 'package:bldevice_connection/widget/custom_button.dart';
import 'package:bldevice_connection/widget/customtextField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PopUpTemplate extends StatelessWidget {
  PopUpTemplate({
    Key? key,
    // required this.child,
  }) : super(key: key);

  // final Widget child;
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: const Alignment(0, 0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: const DecoratedBox(
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.1),
              ),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(0, 0),
          child: FractionallySizedBox(
            heightFactor: 0.5,
            widthFactor: 0.9,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(
                      isObscure: false,
                      controller: textController,
                      data: Icons.device_thermostat,
                      hintText: "Add the switch Name"),
                  CustomButton(
                    onTap: () {
                      Navigator.of(context).pop(textController.text);
                    },
                    colors: kPrimaryColor,
                    childWidget: const Text(
                      "Save",
                      style: kWLTextStyle,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
