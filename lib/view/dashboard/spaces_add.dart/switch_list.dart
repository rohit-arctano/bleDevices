import 'dart:ffi';

import 'package:bldevice_connection/constant/colors_const.dart';
import 'package:bldevice_connection/constant/textstyle_constant.dart';
import 'package:bldevice_connection/main.dart';
import 'package:bldevice_connection/model/firebase_data.dart';
import 'package:bldevice_connection/widget/switch_buttton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../model/fb_user.dart';
import '../../../repository/firebasedevice_add.dart';
import '../../../shared_preferences/shared_preferences.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/customtextField.dart';
import '../../../widget/dialogbox.dart';

// ignore: must_be_immutable
class SwitchesList extends StatefulWidget {
  SwitchesList(
      {required this.placeId,
      required this.roomId,
      required this.deviceId,
      super.key});

  String placeId;
  String roomId;
  String deviceId;

  @override
  State<SwitchesList> createState() => _SwitchesListState();
}

class _SwitchesListState extends State<SwitchesList> {
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

  @override
  void dispose() {
    switchNameCntrl;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
          Expanded(
            child: FutureBuilder(
                future: getInstance(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextField(
                          isObscure: false,
                          controller: switchNameCntrl,
                          data: Icons.room,
                          suffixAdd: CustomButton(
                            onTap: () async {
                              await entryofSwitch();
                            },
                            childWidget: const Icon(Icons.add),
                          ),
                          hintText: 'switch Name',
                        ),
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
                                          child: Card(
                                            borderOnForeground: true,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        "Change Switch Name ",
                                                        style: kLCAtStyle,
                                                      ),
                                                      SizedBox(
                                                        height: 50,
                                                        width: 50,
                                                        child: FittedBox(
                                                          child: CustomButton(
                                                              onTap: () async {
                                                                var result =
                                                                    await Navigator.push(
                                                                        context,
                                                                        PageRouteBuilder(
                                                                          opaque:
                                                                              false,
                                                                          pageBuilder: (context, __, _) =>
                                                                              PopUpTemplate(),
                                                                        ));

                                                                Map<String,
                                                                        dynamic>
                                                                    data = {
                                                                  "switchName":
                                                                      result
                                                                };
                                                                Firestore.switchUpdat(
                                                                    deviceList,
                                                                    documentSnapshot
                                                                        .id,
                                                                    data);
                                                              },
                                                              childWidget:
                                                                  const Icon(
                                                                Icons.edit,
                                                              )),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        const Text(
                                                          "Switch Name",
                                                          style: kBLTextStyle,
                                                        ),
                                                        const Spacer(),
                                                        documentSnapshot
                                                                .data()
                                                                .toString()
                                                                .contains(
                                                                    "switchName")
                                                            ? Text(
                                                                documentSnapshot[
                                                                        "switchName"] ??
                                                                    "No switch",
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
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Enable/Disable",
                                                        style: kBLTextStyle,
                                                      ),
                                                      const Spacer(),
                                                      const Spacer(),
                                                      documentSnapshot
                                                              .data()
                                                              .toString()
                                                              .contains(
                                                                  "enable")
                                                          ? SwitchScreen(
                                                              onTap: (bool
                                                                  enable) {
                                                                documentSnapshot[
                                                                        "enable"] ==
                                                                    enable;
                                                                Map<String,
                                                                        dynamic>
                                                                    data = {
                                                                  "enable":
                                                                      enable
                                                                };
                                                                Firestore.switchUpdat(
                                                                    deviceList,
                                                                    documentSnapshot
                                                                        .id,
                                                                    data);
                                                              },
                                                              status: documentSnapshot[
                                                                      "enable"]
                                                                  .toString())
                                                          : SwitchScreen(
                                                              onTap: (po) {},
                                                              status: "false")
                                                      //  SwitchScreen(
                                                      //     // status:switchDetailData.get("enable")
                                                      //     )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Switch Status",
                                                        style: kBLTextStyle,
                                                      ),
                                                      const Spacer(),
                                                      documentSnapshot
                                                              .data()
                                                              .toString()
                                                              .contains(
                                                                  "status")
                                                          ? SwitchScreen(
                                                              onTap: (bool
                                                                  status) {
                                                                Map<String,
                                                                        dynamic>
                                                                    data = {
                                                                  "status":
                                                                      status
                                                                };

                                                                Firestore.switchUpdat(
                                                                    deviceList,
                                                                    documentSnapshot
                                                                        .id,
                                                                    data);
                                                              },
                                                              status: documentSnapshot[
                                                                      "status"]
                                                                  .toString())
                                                          : SwitchScreen(
                                                              onTap: (p0) {},
                                                              status: "false")
                                                    ],
                                                  ),
                                                ],
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
