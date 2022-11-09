import 'package:bldevice_connection/model/fb_user.dart';
import 'package:bldevice_connection/view/dashboard/spaces_add.dart/room_list.dart';
import 'package:bldevice_connection/constant/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../repository/firebasedevice_add.dart';
import '../../../shared_preferences/shared_preferences.dart';
import 'package:bldevice_connection/widget/widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AddDevice extends StatefulWidget {
  const AddDevice({super.key});

  @override
  State<AddDevice> createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice>
    with SingleTickerProviderStateMixin {
  final TextEditingController placeNameCntrl = TextEditingController();
  final TextEditingController switchCollectionName = TextEditingController();

  bool? value;
  ValueChanged<bool>? onChanged;
  bool isroomAdd = false;
  bool isDeviceAdd = false;
  bool isSwitch = false;
  FbUser? user;
  final formKey = GlobalKey<FormState>();
  late final CollectionReference<Map<String, dynamic>> fireStorePlaceInstance;
  late final Stream<QuerySnapshot<Map<String, dynamic>>> firebaseIntance;

  @override
  void dispose() {
    placeNameCntrl;
    super.dispose();
  }

  FbUser? userData;
  Future getData() async {
    userData = await SavePreferences().getUserData();
    fireStorePlaceInstance = FirebaseFirestore.instance
        .collection("users")
        .doc(userData?.uid)
        .collection("places");
    firebaseIntance = fireStorePlaceInstance.snapshots();

    return userData;
  }

  Future setConfi(String place) async {
    await Firestore.addEntryofPlace(place);
    placeNameCntrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                  print(" the data is ${snapshot.data?.docs}");
                                  return selectDevice(snapshot, context);
                              }
                              // Column(children: getExpenseItems(snapshot));
                            }),
                        Form(
                          key: formKey,
                          child: CustomTextField(
                            onValidation: (value) {
                              return value == null || value == ""
                                  ? 'Please fill the Place Name'
                                  : null;
                            },
                            controller: placeNameCntrl,
                            data: Icons.place,
                            hintText: 'Place Name',
                            isObscure: false,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButton(
                              colors: kPrimaryColor,
                              onTap: () {
                                print(
                                    'formkey status: ${formKey.currentState == null}');
                                if (formKey.currentState!.validate()) {
                                  setConfi(placeNameCntrl.text.toLowerCase());
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Place is Added')));
                                }
                              },
                              childWidget: Row(
                                children: const [
                                  Text(
                                    "Add Place",
                                    style: kWLTextStyle,
                                  ),
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
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  selectDevice(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (context, index) {
          final id = snapshot.data!.docs[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Slidable(
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (BuildContext ctx) async {
                      await fireStorePlaceInstance.doc(id.id).delete();
                      // Navigator.pop(context);
                    },
                    backgroundColor: kl2,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              startActionPane: ActionPane(
                // A motion is a widget used to control how the pane animates.
                motion: const ScrollMotion(),

                // A pane can dismiss the Slidable.
                dismissible: DismissiblePane(onDismissed: () {}),

                // All actions are defined in the children parameter.
                children: [
                  // A SlidableAction can have an icon and/or a label.
                  SlidableAction(
                    onPressed: (BuildContext ctx) async {
                      var result = await Navigator.push(
                          context,
                          PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (context, __, _) => PopUpTemplate(
                              hintText: "Change the place Name",
                            ),
                          ));
                      fireStorePlaceInstance.doc(id.id).update(result);

                      // await fireStorePlaceInstance.doc(id.id).delete();
                      // Navigator.pop(context);
                    },
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Edit',
                  ),
                ],
              ),
              enabled: true,
              direction: Axis.horizontal,
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
            ),
          );
        });
  }

  Future<void> deletePlaces(
      QueryDocumentSnapshot<Object?> documentSnapshot) async {}

  editplaceName() {}
}
