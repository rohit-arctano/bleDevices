import 'package:bldevice_connection/view/drawer.dart';
import 'package:bldevice_connection/widget/main_image_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import '../../model/fb_user.dart';
import '../../shared_preferences/shared_preferences.dart';
import '../categories_add/categories.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool buttonSelected = false;
  Size? screenSize;
  var position = 0;
  double xOffset = 0;
  double yOffset = 0;

  bool isDrawerOpen = false;
  Stream<QuerySnapshot<Map<String, dynamic>>>? firebaseIntance;
  CollectionReference<Map<String, dynamic>>? roomFirebaseInstance;
  String? placeName;
  FbUser? userData;
  Future getData() async {
    userData = await SavePreferences().getUserData();
    placeName = await SavePreferences().getplace();
    print("the place name is $placeName");
    if (placeName != null) {
      roomFirebaseInstance = FirebaseFirestore.instance
          .collection("users")
          .doc(userData?.uid)
          .collection("places")
          .doc(placeName)
          .collection("rooms");
      firebaseIntance = roomFirebaseInstance?.snapshots();
    }
    return userData;
  }

  @override
  void initState() {
    super.initState();
  }

  List<String> banners = [];
  var scaffoldKey = GlobalKey<ScaffoldState>();

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [],
                  ),
                  PlaceSelectWidget(
                    placeId: placeName ?? "",
                    onSelected: () async {
                      await getData();
                      setState(() {});
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  FutureBuilder(
                      future: getData(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        // if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          return Column(
                            children: [
                              StreamBuilder(
                                  stream: firebaseIntance,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    // Map<String, dynamic>? data = snapshot.data?.data();
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    }

                                    if (snapshot.connectionState ==
                                            ConnectionState.done ||
                                        snapshot.connectionState ==
                                            ConnectionState.active) {
                                      print(
                                          " the data is ${snapshot.data!.docs}");
                                      return MainImageWidget(
                                        fireinstance: roomFirebaseInstance,
                                        placeName: placeName ?? "",
                                        snapshotData: snapshot.data,
                                        imageHeight: deviceHeight * 0.6,
                                        imageWidth: deviceWidth * 0.7,
                                        mainboxHeight: deviceHeight * 0.60,
                                        textcontainerWidth: deviceWidth * 0.7,
                                      );
                                    } else {
                                      return Text(
                                          'Connection status : ${snapshot.connectionState.name}');
                                    }

                                    // Column(children: getExpenseItems(snapshot));
                                  }),
                            ],
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
