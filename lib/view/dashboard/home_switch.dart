import 'package:bldevice_connection/constant/widget.dart';
import 'package:bldevice_connection/repository/firebasedevice_add.dart';
import 'package:bldevice_connection/widget/mainSwitch.dart';
import 'package:bldevice_connection/widget/switch_buttton.dart';
import 'package:bldevice_connection/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constant/container_design.dart';
import '../../model/fb_user.dart';
import '../../model/firebase_data.dart';
import '../../shared_preferences/shared_preferences.dart';

class HomeSwitch extends StatefulWidget {
  HomeSwitch(
      {required this.placeId,
      required this.roomId,
      required this.deviceId,
      super.key});

  String placeId;
  String roomId;
  String deviceId;

  @override
  State<HomeSwitch> createState() => _HomeSwitchState();
}

class _HomeSwitchState extends State<HomeSwitch> {
  late CollectionReference<Map<String, dynamic>> deviceList;
  late List<GetSwitch> switchData;

  final TextEditingController switchNameCntrl = TextEditingController();
  FbUser? userData;
  Future getInstance() async {
    userData = await SavePreferences().getUserData();
    deviceList = FirebaseFirestore.instance
        .collection("users")
        .doc(userData?.uid)
        .collection("places")
        .doc(widget.placeId)
        .collection("rooms")
        .doc(widget.roomId)
        .collection("devices")
        .doc(widget.deviceId)
        .collection("switches");

    return userData;
  }

  List<GetSwitch> fetchSwitch = [];
  Future entryofSwitch() async {
    GetSwitch json = GetSwitch(
        switchName: switchNameCntrl.text,
        switchStatus: false,
        switchEnable: false);

    print("the json data is $json");
    await Firestore.addSwitch(switchNameCntrl.text, json.toJson());
    switchNameCntrl.clear();
  }

  bool _active = false;
  List switchstatus = [];

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                GestureDetector(
                  child: const Icon(Icons.arrow_back, color: Colors.grey),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(
                  width: 120,
                ),
                const Text(
                  "swtich List",
                  style: kDBXLTextStyle,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder(
                  future: getInstance(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          StreamBuilder(
                              stream: deviceList.snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> streamsnapshot) {
                                if (streamsnapshot.hasError) {
                                  return Text('Error: ${streamsnapshot.error}');
                                } else if (streamsnapshot.hasData) {
                                  return Expanded(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            streamsnapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          final DocumentSnapshot
                                              documentSnapshot =
                                              streamsnapshot.data!.docs[index];

                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: deviceHeight * 0.20,
                                              width: deviceWidth * 0.85,
                                              decoration: productCon,
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    // mainAxisSize:
                                                    //     MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Text(
                                                            "Switch Name",
                                                            style: kLTextStyle,
                                                          ),
                                                          const Spacer(),
                                                          documentSnapshot
                                                                  .data()
                                                                  .toString()
                                                                  .contains(
                                                                      "switchName")
                                                              ? Text(
                                                                  documentSnapshot[
                                                                          "switchName"]
                                                                      .toString()
                                                                      .toUpperCase(),
                                                                  style:
                                                                      kBXLTextStyle,
                                                                )
                                                              : const Text(
                                                                  "no switch Found",
                                                                  style:
                                                                      kBXLTextStyle,
                                                                ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Text(
                                                            "status",
                                                            style: kLTextStyle,
                                                          ),
                                                          const Spacer(),
                                                          documentSnapshot
                                                                  .data()
                                                                  .toString()
                                                                  .contains(
                                                                      "status")
                                                              ? CustomSwitch(
                                                                  onChanged: (bool?
                                                                      status) {
                                                                    print(
                                                                        "the switch $_active");
                                                                    setState(
                                                                        () {
                                                                      _active =
                                                                          !_active;
                                                                    });
                                                                    Map<String,
                                                                            dynamic>
                                                                        data = {
                                                                      "status":
                                                                          status
                                                                    };

                                                                    Firestore.editName(
                                                                        deviceList,
                                                                        documentSnapshot
                                                                            .id,
                                                                        data);
                                                                  },
                                                                  value: documentSnapshot[
                                                                      "status"])
                                                              : CustomSwitch(
                                                                  value: false,
                                                                  onChanged:
                                                                      (bool?
                                                                          s) {})
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  );
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              }),
                        ],
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            ),
          ],
        ),
      )),
    );
  }

  bool? switchButton;
  bool? switchEnable;

  // selectDevice(List<QueryDocumentSnapshot> docs, BuildContext context) {
  //   return
  //       // Text(docs.length.toString());

  // }
}
