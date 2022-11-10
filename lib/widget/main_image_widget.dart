import 'package:bldevice_connection/constant/widget.dart';
import 'package:bldevice_connection/view/dashboard/device_list.dart';
import 'package:bldevice_connection/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MainImageWidget extends StatefulWidget {
  CollectionReference<Map<String, dynamic>>? fireinstance;
  QuerySnapshot<Object?>? snapshotData;
  double? mainboxHeight;
  double? mainboxWidth;
  double? imageHeight;
  double? imageWidth;
  double? textcontainerWidth;
  String placeName;

  MainImageWidget(
      {required this.fireinstance,
      required this.placeName,
      required this.snapshotData,
      this.textcontainerWidth,
      this.mainboxWidth,
      this.mainboxHeight,
      this.imageHeight,
      this.imageWidth,
      super.key});

  @override
  State<MainImageWidget> createState() => _MainImageWidgetState();
}

class _MainImageWidgetState extends State<MainImageWidget> {
  String? selectPlace;
  late DocumentReference<Map<String, dynamic>> roomFirebaseInstance;
  DocumentSnapshot<Map<String, dynamic>>? firebaseIntance;

  Future<Map<String, dynamic>> getData() async {
    roomFirebaseInstance =
        FirebaseFirestore.instance.collection("roomType").doc("roomImages");
    firebaseIntance = await roomFirebaseInstance.get();
    return firebaseIntance?.data() ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: getData(),
        builder: (context, snp) {
          if (snp.hasData) {
            if (snp.data == null) {
              return const Loader();
            }
            return Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(32)),
              height: widget.mainboxHeight,
              width: widget.mainboxWidth,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.snapshotData!.docs.length,
                  itemBuilder: (context, index) {
                    final roomList = widget.snapshotData!.docs[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DeviceSelect(
                                      placeId: widget.placeName,
                                      roomId:
                                          widget.snapshotData!.docs[index].id,
                                    )));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              // ignore: unnecessary_null_comparison

                              child: Image.network(
                                snp.data!.containsKey(roomList.id)
                                    ? snp.data![roomList.id]["url"]
                                    : snp.data!["other"]["url"],
                                fit: BoxFit.fill,
                                height: widget.imageHeight,
                                width: widget.imageWidth,
                              ),
                            ),
                            Container(
                              height: 60,
                              decoration: BoxDecoration(
                                  color: kBlackColor.withOpacity(0.5),
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(32),
                                      bottomRight: Radius.circular(32))),
                              width: widget.textcontainerWidth,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Column(children: [
                                  Row(
                                    children: [
                                      Text(
                                        roomList.id,
                                        style: kWhiteLrgTextStyle,
                                      ),
                                      const Spacer(),
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: buttonSelected
                                              ? kWhiteColor.withOpacity(0.5)
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(32),
                                          border: Border.all(
                                            width: 2,
                                            color: Colors.white,
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                        child: IconButton(
                                            iconSize: 20,
                                            onPressed: () async {
                                              // String newroomName = await Navigator.push(
                                              //     context,
                                              //     PageRouteBuilder(
                                              //       opaque: false,
                                              //       pageBuilder: (context, __, _) =>
                                              //           PopUpTemplate(
                                              //         hintText: "Change the Room Name",
                                              //       ),
                                              //     ));
                                              // DocumentSnapshot<Map<String, dynamic>>
                                              //     data = await widget.fireinstance!
                                              //         .doc(roomList.id)
                                              //         .get();

                                              // await widget.fireinstance!
                                              //     .doc(newroomName)
                                              //     .set(data.data() ?? {});
                                              // await widget.fireinstance!
                                              //     .doc(roomList.id)
                                              //     .delete();

                                              // await getData();
                                              // setState(() {
                                              //   buttonSelected = !buttonSelected;
                                              // });
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              color: kWhiteColor,
                                            )),
                                      ),
                                    ],
                                  ),
                                ]),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }

                  // onPageChanged: (index) {
                  //   setState(() {
                  //     position = index;
                  //   });
                  // },
                  ),
            );
          } else {
            return const Loader();
          }
        });
  }

  bool buttonSelected = false;
}
