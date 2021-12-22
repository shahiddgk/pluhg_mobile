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
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
