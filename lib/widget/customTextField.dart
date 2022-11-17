import 'package:bldevice_connection/constant/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key,
      required this.controller,
      required this.data,
      required this.hintText,
      this.enabled = true,
      this.isObscure = true,
      this.labelText,
      this.suffixAdd,
      this.onValidation,
      this.mobileNum,
      this.keyType,
      this.inputFormatters,
      this.onTextChanged})
      : super(key: key);

  final TextEditingController? controller;
  final IconData? data;
  final String? hintText;
  final Widget? labelText;
  final bool isObscure;
  final bool enabled;
  final Widget? suffixAdd;
  final TextInputType? keyType;
  final int? mobileNum;
  final String? Function(String?)? onValidation;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onTextChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        enabled: enabled,
        inputFormatters: inputFormatters,
        obscureText: isObscure,
        controller: controller,
        cursorColor: Theme.of(context).primaryColor,
        validator: (String? value) {
          if (onValidation != null) {
            return onValidation!(value);
          }
          return null;
        },
        onChanged: onTextChanged,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide(color: kGreyColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide(color: kredcolor, width: 2),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide(color: kPrimaryColor, width: 2),
            ),
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
