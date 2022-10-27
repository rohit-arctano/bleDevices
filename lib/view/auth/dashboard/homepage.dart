import 'package:bldevice_connection/constant/widget.dart';
import 'package:bldevice_connection/model/space_model.dart';
import 'package:bldevice_connection/view/drawer.dart';
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
    // final deviceAdd = FirebaseFirestore.instance.collection("users");
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
                  FutureBuilder(
                      future: getAdddedPlaceList(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          // if (snapshot.hasData) {
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32)),
                            height: MediaQuery.of(context).size.height * 0.55,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: spaceList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Image.asset(
                                              spaceList[index].image,
                                              fit: BoxFit.fitHeight,
                                              height: deviceHeight * 0.5,
                                              width: deviceWidth * 0.6,
                                            ),
                                          ),
                                          Container(
                                            height: 100,
                                            width: deviceWidth * 0.6,
                                            color: kBlackColor.withOpacity(0.5),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Column(children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      spaceList[index]
                                                          .spaceName,
                                                      style: kWhiteLrgTextStyle,
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      "0/1",
                                                      style: kWhiteLrgTextStyle,
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                        color: buttonSelected
                                                            ? kWhiteColor
                                                                .withOpacity(
                                                                    0.5)
                                                            : Colors
                                                                .transparent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(32),
                                                        border: Border.all(
                                                          width: 2,
                                                          color: Colors.white,
                                                          style:
                                                              BorderStyle.solid,
                                                        ),
                                                      ),
                                                      child: IconButton(
                                                          iconSize: 20,
                                                          onPressed: () {
                                                            setState(() {
                                                              buttonSelected =
                                                                  !buttonSelected;
                                                            });
                                                          },
                                                          icon: const Icon(
                                                            Icons.hot_tub,
                                                            color: kWhiteColor,
                                                          )),
                                                    ),
                                                    Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(32),
                                                        border: Border.all(
                                                          width: 2,
                                                          color: Colors.white,
                                                          style:
                                                              BorderStyle.solid,
                                                        ),
                                                      ),
                                                      child: IconButton(
                                                          iconSize: 20,
                                                          onPressed: () {},
                                                          icon: const Icon(
                                                            Icons.room,
                                                            color: kWhiteColor,
                                                          )),
                                                    ),
                                                    Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(32),
                                                        border: Border.all(
                                                          width: 2,
                                                          color: Colors.white,
                                                          style:
                                                              BorderStyle.solid,
                                                        ),
                                                      ),
                                                      child: IconButton(
                                                          iconSize: 20,
                                                          onPressed: () {},
                                                          icon: const Icon(
                                                            Icons.abc,
                                                            color: kWhiteColor,
                                                          )),
                                                    ),
                                                    Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(32),
                                                        border: Border.all(
                                                          width: 2,
                                                          color: Colors.white,
                                                          style:
                                                              BorderStyle.solid,
                                                        ),
                                                      ),
                                                      child: IconButton(
                                                          iconSize: 20,
                                                          onPressed: () {},
                                                          icon: const Icon(
                                                            Icons.hot_tub,
                                                            color: kWhiteColor,
                                                          )),
                                                    ),
                                                  ],
                                                )
                                              ]),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }

                                  // onPageChanged: (index) {
                                  //   setState(() {
                                  //     position = index;
                                  //   });
                                  // },
                                  ),
                            ),
                          );
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
                        } else {
                          return const CircularProgressIndicator();
                        }
                      }),
                ],
              ),
            )));
  }
}
