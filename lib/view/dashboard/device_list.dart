import 'package:bldevice_connection/constant/colors_const.dart';
import 'package:bldevice_connection/constant/textstyle_constant.dart';
import 'package:bldevice_connection/view/dashboard/home_switch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../model/fb_user.dart';
import '../../shared_preferences/shared_preferences.dart';

class DeviceSelect extends StatefulWidget {
  const DeviceSelect({required this.placeId, required this.roomId, super.key});

  final String placeId;
  final String roomId;
  @override
  State<DeviceSelect> createState() => _DeviceSelectState();
}

class _DeviceSelectState extends State<DeviceSelect> {
  late final Stream<QuerySnapshot<Map<String, dynamic>>> deviceList;

  FbUser? userData;
  Future getInstance() async {
    userData = await SavePreferences().getUserData();
    print(
        "the folowing data is ${userData!.uid} ${widget.placeId} ${widget.roomId}");
    deviceList = FirebaseFirestore.instance
        .collection("users")
        .doc(userData?.uid)
        .collection("places")
        .doc(widget.placeId)
        .collection("rooms")
        .doc(widget.roomId)
        .collection("devices")
        .snapshots();
    print(deviceList.first);
    return userData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              GestureDetector(
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.grey,
                  size: 30,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(
                width: 150,
              ),
              const Text(
                "Device List",
                style: kDBXLTextStyle,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          FutureBuilder(
              future: getInstance(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return StreamBuilder(
                      stream: deviceList,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return const Text('No data');
                          case ConnectionState.waiting:
                            return const Text('Awaiting...');
                          case ConnectionState.active:
                            // ignore: unnecessary_null_comparison
                            if (snapshot.data!.docs.length != null) {
                              return selectDevice(snapshot.data!.docs, context);
                            } else {
                              return const Center(
                                child: Text(
                                  "The device is not Added ",
                                  style: kLTextStyle,
                                ),
                              );
                            }
                          case ConnectionState.done:
                            return const Text("no coneection active");
                        }
                      });
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ],
      )),
    );
  }

  selectDevice(List<QueryDocumentSnapshot> docs, BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: docs.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12),
            child: Card(
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeSwitch(
                                placeId: widget.placeId,
                                roomId: widget.roomId,
                                deviceId: docs[index].id)));
                  },
                  title: Text(
                    docs[index].id.toUpperCase(),
                    style: kDBXLTextStyle,
                  ),
                  trailing: const CircleAvatar(
                    radius: 17,
                    backgroundColor: kLightGreyColor,
                    child: Icon(
                      Icons.keyboard_arrow_right,
                      color: kLightBlack,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
