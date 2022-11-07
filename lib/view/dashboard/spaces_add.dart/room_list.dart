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
  late final Stream<QuerySnapshot<Map<String, dynamic>>> firebaseInstance;

  final TextEditingController roomType = TextEditingController();

  @override
  void dispose() {
    roomType;
    super.dispose();
  }

  FbUser? userData;
  Future getUserData() async {
    userData = await SavePreferences().getUserData();
    firebaseInstance = FirebaseFirestore.instance
        .collection("users")
        .doc(userData?.uid)
        .collection("places")
        .doc(widget.placeId)
        .collection("rooms")
        .snapshots();
    return userData;
  }

  Future entryofRoom() async {
    String roomName = roomType.text;
    print("object");
    await Firestore.addRoom(roomName);
    roomType.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: getUserData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          child:
                              const Icon(Icons.arrow_back, color: Colors.grey),
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
                        stream: firebaseInstance,
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
                    CustomTextField(
                      isObscure: false,
                      controller: roomType,
                      data: Icons.room,
                      hintText: 'Room Name',
                      suffixAdd: SizedBox(
                        child: CustomButton(
                          onTap: () {
                            entryofRoom();

                            setState(() {});
                          },
                          childWidget: const Icon(Icons.add),
                        ),
                      ),
                    ),
                  ],
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
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (context, index) {
          final id = snapshot.data!.docs[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return DeviceListData(placeId: widget.placeId, roomId: id.id);
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
          );
        });
  }
}
