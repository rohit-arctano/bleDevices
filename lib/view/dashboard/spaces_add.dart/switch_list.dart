import 'package:bldevice_connection/constant/colors_const.dart';
import 'package:bldevice_connection/constant/textstyle_constant.dart';
import 'package:bldevice_connection/model/firebase_data.dart';
import 'package:bldevice_connection/widget/loader.dart';
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
  late final CollectionReference<Map<String, dynamic>> firebaseInstance;
  late List<GetSwitch> switchData;
  final formKey = GlobalKey<FormState>();
  final TextEditingController boardNameCntrl = TextEditingController();
  final TextEditingController switchNameCntrl = TextEditingController();
  FbUser? userData;
  Future getInstance() async {
    userData = await SavePreferences().getUserData();
    firebaseInstance = FirebaseFirestore.instance
        .collection("users")
        .doc(userData?.uid)
        .collection("places")
        .doc(widget.placeId)
        .collection("rooms")
        .doc(widget.roomId)
        .collection("devices");
    deviceList = firebaseInstance.doc(widget.deviceId).collection("switches");

    return userData;
  }

  List<GetSwitch> fetchSwitch = [];
  Future entryofSwitch(String switchName) async {
    GetSwitch json = GetSwitch(
        switchName: switchNameCntrl.text,
        switchStatus: false,
        switchEnable: false);
    await deviceList.doc(switchName).set(json.toJson());
    switchNameCntrl.clear();
    boardNameCntrl.clear();
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
          child: SingleChildScrollView(
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
            FutureBuilder(
                future: getInstance(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return StreamBuilder(
                        stream: deviceList.snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> streamsnapshot) {
                          if (streamsnapshot.hasError) {
                            return Text('Error: ${streamsnapshot.error}');
                          } else if (streamsnapshot.hasData) {
                            return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: streamsnapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final DocumentSnapshot documentSnapshot =
                                      streamsnapshot.data!.docs[index];

                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      borderOnForeground: true,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
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
                                                                    pageBuilder: (context,
                                                                            __,
                                                                            _) =>
                                                                        PopUpTemplate(
                                                                      hintText:
                                                                          "Change the switch Name",
                                                                    ),
                                                                  ));

                                                          Map<String, dynamic>
                                                              data = {
                                                            "switchName": result
                                                          };
                                                          Firestore.editName(
                                                              deviceList,
                                                              documentSnapshot
                                                                  .id,
                                                              data);
                                                        },
                                                        childWidget: const Icon(
                                                          Icons.edit,
                                                        )),
                                                  ),
                                                ),
                                                const Spacer(),
                                                IconButton(
                                                    onPressed: () async {
                                                      print(
                                                          "your switch is deleting");
                                                      showAlertDialog(context,
                                                          documentSnapshot);
                                                      print(
                                                          "your switch is deleted");
                                                    },
                                                    icon: const Icon(
                                                        Icons.delete))
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Switch Name",
                                                  style: kBLTextStyle,
                                                ),
                                                const Spacer(),
                                                documentSnapshot
                                                        .data()
                                                        .toString()
                                                        .contains("switchName")
                                                    ? Text(
                                                        documentSnapshot[
                                                                "switchName"] ??
                                                            "No switch",
                                                        style: kBXLTextStyle,
                                                      )
                                                    : const Text(
                                                        "no switch Found",
                                                        style: kBXLTextStyle,
                                                      ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Availability",
                                                  style: kBLTextStyle,
                                                ),
                                                const Spacer(),
                                                const Spacer(),
                                                documentSnapshot
                                                        .data()
                                                        .toString()
                                                        .contains("enable")
                                                    ? SwitchScreen(
                                                        onTap: (bool enable) {
                                                          documentSnapshot[
                                                                  "enable"] ==
                                                              enable;
                                                          Map<String, dynamic>
                                                              data = {
                                                            "enable": enable
                                                          };
                                                          Firestore.editName(
                                                              deviceList,
                                                              documentSnapshot
                                                                  .id,
                                                              data);
                                                        },
                                                        status:
                                                            documentSnapshot[
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
                                                        .contains("status")
                                                    ? SwitchScreen(
                                                        onTap: (bool status) {
                                                          Map<String, dynamic>
                                                              data = {
                                                            "status": status
                                                          };

                                                          Firestore.editName(
                                                              deviceList,
                                                              documentSnapshot
                                                                  .id,
                                                              data);
                                                        },
                                                        status:
                                                            documentSnapshot[
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
                                });
                          } else {
                            return const Loader(
                              color: kPrimaryColor,
                              height: 40,
                              width: 40,
                            );
                          }
                        });
                  } else {
                    return const Loader(
                      color: Colors.green,
                      height: 40,
                      width: 40,
                    );
                  }
                }),
            Form(
              key: formKey,
              child: Column(
                children: [
                  CustomTextField(
                    isObscure: false,
                    controller: switchNameCntrl,
                    data: Icons.room,
                    hintText: 'Switch Name',
                    onValidation: (value) {
                      return value == null || value == ""
                          ? 'Please fill the Switch Name'
                          : null;
                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  colors: kPrimaryColor,
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      entryofSwitch(switchNameCntrl.text);
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Switch is Added')));
                    }
                  },
                  childWidget: Row(
                    children: const [
                      Text(
                        "Add Switch",
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
      )),
    );
  }

  showAlertDialog(
      BuildContext context, DocumentSnapshot<Object?> documentSnapshot) {
    // set up the buttons
    Widget cancelButton = CustomButton(
      colors: kPrimaryColor,
      childWidget: const Text("Cancel"),
      onTap: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = CustomButton(
      colors: kPrimaryColor,
      childWidget: const Text("Continue"),
      onTap: () async {
        await deviceList.doc(documentSnapshot.id).delete();
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Alert!"),
      content: const Text(
          "Would you like to Delete the switch from the list.\n It is permanently delete from our DataBase"),
      actions: [
        cancelButton,
        const Spacer(),
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  bool? switchButton;
  bool? switchEnable;

  // selectDevice(List<QueryDocumentSnapshot> docs, BuildContext context) {
  //   return
  //       // Text(docs.length.toString());

  // }
}
