import 'package:bldevice_connection/constant/colors_const.dart';
import 'package:bldevice_connection/constant/textstyle_constant.dart';
import 'package:bldevice_connection/model/space_model.dart';
import 'package:flutter/material.dart';

class MainImageWidget extends StatefulWidget {
  double? mainboxHeight;
  double? mainboxWidth;
  double? imageHeight;
  double? imageWidth;
  double? textcontainerWidth;
  MainImageWidget(
      {this.textcontainerWidth,
      this.mainboxWidth,
      this.mainboxHeight,
      this.imageHeight,
      this.imageWidth,
      super.key});

  @override
  State<MainImageWidget> createState() => _MainImageWidgetState();
}

class _MainImageWidgetState extends State<MainImageWidget> {
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(32)),
      height: widget.mainboxHeight,
      width: widget.mainboxWidth,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: spaceList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      spaceList[index].image,
                      fit: BoxFit.fitHeight,
                      height: widget.imageHeight,
                      width: widget.imageWidth,
                    ),
                  ),
                  Container(
                    height: 100,
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
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
                                  iconSize: 20,
                                  onPressed: () {
                                    setState(() {
                                      buttonSelected = !buttonSelected;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.hot_tub,
                                    color: kWhiteColor,
                                  )),
                            ),
                            Container(
                              height: 40,
                              width: 40,
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
                                  iconSize: 20,
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.room,
                                    color: kWhiteColor,
                                  )),
                            ),
                            Container(
                              height: 40,
                              width: 40,
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
    );
  }

  bool buttonSelected = false;
}
