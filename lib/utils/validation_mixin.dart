//Validation Mixin for all util methods
mixin ValidationMixin {
  // Remove special characters from phone number
  String formatPhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAll(RegExp(r'[\-() ]'), '');
  }
}
