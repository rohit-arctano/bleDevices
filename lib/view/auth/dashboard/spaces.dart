import 'package:bldevice_connection/constant/colors_const.dart';
import 'package:bldevice_connection/constant/textstyle_constant.dart';
import 'package:bldevice_connection/model/space_model.dart';
import 'package:bldevice_connection/view/auth/dashboard/spaces_add.dart/add_spaces.dart';
import 'package:bldevice_connection/widget/main_image_widget.dart';
import 'package:flutter/material.dart';

class Spaces extends StatefulWidget {
  const Spaces({super.key});

  @override
  State<Spaces> createState() => _SpacesState();
}

class _SpacesState extends State<Spaces> {
  @override
  Widget build(BuildContext ctx) {
    double deviceHeight = MediaQuery.of(ctx).size.height;
    double deviceWidth = MediaQuery.of(ctx).size.width;
    return Scaffold(
      // appBar: AppBar(
      //   actions: [IconButton(onPressed: () {}, icon: Icon(Icons.add))],
      //   title: const Text(
      //     "Spaces",
      //     textAlign: TextAlign.center,
      //   ),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: const Icon(Icons.arrow_back, color: Colors.grey),
                    // onTap: () => scaffoldKey.currentState?.openDrawer(),
                  ),
                  const Text(
                    "Spaces",
                    style: kDBXLTextStyle,
                  ),
                  IconButton(
                      onPressed: () {
                        showMenu<String>(
                          context: ctx,
                          position: const RelativeRect.fromLTRB(25.0, 25.0, 0.0,
                              0.0), //position where you want to show the menu on screen
                          items: [
                            PopupMenuItem<String>(
                              onTap: () async {
                                // print("hello how are you");
                                // await Navigator.push(ctx,
                                //     MaterialPageRoute(builder: (context) {
                                //   print("hello");
                                //   return Container(
                                //     height: 100,
                                //     width: 100,
                                //     color: kPrimaryColor,
                                //     child: const AddDevice(),
                                //   );
                                // }));
                                print("hello how are you2");
                              },
                              value: '1',
                              child: const Text('New Room'),
                            ),
                            PopupMenuItem<String>(
                                onTap: () {},
                                child: const Text('New Device'),
                                value: '2'),
                          ],
                          elevation: 8.0,
                        );

                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const AddDevice()));
                      },
                      icon: const Icon(Icons.add))
                ],
              ),

              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text.rich(
                  TextSpan(
                      text: "ROOM",
                      style: kDBXLTextStyle,
                      children: [TextSpan(text: "(4)", style: kLTextStyle)]),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              // FutureBuilder(
              //     //  future: getAdddedPlaceList(),
              //     builder: (BuildContext context, AsyncSnapshot snapshot) {
              //   if (snapshot.connectionState == ConnectionState.done) {
              //     // if (snapshot.hasData) {
              //     return
              MainImageWidget(
                imageHeight: deviceHeight * 0.45,
                imageWidth: deviceWidth * 0.5,
                mainboxHeight: deviceHeight * 0.45,
                textcontainerWidth: deviceWidth * 0.5,
              ),
              // } else {
              //   return Container(
              //     height: deviceHeight * 0.5,
              //     width: deviceWidth * 0.6,
              //     decoration: BoxDecoration(
              //         color: kLightBlue,
              //         borderRadius: BorderRadius.circular(20)),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: const [
              //         Text(
              //           "Add Device",
              //           style: kBXLTextStyle,
              //         ),
              //         Icon(
              //           Icons.add,
              //           size: 50,
              //         )
              //       ],
              //     ),
              //   );
              // }
              // } else {
              //   return const CircularProgressIndicator();
              // }
              // }
              // ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text.rich(
                  TextSpan(
                      text: "Devices",
                      style: kDBXLTextStyle,
                      children: [TextSpan(text: "(12)", style: kLTextStyle)]),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
