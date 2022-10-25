import 'package:flutter/material.dart';

// ignore: camel_case_types, must_be_immutable
class ErrorMessage extends StatelessWidget {
  ErrorMessage({Key? key, required this.message, this.pos}) : super(key: key);
  final String? message;
  bool? pos = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(message!),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Center(
            child: Text("Ok"),
          ),
          style: ElevatedButton.styleFrom(
              primary: pos! ? Colors.blue : Colors.red),
        )
      ],
    );
  }
}
