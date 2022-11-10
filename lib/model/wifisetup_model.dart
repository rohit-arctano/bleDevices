class CustomDeviceCredentials {
  final String user;
  final String ssid;
  final String password;

  static const String _userKey = 'UserID';
  static const String _ssid = 'newid';
  static const String _password = "newpassword";

  const CustomDeviceCredentials(
      {required this.user, required this.ssid, required this.password});

  factory CustomDeviceCredentials.fromJson(Map<String, dynamic> json) =>
      CustomDeviceCredentials(
        user: json[_userKey],
        ssid: json[_ssid],
        password: json[_password],
      );

  Map<String, dynamic> toJson() => {
        _userKey: user,
        _ssid: ssid,
        _password: password,
      };
}
