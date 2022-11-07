import 'package:bldevice_connection/model/fb_user.dart';
import 'package:bldevice_connection/view/dashboard/spaces_add.dart/room_list.dart';
import 'package:bldevice_connection/constant/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../repository/firebasedevice_add.dart';
import '../../../shared_preferences/shared_preferences.dart';
import 'package:bldevice_connection/widget/widget.dart';

class AddDevice extends StatefulWidget {
  const AddDevice({super.key});

  @override
  State<AddDevice> createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice>
    with SingleTickerProviderStateMixin {
  final TextEditingController placeName = TextEditingController();

  final TextEditingController deviceName = TextEditingController();
  final TextEditingController switchCollectionName = TextEditingController();

  bool? value;
  ValueChanged<bool>? onChanged;
  bool isroomAdd = false;
  bool isDeviceAdd = false;
  bool isSwitch = false;
  FbUser? user;
  late final Stream<QuerySnapshot<Map<String, dynamic>>> firebaseIntance;

  @override
  void dispose() {
    deviceName;
    switchCollectionName;
    placeName;
    super.dispose();
  }

  FbUser? userData;
  Future getData() async {
    userData = await SavePreferences().getUserData();
    firebaseIntance = FirebaseFirestore.instance
        .collection("users")
        .doc(userData?.uid)
        .collection("places")
        .snapshots();
    return userData;
  }

  Future setConfi() async {
    String spacename = placeName.text;
    await Firestore.addEntryofPlace(spacename);
    placeName.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                              "Spaces",
                              style: kDBXLTextStyle,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        // isroomAdd
                        //     ?

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Place List",
                              style: kBLTextStyle,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            StreamBuilder(
                                stream: firebaseIntance,
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  // Map<String, dynamic>? data = snapshot.data?.data();
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
                                      print(
                                          " the data is ${snapshot.data?.docs}");
                                      return selectDevice(snapshot, context);
                                  }
                                  // Column(children: getExpenseItems(snapshot));
                                }),
                            CustomTextField(
                              controller: placeName,
                              data: Icons.place,
                              hintText: 'Place Name',
                              isObscure: false,
                              suffixAdd: CustomButton(
                                onTap: () {
                                  setConfi();
                                  isroomAdd = true;
                                  setState(() {});
                                },
                                childWidget: const Icon(Icons.add),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  selectDevice(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (context, index) {
          final id = snapshot.data!.docs[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Card(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RoomList(placeId: id.id)));
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
