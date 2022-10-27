import 'dart:io';

import 'package:bldevice_connection/constant/colors_const.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Column(children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Container(
                child: Stack(
                  children: [
                    const CircleAvatar(
                        radius: 60,
                        child: Text(
                          'No Image captured',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        )
                        // : CircleAvatar(
                        //     radius: 20,
                        //     child: Image.asset(
                        //         'android/Assests/Images/ProfileIcon.png')),
                        ),
                    Container(
                      height: MediaQuery.of(context).size.width / 2.5,
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: Stack(
                        children: [],
                      ),
                    ),
                    Positioned(
                        bottom: 5,
                        right: 5,
                        child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                // border: Border.all(color: Colors.pink),
                                color: kPrimaryColor),
                            child: Column(
                              children: [
                                Container(
                                  child: PopupMenuButton<String>(
                                    color: Colors.pink[20],
                                    onSelected: (value) {
                                      print(value);
                                    },
                                    itemBuilder: (BuildContext contesxt) {
                                      return [
                                        PopupMenuItem(
                                            child: ListTile(
                                          leading: TextButton(
                                              onPressed: () {},
                                              //  getImage,
                                              child: Text(
                                                'Camera',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              )),
                                        )),
                                        PopupMenuItem(
                                            child: ListTile(
                                          leading: TextButton(
                                              onPressed: () {},
                                              // getImageFromGallery,
                                              child: Text(
                                                'Gallery',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              )),
                                        )),
                                      ];
                                    },
                                  ),
                                )
                              ],
                            )))
                  ],
                ),
              ),
            ),
          ),

          // _usermodel == null ? Text("no data") : buildFutureBuilder(),
          // Text("Full name",
          //     textAlign: TextAlign.left,
          //     style: TextStyle(color: Colors.pink,
          //     fontSize: 18,
          //     fontWeight: FontWeight.w500)),
          const SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                  hintText: 'Nicola',
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  filled: true,
                  fillColor: Colors.white70,
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide(color: Colors.pink, width: 2),
                  ),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.grey[400],
                    size: 25,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: TextFormField(
              obscureText: true,
              validator: (value) {},
              decoration: InputDecoration(
                  hintText: 'nicola@gmail.com',
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  filled: true,
                  fillColor: Colors.white70,
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide(color: Colors.pink, width: 2),
                  ),
                  prefixIcon: Icon(
                    Icons.mail,
                    color: Colors.grey[400],
                    size: 25,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: TextFormField(
              obscureText: true,
              maxLength: 10,
              // controller: number,
              onChanged: (text) {
                // value = text;
              },
              validator: (text) {
                if (text!.isEmpty) {
                  return 'Mobile no.is required';
                }
                return null;
              },
              decoration: InputDecoration(
                  hintText: '999918***',
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  filled: true,
                  fillColor: Colors.white70,
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide(color: Colors.pink, width: 2),
                  ),
                  prefixIcon: Icon(
                    Icons.mobile_friendly_rounded,
                    color: Colors.grey[400],
                    size: 25,
                  )),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: Container(
                height: 55,
                width: 150,
                child: ElevatedButton(
                  onPressed: () async {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) {
                    //   return HomePage();
                    // }));
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(fontSize: 18),
                  ),
                  // color: kPrimaryColor,
                  // textColor: Colors.white,
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: new BorderRadius.circular(30.0),
                  // ),
                  // padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                )),
          ),

          //   RaisedButton(onPressed: (){},
          //   child:Text('Get data ')
          // ),
        ])
      ]),
    );
  }

  var image = File;
  // final picker = ImagePicker();
}
