import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/fb_user.dart';
import '../shared_preferences/shared_preferences.dart';

class Firestore {
  static Future addEntryofPlace(String places) async {
    FbUser? userData;
    userData = await SavePreferences().getUserData();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userData.uid)
        .collection("places")
        .doc(places)
        .set({}, SetOptions(merge: false));
  }

  static Future addRoom(String room) async {
    FbUser? userData;
    userData = await SavePreferences().getUserData();
    print("your room is waiting");
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userData.uid)
        .collection("places")
        .doc("restaurant")
        .collection("rooms")
        .doc(room)
        .set({}, SetOptions(merge: false));
    print("your room is iadded");
  }

  static Future addDevice(String device) async {
    FbUser? userData;
    userData = await SavePreferences().getUserData();

    print("your Device is iadded");
  }

  static Future addSwitch(String switchName, data) async {
    FbUser? userData;
    String deviceId = "6EsFwFN9SealdHqBK2ui";
    userData = await SavePreferences().getUserData();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userData.uid)
        .collection("places")
        .doc("restaurant")
        .collection("rooms")
        .doc("kitchen")
        .collection("devices")
        .doc(deviceId)
        .collection("switches")
        .doc(switchName)
        .set(data);
  }

  // updates an existing entry (missing fields won't be touched on update), document must exist
  static Future editName(CollectionReference<Map<String, dynamic>> collection,
      String documentId, Map<String, dynamic> data) async {
    await collection.doc(documentId).update(data);
  }

  // deletes the entry with the given document id
  static Future deleteEntry(String collection, String documentId) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(documentId)
        .delete();
  }
}
