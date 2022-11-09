import 'dart:async';
import 'package:bldevice_connection/constant/colors_const.dart';
import 'package:bldevice_connection/constant/textstyle_constant.dart';
import 'package:bldevice_connection/model/fb_user.dart';
import 'package:bldevice_connection/shared_preferences/shared_preferences.dart';
import 'package:bldevice_connection/view/dashboard/spaces_add.dart/switch_list.dart';
import 'package:bldevice_connection/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../repository/firebasedevice_add.dart';

class DeviceListData extends StatefulWidget {
  const DeviceListData(
      {required this.placeId, required this.roomId, super.key});

  final String placeId;
  final String roomId;
  @override
  State<DeviceListData> createState() => _DeviceListDataState();
}

class _DeviceListDataState extends State<DeviceListData> {
  late final Stream<QuerySnapshot<Map<String, dynamic>>> deviceList;
  late final CollectionReference<Map<String, dynamic>> fireBaseInstance;
  final formKey = GlobalKey<FormState>();
  TextEditingController deviceNameCntrl = TextEditingController();
  FbUser? userData;

  Future getInstance() async {
    userData = await SavePreferences().getUserData();
    fireBaseInstance = FirebaseFirestore.instance
        .collection("users")
        .doc(userData?.uid)
        .collection("places")
        .doc(widget.placeId)
        .collection("rooms")
        .doc(widget.roomId)
        .collection("devices");
    deviceList = fireBaseInstance.snapshots();
    return userData;
  }

  Future entryofDevice(String deviceName) async {
    await fireBaseInstance.doc(deviceName).set({}, SetOptions(merge: false));
    deviceNameCntrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                              return selectDevice(snapshot.data!.docs, context);
                            case ConnectionState.done:
                              return const Text("no coneection active");
                          }
                        });
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
            Form(
              key: formKey,
              child: CustomTextField(
                isObscure: false,
                controller: deviceNameCntrl,
                data: Icons.device_hub,
                hintText: 'Device Name',
                onValidation: (value) {
                  return value == null || value == ""
                      ? 'Please fill the Device Name'
                      : null;
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  colors: kPrimaryColor,
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      entryofDevice(deviceNameCntrl.text);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Device is Added')));
                    }
                  },
                  childWidget: Row(
                    children: const [
                      Text("Add Device", style: kWLTextStyle),
                      Icon(
                        Icons.add,
                        color: kWhiteColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }

  selectDevice(List<QueryDocumentSnapshot> docs, BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: docs.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Card(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SwitchesList(
                              placeId: widget.placeId,
                              roomId: widget.roomId,
                              deviceId: docs[index].id)));
                },
                title: Text(
                  docs[index].id.toUpperCase(),
                  style: kBXLTextStyle,
                ),
                trailing: const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ),
          );
        });
  }
}
