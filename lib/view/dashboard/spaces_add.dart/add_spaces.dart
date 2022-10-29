import 'package:bldevice_connection/constant/textstyle_constant.dart';
import 'package:bldevice_connection/widget/customtextField.dart';
import 'package:flutter/material.dart';

class AddDevice extends StatefulWidget {
  const AddDevice({super.key});

  @override
  State<AddDevice> createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {
  final TextEditingController placeName = TextEditingController();
  final TextEditingController roomType = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    child: const Icon(Icons.arrow_back, color: Colors.grey),
                    // onTap: () => scaffoldKey.currentState?.openDrawer(),
                  ),
                  const SizedBox(
                    width: 150,
                  ),
                  const Text(
                    "Spaces",
                    style: kDBXLTextStyle,
                  ),
                ],
              ),
              CustomTextField(
                controller: placeName,
                data: Icons.house,
                hintText: 'Place Name',
              ),
              CustomTextField(
                controller: roomType,
                data: Icons.room,
                hintText: 'Place Name',
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text("Add Images"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
