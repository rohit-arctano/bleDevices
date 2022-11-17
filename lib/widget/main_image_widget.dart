import 'package:bldevice_connection/constant/widget.dart';
import 'package:bldevice_connection/view/dashboard/device_list.dart';
import 'package:bldevice_connection/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utilities/room_update_delete.dart';

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
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  border:
                                      Border.all(width: 1, color: kGreyColor)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: snp.data!.containsKey(roomList.id)
                                    ? Image.network(
                                        snp.data![roomList.id]["url"],
                                        fit: BoxFit.fill,
                                        height: widget.imageHeight,
                                        width: widget.imageWidth,
                                      )
                                    : Image.network(
                                        snp.data!["other"]["url"],
                                        fit: BoxFit.contain,
                                        height: 600,
                                        width: widget.textcontainerWidth,
                                      ),
                              ),
                            ),
                            Container(
                              height: 60,
                              decoration: BoxDecoration(
                                  color: kBlackColor.withOpacity(0.5),
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(25),
                                      bottomRight: Radius.circular(25))),
                              width: widget.textcontainerWidth!,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Column(children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          roomList.id.toUpperCase(),
                                          style: kWhiteLrgTextStyle,
                                        ),
                                      ),
                                      const Spacer(),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Container(
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
                                                String newplaceName =
                                                    await Navigator.push(
                                                        context,
                                                        PageRouteBuilder(
                                                          opaque: false,
                                                          pageBuilder: (context,
                                                                  __, _) =>
                                                              PopUpTemplate(
                                                            hintText:
                                                                "Change the place Name",
                                                          ),
                                                        ));
                                                widget.fireinstance!
                                                    .doc(newplaceName)
                                                    .set(
                                                        {},
                                                        SetOptions(
                                                            merge: false));

                                                await RoomFunctionality()
                                                    .getTheRoom(
                                                        widget.placeName,
                                                        roomList.id,
                                                        newplaceName);
                                                await RoomFunctionality()
                                                    .deleteRoom(
                                                        widget.placeName,
                                                        roomList.id);
                                                await widget.fireinstance!
                                                    .doc(roomList.id)
                                                    .delete();
                                              },
                                              icon: const Icon(
                                                Icons.edit,
                                                color: kWhiteColor,
                                              )),
                                        ),
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
                  }),
            );
          } else {
            return const Loader();
          }
        });
  }

  bool buttonSelected = false;
}
