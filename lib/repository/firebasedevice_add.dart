// import 'package:cloud_firestore/cloud_firestore.dart';

// class AddCategory {
//   Future<DocumentReference<Map<String, dynamic>>> addResidence(
//       String residence) async {
//     DocumentReference<Map<String, dynamic>> deviceAdd =
//         await FirebaseFirestore.instance.collection("users").doc(fsellerUid);
//     // Calling the collection to add a new user
//     print(" the residence is $residence");

//     await deviceAdd.set({
//       'home': residence,
//     });
//     print("residence data Added");

//     return deviceAdd;
//   }
// }
