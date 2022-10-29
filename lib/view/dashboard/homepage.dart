import 'package:bldevice_connection/constant/widget.dart';
import 'package:bldevice_connection/model/space_model.dart';
import 'package:bldevice_connection/view/drawer.dart';
import 'package:bldevice_connection/widget/main_image_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import "package:flutter/material.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // late List<dynamic> place;
  // late Map<dynamic, dynamic> listofPlace;
  bool buttonSelected = false;
  Size? screenSize;
  var position = 0;
  double xOffset = 0;
  double yOffset = 0;

  bool isDrawerOpen = false;

  Future getAdddedPlaceList() async {
    final document = FirebaseDatabase.instance
        .ref("users")
        .child("home")
        // .child(widget.dev)
        // .child("SWITCHES")
        .ref;

    Map<dynamic, dynamic> pla = {};
    await document.once().then((DatabaseEvent value) {
      value.snapshot.value as Map<dynamic, dynamic>;
      pla.addAll({
        "home": {
          "image": "",
          "room": {
            "device": {
              "switch": {
                1: {"icon": "", "name": "", "status": ""}
              }
            }
          }
        }
      });
    });
    print("the data is $pla");
    return document;
  }

  @override
  void initState() {
    super.initState();
    // getAdddedPlaceList();
    fetchData();
  }

  List<String> banners = [];
  var scaffoldKey = GlobalKey<ScaffoldState>();

  fetchData() async {
    List<String> banner = [];
    for (var i = 1; i < 4; i++) {
      banner.add("assets/images/room$i.jpg");
    }
    banners.clear();
    banners.addAll(banner);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            key: scaffoldKey,
            drawer: const Drawer(child: DrawerScreen()),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child: const Icon(Icons.menu, color: Colors.grey),
                          onTap: () => scaffoldKey.currentState?.openDrawer(),
                        ),
                        const Text(
                          "Hello! \nGood morning Caretto",
                          style: kDBXLTextStyle,
                        ),
                        const CircleAvatar(
                          radius: 35.0,
                          backgroundImage: NetworkImage(
                              'https://media.istockphoto.com/photos/millennial-male-team-leader-organize-virtual-workshop-with-employees-picture-id1300972574?b=1&k=20&m=1300972574&s=170667a&w=0&h=2nBGC7tr0kWIU8zRQ3dMg-C5JLo9H2sNUuDjQ5mlYfo='),
                          backgroundColor: Colors.transparent,
                        )
                      ],
                    ),
                  ),
                  // FutureBuilder(
                  //     future: getAdddedPlaceList(),
                  //     builder: (BuildContext context, AsyncSnapshot snapshot) {
                  //       if (snapshot.connectionState == ConnectionState.done) {
                  //         // if (snapshot.hasData) {
                  //         return const
                  MainImageWidget(
                    imageHeight: deviceHeight * 0.6,
                    imageWidth: deviceWidth * 0.7,
                    mainboxHeight: deviceHeight * 0.60,
                    textcontainerWidth: deviceWidth * 0.7,
                  )
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
                  //   } else {
                  //     return const CircularProgressIndicator();
                  //   }
                  // }),
                ],
              ),
            )));
  }
}
