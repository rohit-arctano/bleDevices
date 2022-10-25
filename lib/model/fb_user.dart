import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

class FbUser {
  FbUser({
    required this.email,
    required this.name,
    required this.url,
  });

  factory FbUser.fromUser({required User user}) {
    String email = user.email ?? '';
    String name = user.displayName ?? '';
    String url = user.photoURL ?? '';
    return FbUser(
      email: email,
      name: name,
      url: url,
    );
  }

  factory FbUser.fromJson({required Map<String, dynamic> json}) {
    final String email = json.containsKey(_emailKey) ? json[_emailKey] : '';
    return FbUser(email: email, name: json[_nameKey], url: json[_urlKey]);
  }

  static const String _emailKey = "email";
  static const String _nameKey = "name";
  static const String _urlKey = "url";

  Map<String, dynamic> toJson() {
    return {
      _emailKey: email,
      _nameKey: name,
      _urlKey: url,
    };
  }

  final String name;
  final String url;
  final String email;
}
