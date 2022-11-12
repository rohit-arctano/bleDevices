import 'package:bldevice_connection/model/fb_user.dart';
import 'package:bldevice_connection/shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceFunctionality {
  late final CollectionReference<Map<String, dynamic>> fireStoreroomInstance;
  late final CollectionReference<Map<String, dynamic>> fireStoreDeviceInstance;
  late final Stream<QuerySnapshot<Map<String, dynamic>>> firebaseIntance;
  late final DocumentReference<Map<String, dynamic>> fireStorePlaceInstance;
  late final DocumentReference<Map<String, dynamic>> fireStorePlaceEditInstance;
  FbUser? userData;
  Map<String, dynamic> switchesConfig = {};
  FirebaseFirestore instance = FirebaseFirestore.instance;

  DocumentSnapshot<Map<String, dynamic>>? switchesData;

  DocumentSnapshot<Map<String, dynamic>>? deviceData;
  DocumentSnapshot<Map<String, dynamic>>? roomData;
  num roomCount = 0;

// delete the place from our firebasefirestore
  Future deletePlace(String doc) async {
    userData = await SavePreferences().getUserData();
    final FirebaseFirestore instance = FirebaseFirestore.instance;

    fireStorePlaceInstance = instance
        .collection("users")
        .doc(userData?.uid)
        .collection("places")
        .doc(doc);

    fireStoreroomInstance = fireStorePlaceInstance.collection("rooms");

    QuerySnapshot<Map<String, dynamic>> getRoom =
        await fireStoreroomInstance.get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> i in getRoom.docs) {
      QuerySnapshot<Map<String, dynamic>> deviceList =
          await i.reference.collection("devices").get();
      for (QueryDocumentSnapshot<Map<String, dynamic>> j in deviceList.docs) {
        QuerySnapshot<Map<String, dynamic>> switchList =
            await j.reference.collection("switches").get();
        for (QueryDocumentSnapshot<Map<String, dynamic>> k in switchList.docs) {
          k.reference.delete();
        }
        j.reference.delete();
      }
      i.reference.delete();
    }
  }

  Future getThePlace(String doc, String addDoc) async {
    userData = await SavePreferences().getUserData();

    final roomInstance = instance
        .collection("users")
        .doc(userData?.uid)
        .collection("places")
        .doc(addDoc)
        .collection("rooms");
    fireStorePlaceInstance = instance
        .collection("users")
        .doc(userData?.uid)
        .collection("places")
        .doc(doc);
    fireStoreroomInstance = fireStorePlaceInstance.collection("rooms");
    QuerySnapshot<Map<String, dynamic>> getRoom =
        await fireStoreroomInstance.get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> i in getRoom.docs) {
      QuerySnapshot<Map<String, dynamic>> deviceList =
          await i.reference.collection("devices").get();
      roomData = await i.reference.get();
      await roomInstance.doc(roomData!.id).set({}, SetOptions(merge: false));

      final deviceInstance =
          roomInstance.doc(roomData!.id).collection("devices");

      for (QueryDocumentSnapshot<Map<String, dynamic>> j in deviceList.docs) {
        QuerySnapshot<Map<String, dynamic>> switchList =
            await j.reference.collection("switches").get();
        deviceData = await j.reference.get();
        final switchInstance =
            deviceInstance.doc(deviceData!.id).collection("switches");

        print("device get data is ${deviceData!.id}");
        if (deviceData != null) {
          await deviceInstance
              .doc(deviceData!.id)
              .set({}, SetOptions(merge: false));
        }
        for (QueryDocumentSnapshot<Map<String, dynamic>> k in switchList.docs) {
          switchesData = await k.reference.get();
          switchesConfig = switchesData!.data()!;
          if (switchesData != null) {
            await switchInstance
                .doc(switchesData!.id)
                .set(switchesConfig, SetOptions(merge: false));
          }
          print("switch get data is ${switchesData!.id}");
        }
      }
    }
  }
}







  // Future setTheRoom(String addDoc) async {
  //   final roomInstance = instance
  //       .collection("users")
  //       .doc(userData?.uid)
  //       .collection("places")
  //       .doc(addDoc)
  //       .collection("rooms");

  //   await roomInstance.doc(roomData!.id).set({}, SetOptions(merge: false));

  //   final deviceInstance = roomInstance.doc(roomData!.id).collection("devices");
  //   print("the deviceData is ${deviceData!.id}");
  //   if (deviceData != null) {
  //     await deviceInstance
  //         .doc(deviceData!.id)
  //         .set({}, SetOptions(merge: false));
  //     final switchInstance =
  //         deviceInstance.doc(deviceData!.id).collection("switches");
  //     if (switchesData != null) {
  //       await switchInstance
  //           .doc(switchesData!.id)
  //           .set(switchesConfig, SetOptions(merge: false));
  //     }
  //   }
  // }
  // }}
