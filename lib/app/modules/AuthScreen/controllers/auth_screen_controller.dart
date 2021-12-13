import 'dart:io';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:get/get.dart';

class AuthScreenController extends GetxController {
  RxBool isNumber = false.obs;
  RxBool hasAccepted = false.obs;
  RxBool checked = false.obs;

  var currentCountryCode = ''.obs;
  var isoCountryCode = 'US'.obs;

  RxString deviceTokenString = ''.obs;

  double lat = 0, long = 0;
  RxBool isLoading = false.obs;
  final Size size = Get.size;

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

  bool isNumeric(String s) => int.tryParse(s) != null;

  getDeviceToken() async {
    deviceTokenString.value = (await FirebaseMessaging.instance.getToken())!;
  }

  Future<String> determinePosition() async {
    final platformVersion = await FlutterSimCountryCode.simCountryCode;
    isoCountryCode.value = platformVersion!;
    return isoCountryCode.value;
  }
}
