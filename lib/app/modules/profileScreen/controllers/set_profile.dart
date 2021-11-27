import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:plug/widgets/dialog_box.dart';

class SetProfileScreenController extends GetxController {
  //TODO: Implement ProfileScreenController
  var currentCountryCode = ''.obs;
  RxBool isLoading = false.obs;
  RxString countryISOCode = ''.obs;
  RxDouble lat = 0.0.obs, long = 0.0.obs;
  final size = Get.size;
  @override
  void onInit() {
    super.onInit();
    determinePosition();
    Geolocator.requestPermission();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  Future<Position> determinePosition() async {
    bool serviceEnabled;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      print("true");
      Geolocator.getCurrentPosition().then((Position position) async {
        print(position);

        long.value = position.longitude;
        lat.value = position.latitude;

        if (long.value > 0 && lat.value > 0) {
          List<Placemark> placemarks =
              await placemarkFromCoordinates(lat.value, long.value);
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
          () => Geolocator.openLocationSettings());

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
