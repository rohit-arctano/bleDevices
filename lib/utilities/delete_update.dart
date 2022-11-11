import 'package:bldevice_connection/model/fb_user.dart';
import 'package:bldevice_connection/shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Functionality {
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

  Future getThePlace(String doc) async {
    userData = await SavePreferences().getUserData();

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
          switchesData = await k.reference.get();
          switchesConfig = switchesData!.data()!;
        }
        deviceData = await j.reference.get();
        print("device data is $deviceData");
      }
      roomData = await i.reference.get();
      roomCount = getRoom.size;
      // print("room data is $roomData");

    }
  }

  Future setTheRoom(String addDoc) async {
    final CollectionReference<Map<String, dynamic>> roomInstance = instance
        .collection("users")
        .doc(userData?.uid)
        .collection("places")
        .doc(addDoc)
        .collection("rooms");
    for (int m = 0; m < roomCount; m++) {
      await roomInstance.doc(roomData!.id).set({}, SetOptions(merge: false));
      final deviceInstance =
          roomInstance.doc(roomData!.id).collection("devices");
      print("the roomdata   is $m: ${roomData!.id}");
// print("the roomData is ${roomDa}")

      for (int n = 0; n < deviceData!.id.length; n++) {
        await deviceInstance
            .doc(deviceData!.id)
            .set({}, SetOptions(merge: false));
        final switchInstance =
            deviceInstance.doc(deviceData!.id).collection("switches");
        for (int k = 0; k < switchesData!.id.length; k++) {
          await switchInstance
              .doc(switchesData!.id)
              .set(switchesConfig, SetOptions(merge: false));
        }
      }
    }
  }
}
