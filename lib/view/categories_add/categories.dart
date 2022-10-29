import 'package:bldevice_connection/main.dart';
import 'package:bldevice_connection/model/fb_user.dart';
import 'package:bldevice_connection/repository/firebasedevice_add.dart';
import 'package:bldevice_connection/shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CreateCategories extends StatefulWidget {
  const CreateCategories({super.key});

  @override
  State<CreateCategories> createState() => _CreateCategoriesState();
}

class _CreateCategoriesState extends State<CreateCategories> {
  Future<DatabaseReference> getAdddedPlaceList() async {
    FbUser data = await SavePreferences().getUserData();
    DatabaseReference document = FirebaseDatabase.instance
        .ref("places")
        .child(data.uid)
        .child("home")
        // .child("SWITCHES")
        .ref;
    return document;
  }

  @override
  Widget build(BuildContext context) {
    // CollectionReference<Map<String, dynamic>> deviceAdd = FirebaseFirestore.instance.collection("user1");
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder(
        future: getAdddedPlaceList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // if (snapshot.connectionState == ConnectionState.done) {
          //   Map<String, dynamic> data =
          //       snapshot.data!.data() as Map<String, dynamic>;
          //   return Text("home: ${data['name']}");
          // }
          return GestureDetector(
            onTap: () async {
              String result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const FullScreenDialog(),
                    fullscreenDialog: true,
                  ));
              // AddCategory().addResidence(result);
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Add Place"),
                  Icon(
                    Icons.add,
                    size: 50,
                  )
                ],
              ),
            ),
          );
        },
      ),
    ));
  }
}
