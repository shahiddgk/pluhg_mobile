import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:get/get.dart';

class SetProfileScreenController extends GetxController {
  //TODO: Implement ProfileScreenController
  var currentCountryCode = ''.obs;
  RxBool isLoading = false.obs;
  RxString countryISOCode = ''.obs;
  RxDouble lat = 0.0.obs, long = 0.0.obs;
  final size = Get.size;
  @override
  void onInit() {
    fetchCountryCode();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

//fetch country code without location using FlutterSimCountryCode
  Future<String> fetchCountryCode() async {
    final countryCode = await FlutterSimCountryCode.simCountryCode;
    currentCountryCode.value = countryCode!;
    return currentCountryCode.value;
  }
}
