import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:plug/app/widgets/dialog_box.dart';

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
    determinePosition();
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

  Future<Position> determinePosition() async {
    bool serviceEnabled;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      print("true");
      Geolocator.getCurrentPosition().then((Position position) async {
        print(position);

        long = position.longitude;
        lat = position.latitude;

        if (long > 0 && lat > 0) {
          List<Placemark> placemarks =
              await placemarkFromCoordinates(lat, long);
          print(placemarks);

          countryISOCode.value = placemarks[0].isoCountryCode.toString();
          print(countryISOCode);
          print("countryISOCode");
        }
      });
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
      return Future.error('Location services are disabled.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
