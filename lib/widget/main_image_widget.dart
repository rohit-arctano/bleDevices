import 'package:bldevice_connection/constant/widget.dart';
import 'package:bldevice_connection/view/dashboard/device_list.dart';
import 'package:bldevice_connection/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MainImageWidget extends StatefulWidget {
  QuerySnapshot<Object?>? snapshotData;
  double? mainboxHeight;
  double? mainboxWidth;
  double? imageHeight;
  double? imageWidth;
  double? textcontainerWidth;
  String placeName;

  MainImageWidget(
      {required this.placeName,
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
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(32)),
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
                              roomId: widget.snapshotData!.docs[index].id,
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
                        child: roomImageList != null
                            ? Image.asset(
                                roomImageList.firstWhere((element) =>
                                    element["spaceName"]
                                        .toString()
                                        .toLowerCase()
                                        .contains(roomList.id
                                            .toLowerCase()))["images"],
                                // spaceList[index].image,
                                fit: BoxFit.fitHeight,
                                height: widget.imageHeight,
                                width: widget.imageWidth,
                              )
                            : Image.asset(
                                roomImageList.firstWhere((element) =>
                                    element["spaceName"] ==
                                    roomList.id.toUpperCase())["images"],
                                // spaceList[index].image,
                                fit: BoxFit.fitHeight,
                                height: widget.imageHeight,
                                width: widget.imageWidth,
                              )),
                    Container(
                      height: 70,
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
                                style: kWtXtaTstSte,
                              ),
                              const Spacer(),
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: buttonSelected
                                      ? kWhiteColor.withOpacity(0.5)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(32),
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.white,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: IconButton(
                                    iconSize: 30,
                                    onPressed: () async {
                                      String result = await Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            opaque: false,
                                            pageBuilder: (context, __, _) =>
                                                PopUpTemplate(
                                              hintText: "Change the Room Name",
                                            ),
                                          ));

                                      setState(() {
                                        buttonSelected = !buttonSelected;
                                      });
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
  }

  List<Map<String, dynamic>> roomImageList = [
    {
      "id": "1",
      "images": "assets/images/room1.jpg",
      "spaceName": "KITCHEN",
    },
    {
      "id": "2",
      "images": "assets/images/room2.jpg",
      "spaceName": "BED ROOM",
    },
    {
      "id": "3",
      "images": "assets/images/room3.jpg",
      "spaceName": "LIVING ROOM",
    },
    {
      "id": "4",
      "images": "assets/images/room4.jpg",
      "spaceName": "BALCONY",
    },
    {
      "id": "5",
      "images": "assets/images/room5.jpg",
      "spaceName": "WASH ROOM",
    },
  ];

  bool buttonSelected = false;
}
