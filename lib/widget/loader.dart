import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;
  const Loader({Key? key, this.height, this.color, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: CircularProgressIndicator(
        color: color,
      ),
    );
  }
}
