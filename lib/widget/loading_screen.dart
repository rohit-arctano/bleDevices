import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LoadingDialog extends StatelessWidget {
  LoadingDialog({Key? key, required this.message}) : super(key: key);
  final String? message;
  // bool? pos=false;
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return AlertDialog(
      key: key,
      backgroundColor: Colors.transparent,
      content: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            circularProgress(),
            SizedBox(
              height: 10,
            ),
            Text(message! + ". Please wait...")
          ],
        ),
      ),
    );
  }

  Widget circularProgress() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 12),
      child: const CircularProgressIndicator(
          // valueColor: AlwaysStoppedAnimation(Colors.amber),
          ),
    );
  }
}
