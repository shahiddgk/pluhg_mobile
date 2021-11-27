import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
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
  RxString deviceTokenString = ''.obs;
  RxString countryISOCode = ''.obs;
  double lat = 0, long = 0;
  RxBool isLoading = false.obs;
  final size = Get.size;
  @override
  void onInit() {
    super.onInit();
    // determinePosition();
    Geolocator.requestPermission();
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
    bool serviceEnabled;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      Position position = await Geolocator.getCurrentPosition();
      print(position);

      long = position.longitude;
      lat = position.latitude;

      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
      return placemarks[0].isoCountryCode.toString();
    }
    if (!serviceEnabled) {
      Geolocator.requestPermission();
      showPluhgDailog3(Get.context!, "So sorry", "Turn your device location",
          () {
        Geolocator.openLocationSettings();
        Get.back();
      });

      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return '';
    }
    return determinePosition();
  }
}
