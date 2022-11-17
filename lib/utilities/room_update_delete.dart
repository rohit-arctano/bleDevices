import 'package:bldevice_connection/model/fb_user.dart';
import 'package:bldevice_connection/shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomFunctionality {
  late final CollectionReference<Map<String, dynamic>> fireStoreDeviceInstance;
  late final Stream<QuerySnapshot<Map<String, dynamic>>> firebaseIntance;
  late final DocumentReference<Map<String, dynamic>> fireStorePlaceInstance;
  late final DocumentReference<Map<String, dynamic>> fireStorePlaceEditInstance;
  FbUser? userData;
  Map<String, dynamic> switchesConfig = {};
  FirebaseFirestore instance = FirebaseFirestore.instance;

  DocumentSnapshot<Map<String, dynamic>>? switchesData;

  DocumentSnapshot<Map<String, dynamic>>? deviceData;
  num roomCount = 0;

// delete the place from our firebasefirestore
  Future deleteRoom(String placedoc, String roomdoc) async {
    userData = await SavePreferences().getUserData();
    final FirebaseFirestore instance = FirebaseFirestore.instance;

    fireStorePlaceInstance = instance
        .collection("users")
        .doc(userData?.uid)
        .collection("places")
        .doc(placedoc)
        .collection("rooms")
        .doc(roomdoc);

    QuerySnapshot<Map<String, dynamic>> deviceList =
        await fireStorePlaceInstance.collection("devices").get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> j in deviceList.docs) {
      QuerySnapshot<Map<String, dynamic>> switchList =
          await j.reference.collection("switches").get();
      for (QueryDocumentSnapshot<Map<String, dynamic>> k in switchList.docs) {
        k.reference.delete();
      }
      j.reference.delete();
    }
  }

  Future getTheRoom(
      String placeId, String selectedRoom, String addRoomDoc) async {
    userData = await SavePreferences().getUserData();
    final devicesInstance = instance
        .collection("users")
        .doc(userData?.uid)
        .collection("places")
        .doc(placeId)
        .collection("rooms")
        .doc(addRoomDoc)
        .collection("devices");

    fireStorePlaceInstance = instance
        .collection("users")
        .doc(userData?.uid)
        .collection("places")
        .doc(placeId)
        .collection("rooms")
        .doc(selectedRoom);

    fireStoreDeviceInstance = fireStorePlaceInstance.collection("devices");
    QuerySnapshot<Map<String, dynamic>> getRoom =
        await fireStoreDeviceInstance.get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> j in getRoom.docs) {
      QuerySnapshot<Map<String, dynamic>> switchList =
          await j.reference.collection("switches").get();
      deviceData = await j.reference.get();
      final switchInstance =
          devicesInstance.doc(deviceData!.id).collection("switches");
      print("device get data is ${deviceData!.id}");
      if (deviceData != null) {
        await devicesInstance
            .doc(deviceData!.id)
            .set({}, SetOptions(merge: false));
      }
      for (QueryDocumentSnapshot<Map<String, dynamic>> k in switchList.docs) {
        switchesData = await k.reference.get();
        switchesConfig = switchesData!.data()!;
        print("the switchesConfig is$switchesConfig");
        print("switches get data is ${switchesData!.id}");
        if (switchesData != null) {
          await switchInstance
              .doc(switchesData!.id)
              .set(switchesConfig, SetOptions(merge: false));
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
