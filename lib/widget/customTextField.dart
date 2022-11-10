import 'package:bldevice_connection/constant/textstyle_constant.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.data,
    required this.hintText,
    this.enabled = true,
    this.isObscure = true,
    this.labelText,
    this.suffixAdd,
    this.onValidation,
  }) : super(key: key);

  final TextEditingController? controller;
  final IconData? data;
  final String? hintText;
  final Widget? labelText;
  final bool isObscure;
  final bool enabled;
  final Widget? suffixAdd;
  final String? Function(String?)? onValidation;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      // margin: const EdgeInsets.all(5),
      child: TextFormField(
        enabled: enabled,
        obscureText: isObscure,
        controller: controller,
        cursorColor: Theme.of(context).primaryColor,
        validator: (String? value) {
          if (onValidation != null) {
            return onValidation!(value);
          }
          return null;
        },
        decoration: InputDecoration(
            hintStyle: kGreyTextStyle,
            suffixIcon: suffixAdd,
            label: labelText,
            border: InputBorder.none,
            prefixIcon: Icon(
              data,
              color: Colors.cyan,
            ),
            focusColor: Theme.of(context).primaryColor,
            hintText: hintText),
      ),
    );
  }
}
