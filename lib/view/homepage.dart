import 'package:bldevice_connection/constant/textstyle_constant.dart';
import "package:flutter/material.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Size? screenSize;
  var position = 0;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  List<String> banners = [];

  fetchData() async {
    List<String> banner = [];
    for (var i = 1; i < 4; i++) {
      banner.add("assets/images/room$i.jpg");
    }
    banners.clear();
    banners.addAll(banner);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [
                Text(
                  "Hello! \nGood morning Caretto",
                  style: kDBXLTextStyle,
                ),
                Spacer(),
                CircleAvatar(
                  radius: 35.0,
                  backgroundImage: NetworkImage(
                      'https://media.istockphoto.com/photos/millennial-male-team-leader-organize-virtual-workshop-with-employees-picture-id1300972574?b=1&k=20&m=1300972574&s=170667a&w=0&h=2nBGC7tr0kWIU8zRQ3dMg-C5JLo9H2sNUuDjQ5mlYfo='),
                  backgroundColor: Colors.transparent,
                )
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(32)),
            height: MediaQuery.of(context).size.height * 0.55,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: banners.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            banners[index],
                            fit: BoxFit.fitHeight,
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.width * 0.6,
                          ),
                        ),
                        Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width * 0.6,
                          color: Colors.transparent,
                        )
                      ],
                    ),
                  );
                },
                // onPageChanged: (index) {
                //   setState(() {
                //     position = index;
                //   });
                // },
              ),
            ),
          ),
        ],
      ),
    )));
  }
}
