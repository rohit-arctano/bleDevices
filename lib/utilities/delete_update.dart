import 'package:bldevice_connection/model/fb_user.dart';
import 'package:bldevice_connection/shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Fucntionality {
  late final CollectionReference<Map<String, dynamic>> fireStoreroomInstance;
  late final CollectionReference<Map<String, dynamic>> fireStoreDeviceInstance;
  late final Stream<QuerySnapshot<Map<String, dynamic>>> firebaseIntance;
  late final DocumentReference<Map<String, dynamic>> fireStorePlaceInstance;
  late final DocumentReference<Map<String, dynamic>> fireStorePlaceEditInstance;
  FbUser? userData;

  late final DocumentSnapshot<Map<String, dynamic>> switchesData;

  late final DocumentSnapshot<Map<String, dynamic>> deviceData;
  late final DocumentSnapshot<Map<String, dynamic>> roomData;
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

  Future editThePlace(String doc, String editdoc) async {
    userData = await SavePreferences().getUserData();
    final FirebaseFirestore instance = FirebaseFirestore.instance;

    fireStorePlaceEditInstance = instance
        .collection("users")
        .doc(userData?.uid)
        .collection("places")
        .doc(editdoc);

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
        }
        deviceData = await j.reference.get();
      }
      roomData = await i.reference.get();

      //   if (r != null) {
      //     for (var roomtype in roomData){
      //       fireStorePlaceEditInstance
      //           .collection("rooms")
      //           .doc(roomtype)
      //           .set({}, SetOptions(merge: false));
      //   }
      //   // }
    }

//  for()   {fireStorePlaceEditInstance
//               .collection("rooms")
//               .doc(roomData.id)
//               .set({}, SetOptions(merge: false));}

    //   for (var roomtype in fireStoreroomInstance){
    //     fireStorePlaceEditInstance
    //         .collection("rooms")
    //         .doc(roomtype)
    //         .set({}, SetOptions(merge: false));
    // }
  }
}
