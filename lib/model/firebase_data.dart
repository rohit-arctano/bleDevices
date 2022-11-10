import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RoomModel {
  RoomModel({
    this.getDevice,
  });

  final List? getDevice;

  factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
        getDevice: List<GetDevice>.from(
            json["roomName"].map((x) => GetDevice.fromJson(x))),
      );

  static const String _roomName = "getDevice";
  Map<String, dynamic> toJson() => {
        _roomName: getDevice,
      };
}

// class GetRoom {
//   GetRoom(
//       {required this.roomId,
//       required this.roomName,
//       required this.deviceID,
//       this.deviceName});

//   final String roomId;
//   final String roomName;
//   final String deviceID;
//   final GetDevice? deviceName;

//   static const String _roomId = "roomId";
//   static const String _roomName = "roomName";
//   static const String _deviceId = "deviceID";
//   static const String _deviceName = "deviceName";
//   factory GetRoom.fromJson(Map<String, dynamic> json) => GetRoom(
//       roomId: json[_roomId],
//       roomName: json[_roomName],
//       deviceID: json[_deviceId],
//       deviceName: GetDevice.fromJson(json[_deviceName]));

//   Map<String, dynamic> toJson() => {
//         _roomId: roomId,
//         _roomName: roomName,
//         _deviceId: deviceID,
//         _deviceName: deviceName
//       };
// }

class GetDevice {
  GetDevice({required this.deviceName, this.switchName});

  final String deviceName;
  final List? switchName;

  static const String _deviceName = "deviceName";
  static const String _switchlist = "getSwitch";
  factory GetDevice.fromJson(Map<String, dynamic> json) => GetDevice(
      deviceName: json[_deviceName],
      switchName: List<GetSwitch>.from(
          json["roomName"].map((x) => GetDevice.fromJson(x))));

  Map<String, dynamic> toJson() =>
      {_deviceName: deviceName, _switchlist: switchName};
}

class GetSwitch {
  GetSwitch({this.switchName, this.switchStatus, this.switchEnable});
  // String? id;
  bool? switchEnable;
  bool? switchStatus;
  String? switchName;
// static const String _swtichId = ""
  static const String _switchName = "switchName";
  static const String _switchStatus = "status";
  static const String _switchEnable = "enable";

  // factory GetSwitch.fromSnapshot(
  //   List<QueryDocumentSnapshot<Object?>> streamSnapshot) {
  //   final check = streamSnapshot.
  //       ? "  streamsnapshot.data!.docs[index]"
  //       : "";
  //   return GetSwitch();
  // }

  factory GetSwitch.fromJson(Map<String, dynamic> json) => GetSwitch(
      switchName: json[_switchName],
      switchStatus: json[_switchStatus],
      switchEnable: json[_switchEnable]);

  Map<String, dynamic> toJson() => {
        _switchName: switchName,
        _switchStatus: switchStatus,
        _switchEnable: switchEnable
      };
}
