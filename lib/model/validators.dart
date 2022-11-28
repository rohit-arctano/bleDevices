class Validators {
  static String? password(String? password) {
    if (password == null) {
      return "Enter password";
    }
    if (password.isEmpty) {
      return "Enter password";
    }
    if (!password.contains(RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*\W).{6,15}$'))) {
      if (password.length < 6 || password.length > 15) {
        return "Password length should be 6 to 15";
      }
      String error = "Password requires";
      List<_RegExMessage> conditionsToCheck = [
        _RegExMessage(regExp: RegExp(r'^(?=.*[A-Z])'), message: "1 uppercase"),
        _RegExMessage(regExp: RegExp(r'^(?=.*[a-z])'), message: "1 lowercase"),
        _RegExMessage(regExp: RegExp(r'^(?=.*\d)'), message: "1 digit"),
        _RegExMessage(regExp: RegExp(r'^(?=.*\W)'), message: "1 character"),
      ];
      for(int i = 0; i < conditionsToCheck.length; i++) {
        if (!password.contains(conditionsToCheck[i].regExp)) {
          error += " ${conditionsToCheck[i].message},";
        }
      }
      error = '${error.substring(0, error.length - 1)}.';
      return error;
    }
    return null;
  }

  static String? email(String? email) {
    if (email == null) {
      return "Enter password";
    }
    if (email.isEmpty) {
      return "Enter password";
    }
    if (!email.contains(RegExp(r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$'))) {
      return "Invalid email";
    }
    return null;
  }
}

class _RegExMessage {
  const _RegExMessage({
    required this.regExp,
    required this.message,
  });

  final RegExp regExp;
  final String message;
}
