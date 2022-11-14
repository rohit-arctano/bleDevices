import 'package:bldevice_connection/constant/colors_const.dart';
import 'package:bldevice_connection/constant/container_design.dart';
import 'package:bldevice_connection/constant/textstyle_constant.dart';
import 'package:bldevice_connection/model/fb_user.dart';
import 'package:bldevice_connection/view/widget_view.dart';
import 'package:bldevice_connection/widget/main_image_widget.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              DefaultTabController(
                length: 2,
                initialIndex: 0,
                child: Column(
                  children: [
                    const TabBar(
                      indicator: BoxDecoration(
                        color: kDarkGreyColor,
                      ),
                      physics: ScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      labelColor: kWhiteColor,
                      unselectedLabelColor: kBlackColor,
                      tabs: [
                        Tab(text: 'Places'),
                        Tab(text: 'Devices'),
                      ],
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height *
                            0.80, //height of TabBarView

                        child: const TabBarView(children: <Widget>[
                          AddDevice(),

                          FindDevicesScreen()
                          //   );
                          // }),
                        ])),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
