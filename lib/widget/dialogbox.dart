import 'dart:ui';
import 'package:bldevice_connection/constant/container_design.dart';
import 'package:bldevice_connection/constant/widget.dart';
import 'package:bldevice_connection/widget/widget.dart';
import 'package:flutter/material.dart';

class PopUpTemplate extends StatelessWidget {
  PopUpTemplate({
    Key? key,
    required this.hintText,
    // required this.child,
  }) : super(key: key);

  // final Widget child;
  final String hintText;
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: const Alignment(0, 0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: .5, sigmaY: 0.5),
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
            heightFactor: 0.4,
            widthFactor: 0.9,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: CustomTextField(
                        isObscure: false,
                        controller: textController,
                        data: Icons.room_preferences_sharp,
                        hintText: hintText),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomButton(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        colors: kPrimaryColor,
                        childWidget: const Padding(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Text(
                            "Back",
                            style: kWLTextStyle,
                          ),
                        ),
                      ),
                      CustomButton(
                        onTap: () {
                          Navigator.of(context).pop(textController.text);
                        },
                        colors: kPrimaryColor,
                        childWidget: const Padding(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Text(
                            "Save",
                            style: kWLTextStyle,
                          ),
                        ),
                      ),
                    ],
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
