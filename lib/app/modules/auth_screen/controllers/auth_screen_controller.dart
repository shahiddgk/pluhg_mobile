import 'dart:io';
import 'dart:ui';

import 'package:country_code_picker/country_code.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plug/app/services/UserState.dart';
import 'package:plug/utils/location.dart';

class AuthScreenController extends GetxController {
  RxBool isNumber = false.obs;
  RxBool hasAccepted = false.obs;
  RxBool checked = false.obs;

  var currentCountryCode = ''.obs;
  var isoCountryCode = ''.obs;

  RxString deviceTokenString = ''.obs;

  double lat = 0, long = 0;
  RxBool isLoading = true.obs;
  final Size size = Get.size;

  @override
  void onInit() {
    super.onInit();
    fetchCountryCode();
    getDeviceToken();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  Future<bool> willPopCallback() async {
    exit(0);
  }

  bool isNumeric(String s) => int.tryParse(s) != null;

  getDeviceToken() async {
    deviceTokenString.value = (await FirebaseMessaging.instance.getToken())!;
  }

  Future<String> fetchCountryCode() async {
    print(
        "[AuthScreenController:fetchCountryCode] start fetching iso country code");
    User user = await UserState.get();
    String countryCode = '';
    if (user.countryCode.isNotEmpty) {
      countryCode = user.countryCode;
      print(
          "[AuthScreenController:fetchCountryCode] the code have been fetched from the User State [$countryCode]");
    } else {
      try {
        countryCode = await DeviceCountryCode.get();
        print(
            "[AuthScreenController:fetchCountryCode] the code has been fetched from the DeviceCountryCode [$countryCode]");
      } catch (e) {
        print(e);
      }
    }
    if (countryCode.isNotEmpty) {
      isoCountryCode.value = countryCode;
      user.countryCode = isoCountryCode.value;
      await UserState.store(user);
    } else {
      isoCountryCode.value = User.DEFAULT_COUNTRY_CODE;
    }

    isLoading.value = false;
    return isoCountryCode.value;
  }

  Future<void> updateCountryCode(CountryCode? countryCode) async {
    final isoCode = countryCode!.code ?? User.DEFAULT_COUNTRY_CODE;
    final dialCode = countryCode.dialCode ?? '';
    print(
        "[AuthScreenController:updateCountryCode] selected sim country code ($countryCode) [$isoCode]");

    isoCountryCode.value = isoCode;
    currentCountryCode.value = dialCode;
  }
}
