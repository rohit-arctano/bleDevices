import 'package:bldevice_connection/constant/colors_const.dart';
import 'package:bldevice_connection/constant/textstyle_constant.dart';
import 'package:bldevice_connection/repository/firebasedevice_add.dart';
import 'package:bldevice_connection/shared_preferences/shared_preferences.dart';
import 'package:bldevice_connection/view/dashboard/spaces_add.dart/device_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../model/fb_user.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/customtextField.dart';

// ignore: must_be_immutable
class RoomList extends StatefulWidget {
  RoomList({required this.placeId, super.key});
  String placeId;
  @override
  State<RoomList> createState() => _RoomListState();
}

class _RoomListState extends State<RoomList> {
  late final Stream<QuerySnapshot<Map<String, dynamic>>> roomInstance;
  late final CollectionReference<Map<String, dynamic>> fireBaseInstance;
  final TextEditingController roomNameCntrl = TextEditingController();

  @override
  void dispose() {
    roomNameCntrl;
    super.dispose();
  }

  FbUser? userData;
  Future getUserData() async {
    userData = await SavePreferences().getUserData();
    fireBaseInstance = FirebaseFirestore.instance
        .collection("users")
        .doc(userData?.uid)
        .collection("places")
        .doc(widget.placeId)
        .collection("rooms");
    roomInstance = fireBaseInstance.snapshots();
    return userData;
  }

  Future entryofRoom(String roomName) async {
    await fireBaseInstance.doc(roomName).set({}, SetOptions(merge: false));
    roomNameCntrl.clear();
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: getUserData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            child: const Icon(Icons.arrow_back,
                                color: Colors.grey),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(
                            width: 150,
                          ),
                          const Text(
                            "Room List",
                            style: kDBXLTextStyle,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      StreamBuilder(
                          stream: roomInstance,
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

                              case ConnectionState.done:
                                return selectRoom(snapshot, context);
                            }
                          }),
                      Form(
                        key: formKey,
                        child: CustomTextField(
                          isObscure: false,
                          controller: roomNameCntrl,
                          data: Icons.house,
                          hintText: 'Room Name',
                          onValidation: (value) {
                            return value == null || value == ""
                                ? 'Please fill the Room Name'
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
                                entryofRoom(roomNameCntrl.text);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Room is Added')));
                              }
                            },
                            childWidget: Row(
                              children: const [
                                Text("Add Room", style: kWLTextStyle),
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
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  selectRoom(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (context, index) {
          final id = snapshot.data!.docs[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Card(
              child: ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return DeviceListData(
                        placeId: widget.placeId, roomId: id.id);
                  }));
                },
                title: Text(
                  snapshot.data!.docs[index].id.toUpperCase(),
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
