import 'package:bldevice_connection/constant/textstyle_constant.dart';
import 'package:bldevice_connection/model/space_model.dart';
import 'package:flutter/material.dart';

import '../../../constant/colors_const.dart';

class Spaces extends StatefulWidget {
  const Spaces({super.key});

  @override
  State<Spaces> createState() => _SpacesState();
}

class _SpacesState extends State<Spaces> {
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
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
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
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
                    IconButton(onPressed: () {}, icon: const Icon(Icons.add))
                  ],
                ),
              ),
              // FutureBuilder(
              //     //  future: getAdddedPlaceList(),
              //     builder: (BuildContext context, AsyncSnapshot snapshot) {
              //   if (snapshot.connectionState == ConnectionState.done) {
              //     // if (snapshot.hasData) {
              //     return
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(32)),
                height: MediaQuery.of(context).size.height * 0.4,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: spaceList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 4.0, right: 4),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  spaceList[index].image,
                                  fit: BoxFit.fitHeight,
                                  height: deviceHeight * 0.35,
                                  width: deviceWidth * 0.45,
                                ),
                              ),
                              Container(
                                height: 100,
                                width: deviceWidth * 0.45,
                                color: kBlackColor.withOpacity(0.5),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Column(children: [
                                    Row(
                                      children: [
                                        Text(
                                          spaceList[index].spaceName,
                                          style: kWhiteLrgTextStyle,
                                        ),
                                        const Spacer(),
                                        Text(
                                          "0/1",
                                          style: kWhiteLrgTextStyle,
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            // color: buttonSelected
                                            //     ? kWhiteColor.withOpacity(0.5)
                                            //     : Colors.transparent,
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
                                              onPressed: () {
                                                setState(() {
                                                  // buttonSelected =
                                                  //     !buttonSelected;
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.hot_tub,
                                                // color: kWhiteColor,
                                              )),
                                        ),
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
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
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.room,
                                                // color: kWhiteColor,
                                              )),
                                        ),
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
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
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.abc,
                                                color: kWhiteColor,
                                              )),
                                        ),
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
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
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.hot_tub,
                                                color: kWhiteColor,
                                              )),
                                        ),
                                      ],
                                    )
                                  ]),
                                ),
                              )
                            ],
                          ),
                        );
                      }

                      // onPageChanged: (index) {
                      //   setState(() {
                      //     position = index;
                      //   });
                      // },
                      ),
                ),
              )
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
            ],
          ),
        ),
      ),
    );
  }
}
