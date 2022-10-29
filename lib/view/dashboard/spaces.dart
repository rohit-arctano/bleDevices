import 'package:bldevice_connection/constant/textstyle_constant.dart';
import 'package:bldevice_connection/main.dart';
import 'package:bldevice_connection/view/dashboard/spaces_add.dart/add_spaces.dart';
import 'package:bldevice_connection/view/dashboard/spaces_add.dart/device_add.dart';
import 'package:bldevice_connection/widget/main_image_widget.dart';
import 'package:flutter/material.dart';

class Spaces extends StatefulWidget {
  const Spaces({super.key});

  @override
  State<Spaces> createState() => _SpacesState();
}

class _SpacesState extends State<Spaces> {
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
      // appBar: AppBar(
      //   actions: [IconButton(onPressed: () {}, icon: Icon(Icons.add))],
      //   title: const Text(
      //     "Spaces",
      //     textAlign: TextAlign.center,
      //   ),
      // ),
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
                      style: kDBXLTextStyle,
                      children: [TextSpan(text: "(4)", style: kLTextStyle)]),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              // FutureBuilder(
              //     //  future: getAdddedPlaceList(),
              //     builder: (BuildContext context, AsyncSnapshot snapshot) {
              //   if (snapshot.connectionState == ConnectionState.done) {
              //     // if (snapshot.hasData) {
              //     return
              MainImageWidget(
                imageHeight: deviceHeight * 0.45,
                imageWidth: deviceWidth * 0.5,
                mainboxHeight: deviceHeight * 0.45,
                textcontainerWidth: deviceWidth * 0.5,
              ),
              // } else {
              //   return Container(
              //     height: deviceHeight * 0.5,
              //     width: deviceWidth * 0.6,
              //     decoration: BoxDecoration(
              //         color: kLightBlue,
              //         borderRadius: BorderRadius.circular(20)),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: const [
              //         Text(
              //           "Add Device",
              //           style: kBXLTextStyle,
              //         ),
              //         Icon(
              //           Icons.add,
              //           size: 50,
              //         )
              //       ],
              //     ),
              //   );
              // }
              // } else {
              //   return const CircularProgressIndicator();
              // }
              // }
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
