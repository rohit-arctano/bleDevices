import 'package:bldevice_connection/constant/colors_const.dart';
import 'package:bldevice_connection/constant/widget.dart';
import 'package:bldevice_connection/model/fb_user.dart';
import 'package:bldevice_connection/shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PlaceSelectWidget extends StatefulWidget {
  PlaceSelectWidget(
      {required this.placeId, required this.onSelected, super.key});

  final Function() onSelected;
  String placeId;
  @override
  State<PlaceSelectWidget> createState() => _CreateCategoriesState();
}

class _CreateCategoriesState extends State<PlaceSelectWidget> {
  String? selectedIndex;
  FbUser? userData;
  String? selectPlace;
  Stream<QuerySnapshot<Map<String, dynamic>>>? firebasePlaceInstane;
  Future getData() async {
    userData = await SavePreferences().getUserData();
    print("the user data is $userData");
    firebasePlaceInstane = FirebaseFirestore.instance
        .collection("users")
        .doc(userData?.uid)
        .collection("places")
        .snapshots();
    return userData;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print("the snapshot is ${snapshot.data.toString()}");
          if (snapshot.hasData) {
            return StreamBuilder(
                stream: firebasePlaceInstane,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  // Map<String, dynamic>? data = snapshot.data?.data();
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return const Text('No data');
                    case ConnectionState.waiting:
                      return const Text('Awaiting...');
                    case ConnectionState.active:
                      return Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,

                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 5.0,
                                    spreadRadius: 0.5,
                                    offset: Offset(1.0, 1.0),
                                  ),
                                ],
                                border: Border.all(color: kGreyColor, width: 2),
                                borderRadius: BorderRadius.circular(12)),
                            // padding: EdgeInsets.only(left: 44.0),
                            // margin: EdgeInsets.only(
                            //     top: 64.0, left: 16.0, right: 16.0),
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton(
                                itemHeight: 50,
                                isExpanded: true,
                                hint: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.place),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        "Select the Place",
                                        style: kLTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                underline: DropdownButtonHideUnderline(
                                    child: Container()),
                                iconEnabledColor: kGreyColor,
                                value: selectPlace,
                                items: snapshot.data!.docs.map((items) {
                                  return DropdownMenuItem(
                                    enabled: true,
                                    value: items.id,
                                    child: Text(
                                      items.id.toUpperCase(),
                                      style: kLTextStyle,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) async {
                                  widget.placeId = newValue!;
                                  selectPlace = newValue;
                                  await getData();
                                  await SavePreferences()
                                      .setplace(widget.placeId);
                                  widget.onSelected();
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                          // Center(
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       GridView.builder(
                          //         shrinkWrap: true,
                          //         itemCount: snapshot.data!.docs.length,
                          //         itemBuilder: ((context, index) {
                          //           QueryDocumentSnapshot<Object?>
                          //               doccument =
                          //               snapshot.data!.docs[index];
                          //           return Stack(
                          //             children: [
                          //               Padding(
                          //                 padding:
                          //                     const EdgeInsets.fromLTRB(
                          //                         5, 5, 5, 5),
                          //                 child: InkWell(
                          //                   onTap: ()async {
                          //                     setState(() {
                          //                       selectedIndex =
                          //                           doccument.id;
                          //                     // await  SavePreferences().setplace(
                          //                     //       selectedIndex);
                          //                     //     Navigator.push(context,MaterialPageRoute( builder: (context) => RoomList(placeId: id.id)))
                          //                      });

                          //                   },
                          //                   child: Container(
                          //                     decoration: BoxDecoration(
                          //                       borderRadius:
                          //                           BorderRadius.circular(
                          //                               16),
                          //                       color: selectedIndex ==
                          //                               snapshot.data!
                          //                                   .docs[index].id
                          //                           ? kWhiteColor
                          //                           : kLightGreyColor,
                          //                       boxShadow: const [
                          //                         BoxShadow(
                          //                           color: kDarkGreyColor,
                          //                           offset: Offset(
                          //                             2.0,
                          //                             2.0,
                          //                           ), //Offset
                          //                           blurRadius: 10.0,
                          //                           spreadRadius: 2.0,
                          //                         ), //BoxShadow
                          //                         BoxShadow(
                          //                           color: Colors.white,
                          //                           offset:
                          //                               Offset(0.0, 0.0),
                          //                           blurRadius: 0.0,
                          //                           spreadRadius: 0.0,
                          //                         ), //BoxShadow
                          //                       ],
                          //                     ),
                          //                     child: Column(
                          //                       mainAxisAlignment:
                          //                           MainAxisAlignment
                          //                               .center,
                          //                       children: [
                          //                         const SizedBox(
                          //                           height: 15,
                          //                         ),
                          //                         Center(
                          //                           child: Text(
                          //                             snapshot.data!
                          //                                 .docs[index].id
                          //                                 .toUpperCase(),
                          //                             textAlign:
                          //                                 TextAlign.center,
                          //                             style: kBXLTextStyle,
                          //                           ),
                          //                         )
                          //                       ],
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ),

                          //               // //  snapshot.data!.docs[selectedIndex];
                          //               // const Padding(
                          //               //   padding: EdgeInsets.all(10.0),
                          //               //   child: Align(
                          //               //       alignment: Alignment.topRight,
                          //               //       child: CircleAvatar(
                          //               //         backgroundColor: kL1,
                          //               //         radius: 10,
                          //               //         child: Icon(
                          //               //           Icons.done,
                          //               //           color: kWhiteColor,
                          //               //           size: 15,
                          //               //         ),
                          //               //       )),
                          //               // )
                          //               // : Container()
                          //             ],
                          //           );
                          //         }),
                          //         gridDelegate:
                          //             const SliverGridDelegateWithFixedCrossAxisCount(
                          //           crossAxisCount: 2,
                          //           mainAxisSpacing: 20,
                          //           crossAxisSpacing: 20,
                          //           childAspectRatio: 2 / 2,
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),
                        ],
                      );
                    case ConnectionState.done:
                      return Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 20.0,
                                  spreadRadius: 0.5,
                                  offset: Offset(1.0, 1.0),
                                ),
                              ],
                            ),
                            // padding: EdgeInsets.only(left: 44.0),
                            // margin: EdgeInsets.only(
                            //     top: 64.0, left: 16.0, right: 16.0),
                            child: DropdownButton(
                              hint: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: const [
                                    Icon(Icons.place),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      "Select the Place",
                                      style: kLTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                              underline: DropdownButtonHideUnderline(
                                  child: Container()),
                              iconEnabledColor: kGreyColor,
                              value: selectPlace,
                              items: snapshot.data!.docs.map((items) {
                                return DropdownMenuItem(
                                  value: items.id,
                                  child: Text(items.id),
                                );
                              }).toList(),
                              onChanged: (String? newValue) async {
                                widget.placeId = newValue!;
                                selectPlace = newValue;
                                await SavePreferences()
                                    .setplace(widget.placeId);
                                widget.onSelected();
                                setState(() {});
                              },
                            ),
                          ),
                          // Center(
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       GridView.builder(
                          //         shrinkWrap: true,
                          //         itemCount: snapshot.data!.docs.length,
                          //         itemBuilder: ((context, index) {
                          //           QueryDocumentSnapshot<Object?>
                          //               doccument =
                          //               snapshot.data!.docs[index];
                          //           return Stack(
                          //             children: [
                          //               Padding(
                          //                 padding:
                          //                     const EdgeInsets.fromLTRB(
                          //                         5, 5, 5, 5),
                          //                 child: InkWell(
                          //                   onTap: ()async {
                          //                     setState(() {
                          //                       selectedIndex =
                          //                           doccument.id;
                          //                     // await  SavePreferences().setplace(
                          //                     //       selectedIndex);
                          //                     //     Navigator.push(context,MaterialPageRoute( builder: (context) => RoomList(placeId: id.id)))
                          //                      });

                          //                   },
                          //                   child: Container(
                          //                     decoration: BoxDecoration(
                          //                       borderRadius:
                          //                           BorderRadius.circular(
                          //                               16),
                          //                       color: selectedIndex ==
                          //                               snapshot.data!
                          //                                   .docs[index].id
                          //                           ? kWhiteColor
                          //                           : kLightGreyColor,
                          //                       boxShadow: const [
                          //                         BoxShadow(
                          //                           color: kDarkGreyColor,
                          //                           offset: Offset(
                          //                             2.0,
                          //                             2.0,
                          //                           ), //Offset
                          //                           blurRadius: 10.0,
                          //                           spreadRadius: 2.0,
                          //                         ), //BoxShadow
                          //                         BoxShadow(
                          //                           color: Colors.white,
                          //                           offset:
                          //                               Offset(0.0, 0.0),
                          //                           blurRadius: 0.0,
                          //                           spreadRadius: 0.0,
                          //                         ), //BoxShadow
                          //                       ],
                          //                     ),
                          //                     child: Column(
                          //                       mainAxisAlignment:
                          //                           MainAxisAlignment
                          //                               .center,
                          //                       children: [
                          //                         const SizedBox(
                          //                           height: 15,
                          //                         ),
                          //                         Center(
                          //                           child: Text(
                          //                             snapshot.data!
                          //                                 .docs[index].id
                          //                                 .toUpperCase(),
                          //                             textAlign:
                          //                                 TextAlign.center,
                          //                             style: kBXLTextStyle,
                          //                           ),
                          //                         )
                          //                       ],
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ),

                          //               // //  snapshot.data!.docs[selectedIndex];
                          //               // const Padding(
                          //               //   padding: EdgeInsets.all(10.0),
                          //               //   child: Align(
                          //               //       alignment: Alignment.topRight,
                          //               //       child: CircleAvatar(
                          //               //         backgroundColor: kL1,
                          //               //         radius: 10,
                          //               //         child: Icon(
                          //               //           Icons.done,
                          //               //           color: kWhiteColor,
                          //               //           size: 15,
                          //               //         ),
                          //               //       )),
                          //               // )
                          //               // : Container()
                          //             ],
                          //           );
                          //         }),
                          //         gridDelegate:
                          //             const SliverGridDelegateWithFixedCrossAxisCount(
                          //           crossAxisCount: 2,
                          //           mainAxisSpacing: 20,
                          //           crossAxisSpacing: 20,
                          //           childAspectRatio: 2 / 2,
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),
                        ],
                      );
                  }
                });
          } else {
            return const Text("No room found");
          }
        },
      ),
    );
    // ));
  }
}
