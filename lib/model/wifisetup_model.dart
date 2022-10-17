class CustomDeviceCredentials {
  final String user;
  final String ssid;
  final String password;

  static const String _userKey = 'UserID';
  static String _ssid = 'newid';
  static String _password = "new password";

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
