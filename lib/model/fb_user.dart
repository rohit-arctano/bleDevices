import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

class FbUser {
  FbUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.mobileNo,
  });

  factory FbUser.fromUser({required User user}) {
    String uid = user.uid;
    String email = user.email ?? '';
    String name = user.displayName ?? '';
    String mobileNo = user.photoURL ?? '';
    return FbUser(
      uid: uid,
      email: email,
      name: name,
      mobileNo: mobileNo,
    );
  }

  factory FbUser.fromJson({required Map<String, dynamic> json}) {
    final String uid = json.containsKey(_uidkey) ? json[_uidkey] : "";
    final String email = json.containsKey(_emailKey) ? json[_emailKey] : '';
    return FbUser(
        uid: uid, email: email, name: json[_nameKey], mobileNo: json[_urlKey]);
  }
  static const String _uidkey = "uid";
  static const String _emailKey = "email";
  static const String _nameKey = "name";
  static const String _urlKey = "mobileNo";

  Map<String, dynamic> toJson() {
    return {
      _uidkey: uid,
      _emailKey: email,
      _nameKey: name,
      _urlKey: mobileNo,
    };
  }

  final String uid;
  final String name;
  final String mobileNo;
  final String email;
}
