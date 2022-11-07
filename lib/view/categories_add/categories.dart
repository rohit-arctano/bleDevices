import 'package:bldevice_connection/constant/colors_const.dart';
import 'package:bldevice_connection/constant/textstyle_constant.dart';
import 'package:bldevice_connection/model/fb_user.dart';
import 'package:bldevice_connection/shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CreateCategories extends StatefulWidget {
  CreateCategories(
      {required this.placeId, required this.onSelected, super.key});

  final VoidCallback onSelected;
  String placeId;
  @override
  State<CreateCategories> createState() => _CreateCategoriesState();
}

class _CreateCategoriesState extends State<CreateCategories> {
  String? selectedIndex;
  FbUser? userData;
  String? selectPlace;
  late final Stream<QuerySnapshot<Map<String, dynamic>>> firebaseIntance;
  Future getData() async {
    userData = await SavePreferences().getUserData();

    firebaseIntance = FirebaseFirestore.instance
        .collection("users")
        .doc(userData?.uid)
        .collection("places")
        .snapshots();
    return userData;
  }

  @override
  Widget build(BuildContext context) {
    // CollectionReference<Map<String, dynamic>> deviceAdd = FirebaseFirestore.instance.collection("user1");
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // if (snapshot.hasData) {
          return Column(
            children: [
              StreamBuilder(
                  stream: firebaseIntance,
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

                      case ConnectionState.done:
                        print(" the data is ${snapshot.data?.docs}");
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
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                    filled: false,
                                    disabledBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    prefixIcon: Icon(Icons.place),
                                    isDense: false),

                                iconEnabledColor: kGreyColor,

                                value: selectPlace,
                                hint: const Text("Select the Place"),

                                // Down Arrow Icon
                                icon: const Icon(Icons.keyboard_arrow_down),

                                // Array list of items
                                items: snapshot.data!.docs.map((items) {
                                  return DropdownMenuItem(
                                    value: items.id,
                                    child: Text(items.id),
                                  );
                                }).toList(),
                                // After selecting the desired option,it will
                                // change button value to selected value
                                onChanged: (String? newValue) async {
                                  widget.placeId = newValue!;
                                  widget.onSelected;
                                  // await SavePreferences()
                                  //     .setplace(widget.placeId);
                                  setState(() async {});
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
                    // Column(children: getExpenseItems(snapshot));
                  }),
            ],
          );
          // } else {
          //   return CircularProgressIndicator();
          // }
        },
      ),
    );
    // ));
  }
}
