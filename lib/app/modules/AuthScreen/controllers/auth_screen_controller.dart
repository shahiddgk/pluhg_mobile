import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:plug/widgets/dialog_box.dart';

class AuthScreenController extends GetxController {
  //TODO: Implement AuthScreenController
  var isNumber = false.obs;
  var hasAccepted = false.obs;
  RxBool checked = false.obs;
  var currentCountryCode = ''.obs;
  var isoCountryCode = ''.obs;
  RxString deviceTokenString = ''.obs;

  double lat = 0, long = 0;
  RxBool isLoading = false.obs;
  final size = Get.size;
  @override
  void onInit() {
    super.onInit();
    determinePosition();
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

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  getDeviceToken() async {
    deviceTokenString.value = (await FirebaseMessaging.instance.getToken())!;
  }

  Future<String> determinePosition() async {
    String? platformVersion = await FlutterSimCountryCode.simCountryCode;
    isoCountryCode.value = platformVersion!;
    return isoCountryCode.value;
  }
}
