import 'package:bldevice_connection/constant/colors_const.dart';
import 'package:bldevice_connection/constant/textstyle_constant.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          elevation: 0,
          backgroundColor: kWhiteColor,
          title: const Text(
            'About Us',
            style: kDBXLTextStyle,
          ),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("android/assests/images/bckg.jpg"),
              )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                    child: Text(
                      '"Whatever You Will Ask - We Will Deliver To You."',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          letterSpacing: 4,
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'SourceSerifPro',
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                    child: Text(
                        'Arctano helps enterprises build great solutions around web, mobile and desktop Application. We intend to create tangible value for our customers by not only developing bespoke applications but also consulting them by understanding their business objectives. We take pride in working with a diverse and extraordinary set of customers handling challenging assignments. We are the architects of several large websites and portals receiving millions of visitors per month. Many mobile apps created by us are popular on iOS and Android marketplaces. With a highly experienced management team and board of directors, Arctano is a global company with offices in India and a satisfied customer base in over countries.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'SourceSerifPro',
                            fontStyle: FontStyle.italic)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 0, 20),
                    child: SizedBox(
                      height: 50,
                      width: 110,
                      child: InkWell(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => ContactUs()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            gradient: const LinearGradient(
                              colors: <Color>[
                                Color(0xFF0D47A1),
                                Color(0xFF1976D2),
                                Color(0xFF42A5F5),
                              ],
                            ),
                          ),
                          child: Container(
                            child: const ListTile(
                              title: Text(
                                'Contact',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'SourceSerifPro',
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 2),
                      child: Text(
                        "Pulkit Arora",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'SourceSerifPro',
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 5, 20, 6),
                      child: Text(
                        '"Director" of Arctano',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'SourceSerifPro',
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(8, 10, 8, 6),
              child: Text(
                "Our Vision",
                style: TextStyle(
                    fontSize: 25,
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'SourceSerifPro',
                    fontStyle: FontStyle.italic),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: Container(
                child: const Text(
                    "Arctano helps enterprise build great solution around web, mobile and desktop Application.We tend to create tangible value for our customers by not only developing bespoke applications but also consulting them by understanding their business objectives. We take the architects of several large websitesand portals receiving millions of visitors per month.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'SourceSerifPro',
                        fontStyle: FontStyle.italic)),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: Text(
                  "Many mobiles apps created by us are popular on IOS and android marketpalces. with a highly experienced management team and board of directors,Arctano is a global company with officers in India and a satisfied customer base in over countries.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'SourceSerifPro',
                      fontStyle: FontStyle.italic)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ContainerWidget(
                  images: "assets/bag.png",
                  variation: "Projects",
                  no: "100",
                ),
                ContainerWidget(
                  variation: "Countries",
                  no: "10",
                  images: "assets/globe.PNG",
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ContainerWidget(
                  variation: "Clinet",
                  no: "100",
                  images: "assets/smile.png",
                ),
                ContainerWidget(
                  variation: "Business Import",
                  no: "10",
                  images: "assets/handshake.png",
                ),
              ],
            ),
          ],
        ));
  }
}

// ignore: must_be_immutable
class ContainerWidget extends StatelessWidget {
  ContainerWidget({
    required this.no,
    required this.variation,
    required this.images,
    Key? key,
  }) : super(key: key);

  String variation;
  String no;
  String images;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Column(
        children: [
          Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[
                      Color(0xFF0D47A1),
                      Color(0xFF1976D2),
                      Color(0xFF42A5F5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.blue),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Image.asset(
                      images,
                      height: 60,
                      width: 60,
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        no,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        variation,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
