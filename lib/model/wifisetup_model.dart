class CustomDeviceCredentials {
  final String ssid;
  final String password;

  static const String _ssid = 'newid';
  static const String _password = "newpassword";

  const CustomDeviceCredentials({required this.ssid, required this.password});

  factory CustomDeviceCredentials.fromJson(Map<String, dynamic> json) =>
      CustomDeviceCredentials(
        ssid: json[_ssid],
        password: json[_password],
      );

  Map<String, dynamic> toJson() => {
        _ssid: ssid,
        _password: password,
      };
}
