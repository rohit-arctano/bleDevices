import 'dart:convert';

import 'package:bldevice_connection/model/fb_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {
///   "isLoggedIn" : bool,
///   "userData" : Map<String, dynamic>,
///   },
/// }

class SavePreferences {
  static const String _logInKey = "isLoggedIn";
  static const String _userdataKey = "userData";

//set data into shared preferences like this
  Future<bool> setUserData({required String data}) async {
    final SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_userdataKey, data);
  }

//get value from shared preferences
  // Future<FbUser> getUserData() async {
  //   final SharedPreferences prefs;
  //   prefs = await SharedPreferences.getInstance();
  //   String? datatrue = prefs.getString(_userdataKey);
  //   print(datatrue);
  //   print(datatrue);
  //   Map<String, dynamic> jsonData = jsonDecode(datatrue ?? "");
  //   FbUser userData = FbUser.fromJson(json: jsonData);

  //   // print("the user data is $userData");
  //   return userData;
  // }

  Future<bool> saveUserData(User user) async {
    final SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    FbUser userData = FbUser.fromUser(user: user);
    Map<String, dynamic> userjson = userData.toJson();
    String userString = jsonEncode(userjson);
    bool datatrue = await prefs.setString(_userdataKey, userString);
    return datatrue;
  }

  /// Returns true when log in successful
  Future<bool> logIn() async {
    final SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_logInKey, true);
  }

  /// Returns true when log out successful
  Future<bool> logOut() async {
    final SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_logInKey, false);
    // print(userData);
  }

  Future<bool?> getLogInStatus() async {
    final SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_logInKey);
  }
}
