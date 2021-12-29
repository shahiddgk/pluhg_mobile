//Validation Mixin for all util methods
mixin ValidationMixin {
  // Remove special characters from phone number
  String formatPhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAll(RegExp(r'[\-() ]'), '');
  }

  bool comparePhoneNumber(String string1, String string2) {
    return string1.replaceAll(" ", "").toLowerCase().trim() == string2.replaceAll(" ","").toLowerCase().trim();
  }
}
