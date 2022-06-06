import 'dart:convert';

import 'package:plug/app/values/strings.dart';
import 'package:plug/utils/validation_mixin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserState with ValidationMixin {
  static Future<void> storeNewProfile(
      {required String token,
      required String name,
      required String contact,
      required String regionCode,
      required String countryCode}) async {
    // prefs.setString('profileImage',
    //     parsedResponse["data"]["userData"]["profileImage"].toString()); //TODO check the data it returns
    String email = EmailValidator.validate(contact) ? contact : '';
    String phone = PhoneValidator.validate(contact) ? contact : '';
    String code = regionCode.isNotEmpty ? regionCode : User.DEFAULT_REGION_CODE;
    String cCode =
        countryCode.isNotEmpty ? countryCode : User.DEFAULT_COUNTRY_CODE;
    User newUser = User.newProfile(
        name: name,
        token: token,
        regionCode: code,
        countryCode: cCode,
        phone: phone,
        email: email);

    await UserState.store(newUser);
    print(
        "[UserState:storeNewProfile] created a new user: ${newUser.toString()}");

    SharedPreferences storage = await SharedPreferences.getInstance();
    storage.setBool(PREF_IS_FIRST_APP_RUN, false);
    print("[UserState:storeNewProfile] PREF_IS_FIRST_APP_RUN: false");
  }

  static Future<void> logout() async {
    await store(User.empty());
  }

  static Future<void> store(User user) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    storage.setString(PREF_USER, user.toString());
  }

  static Future<User> get() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    final userData = storage.getString(PREF_USER);
    if (userData == null || userData.isEmpty) {
      print("[UserState:get] user not found, return empty");
      return User.empty();
    }

    Map<String, dynamic> userMap = jsonDecode(userData);
    return User.fromJson(userMap);
  }
}

class User {
  static const EMAIL_CONTACT_TYPE = "email";
  static const PHONE_CONTACT_TYPE = "phone";

  static const DEFAULT_REGION_CODE = 'US';
  static const DEFAULT_COUNTRY_CODE = '1';

  final String id;
  final String token;
  String name;
  String phone;
  String email;
  String dynamicLink;
  String regionCode;
  String countryCode;
  final bool isAuthenticated;

  void setEmail(String email) {
    this.email = email;
  }

  void setPhone(String phone) {
    this.phone = phone;
  }

  void setName(String name) {
    this.name = name;
  }

  void setDynamicLink(String link) {
    this.dynamicLink = link;
  }

  void setregionCode(String regionCode) {
    this.regionCode = regionCode.isNotEmpty ? regionCode : DEFAULT_REGION_CODE;
  }

  static bool isEmailContactType(String contactType) {
    return EMAIL_CONTACT_TYPE == contactType;
  }

  static bool isPhoneContactType(String contactType) {
    return PHONE_CONTACT_TYPE == contactType;
  }

  User({
    required this.id,
    required this.name,
    required this.token,
    required this.phone,
    required this.email,
    required this.dynamicLink,
    required this.regionCode,
    required this.countryCode,
    required this.isAuthenticated,
  });

  factory User.empty() {
    return User(
        id: "",
        name: "",
        token: "",
        phone: "",
        email: "",
        regionCode: "",
        dynamicLink: "",
        isAuthenticated: false,
        countryCode: "");
  }

  factory User.newProfile({
    required String name,
    required String token,
    required String phone,
    required String email,
    required String regionCode,
    required String countryCode,
  }) {
    return User(
      id: "",
      dynamicLink: "",
      name: name,
      token: token,
      phone: phone,
      email: email,
      regionCode: regionCode,
      countryCode: countryCode,
      isAuthenticated: true,
    );
  }

  factory User.registered({
    required String id,
    required String name,
    required String token,
    required String phone,
    required String email,
    required String regionCode,
    required String countryCode,
  }) {
    return User(
      id: id,
      name: name,
      token: token,
      phone: phone,
      email: email,
      regionCode: regionCode,
      countryCode: countryCode,
      dynamicLink: "",
      isAuthenticated: true,
    );
  }

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return new User(
      id: parsedJson['id'] ?? "",
      name: parsedJson['name'] ?? "",
      token: parsedJson['token'] ?? "",
      phone: parsedJson['phone'] ?? "",
      email: parsedJson['email'] ?? "",
      dynamicLink: parsedJson['dynamicLink'] ?? "",
      regionCode: parsedJson['regionCode'] ?? "",
      countryCode: parsedJson['countryCode'] ?? "",
      isAuthenticated: parsedJson['isAuthenticated'] ?? false,
    );
  }

  bool compareId(String userId) {
    return this.id == userId;
  }

  bool compareEmail(String email) {
    return this.email == email;
  }

  bool comparePhone(String phone) {
    return this.phone == phone;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
      "token": this.token,
      "phone": this.phone,
      "email": this.email,
      "dynamicLink": this.dynamicLink,
      "regionCode": this.regionCode,
      "countryCode": this.countryCode,
      "isAuthenticated": this.isAuthenticated,
    };
  }

  String toString() {
    return jsonEncode(this.toJson());
  }
}
