import 'package:get/get.dart';

class SupportScreenController extends GetxController {
  //TODO: Implement SupportScreenController
  final size = Get.size;
  RxBool isLoading = false.obs;
  final count = 0.obs;
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
  void increment() => count.value++;
}
