//Validation Mixin for all util methods
mixin ValidationMixin {
  // Remove special characters from phone number
  String formatPhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAll(RegExp(r'[\-() ]'), '');
  }

  bool comparePhoneNumber(String string1, String string2) {
    return string1.replaceAll(" ", "").toLowerCase().trim() == string2.replaceAll(" ", "").toLowerCase().trim();
  }
}

class PhoneValidator {
  static bool validate(String data) {
    String pattern = r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,8}$)';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(data);
  }
}

class EmailValidator {
  static bool validate(String data) {
    String pattern =
        r'(^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$)';
    RegExp regExp = new RegExp(pattern);
    bool hasmatch = regExp.hasMatch(data);
    return hasmatch;
  }
}
