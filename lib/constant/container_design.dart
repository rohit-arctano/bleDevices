import 'package:bldevice_connection/constant/widget.dart';
import 'package:flutter/material.dart';

BoxDecoration productCon = BoxDecoration(
  borderRadius: BorderRadius.circular(12),
  // color: kWhiteColor,
  color: Colors.white,

  boxShadow: [
    BoxShadow(
      color: kDarkGreyColor.withOpacity(0.25),
      spreadRadius: 2,
      blurRadius: 5,
      offset: const Offset(0, 0), // changes position of shadow
    ),
  ],
  border: Border.all(
    color: kLightGreyColor,
    width: 3,
  ),
);
BoxDecoration boxDecoration(
    {double radius = 2,
    Color color = Colors.transparent,
    Color? bgColor,
    var showShadow = false}) {
  return BoxDecoration(
    color: kWhiteColor,
    border: Border.all(color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}
