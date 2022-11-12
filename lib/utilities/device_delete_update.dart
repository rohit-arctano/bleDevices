import 'package:bldevice_connection/model/fb_user.dart';
import 'package:bldevice_connection/shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceFunctionality {
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
  Future deleteDevice(String placedoc, String roomdoc, String deviceDoc) async {
    userData = await SavePreferences().getUserData();
    final FirebaseFirestore instance = FirebaseFirestore.instance;

    fireStorePlaceInstance = instance
        .collection("users")
        .doc(userData?.uid)
        .collection("places")
        .doc(placedoc)
        .collection("rooms")
        .doc(roomdoc)
        .collection("devices")
        .doc(deviceDoc);

    QuerySnapshot<Map<String, dynamic>> switchList =
        await fireStorePlaceInstance.collection("switches").get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> k in switchList.docs) {
      k.reference.delete();
    }
  }

  Future getTheDevice(String placeId, String roomId, String selectedDevice,
      String addDeviceDoc) async {
    userData = await SavePreferences().getUserData();
    final devicesInstance = instance
        .collection("users")
        .doc(userData?.uid)
        .collection("places")
        .doc(placeId)
        .collection("rooms")
        .doc(roomId)
        .collection("devices")
        .doc(addDeviceDoc)
        .collection("switches");

    fireStorePlaceInstance = instance
        .collection("users")
        .doc(userData?.uid)
        .collection("places")
        .doc(placeId)
        .collection("rooms")
        .doc(roomId)
        .collection("devices")
        .doc(selectedDevice);

    fireStoreDeviceInstance = fireStorePlaceInstance.collection("switches");
    QuerySnapshot<Map<String, dynamic>> getSwitches =
        await fireStoreDeviceInstance.get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> k in getSwitches.docs) {
      switchesData = await k.reference.get();
      switchesConfig = switchesData!.data()!;
      print("the switchesConfig is$switchesConfig");
      print("switches get data is ${switchesData!.id}");
      if (switchesData != null) {
        await devicesInstance
            .doc(switchesData!.id)
            .set(switchesConfig, SetOptions(merge: false));
      }
    }
  }
}
