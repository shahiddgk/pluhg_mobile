import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plug/app/data/api_calls.dart';

class EditProfileController extends GetxController {
  //TODO: Implement ContactController
  Rxn<XFile> image = Rxn();
  dynamic data2 = {}.obs;
  RxString first = "".obs;
  RxBool isloading = false.obs;
  final size = Get.size;
  RxString addrees = "".obs;
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
