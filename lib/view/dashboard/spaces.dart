import 'package:bldevice_connection/constant/textstyle_constant.dart';
import 'package:bldevice_connection/model/fb_user.dart';
import 'package:bldevice_connection/view/widget_view.dart';
import 'package:bldevice_connection/widget/main_image_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../shared_preferences/shared_preferences.dart';

class Spaces extends StatefulWidget {
  const Spaces({super.key});

  @override
  State<Spaces> createState() => _SpacesState();
}

class _SpacesState extends State<Spaces> {
  FbUser? userData;
  // Future getInstance() async {
  //   userData = await SavePreferences().getUserData();
  //   print(
  //       "the folowing data is ${userData!.uid} ${widget.placeId} ${widget.roomId}");
  //   deviceList = FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(userData?.uid)
  //       .collection("places")
  //       .doc(widget.placeId)
  //       .collection("rooms")
  //       .doc(widget.roomId)
  //       .collection("devices")
  //       .snapshots();
  //   return userData;
  // }

  void showMemberMenu() async {
    await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(300, 50, 20, 0),
      items: [
        PopupMenuItem(
            value: 1,
            child: TextButton(
              child: const Text(
                "Place",
                style: kBLTextStyle,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AddDevice()));
              },
            )),
        PopupMenuItem(
            value: 1,
            child: TextButton(
              child: const Text(
                "Device",
                style: kBLTextStyle,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FindDevicesScreen()));
              },
            )),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value != null) print(value);
    });
  }

  @override
  Widget build(BuildContext ctx) {
    double deviceHeight = MediaQuery.of(ctx).size.height;
    double deviceWidth = MediaQuery.of(ctx).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: const Icon(Icons.arrow_back, color: Colors.grey),
                    // onTap: () => scaffoldKey.currentState?.openDrawer(),
                  ),
                  const Text(
                    "Spaces",
                    style: kDBXLTextStyle,
                  ),
                  IconButton(
                      onPressed: () {
                        showMemberMenu();
                      },
                      icon: const Icon(Icons.add))
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text.rich(
                  TextSpan(
                      text: "ROOM",
                      style: kBLTextStyle,
                      children: [TextSpan(text: "(4)", style: kLTextStyle)]),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              // MainImageWidget(
              //   imageHeight: deviceHeight * 0.45,
              //   imageWidth: deviceWidth * 0.5,
              //   mainboxHeight: deviceHeight * 0.45,
              //   textcontainerWidth: deviceWidth * 0.5,
              // ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text.rich(
                  TextSpan(
                      text: "Devices",
                      style: kDBXLTextStyle,
                      children: [TextSpan(text: "(12)", style: kLTextStyle)]),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
