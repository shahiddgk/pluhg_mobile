import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class DeviceCountryCode {
  static Future<String> get() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    String countryCode = '';
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('[DeviceCountryCode] location permissions are denied');
        return countryCode;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      print('[DeviceCountryCode] location permissions are permanently denied, we cannot request permissions.');
      return countryCode;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print("[DeviceCountryCode] device position [${position.toString()}]");
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print("[DeviceCountryCode] placemarks [${placemarks.first.toString()}]");

    if (placemarks.length == 0 || placemarks.first.isoCountryCode == null) {
      return countryCode;
    }

    countryCode = placemarks.first.isoCountryCode!;
    print("[DeviceCountryCode] iso country code [$countryCode]");
    return countryCode;
  }
}
