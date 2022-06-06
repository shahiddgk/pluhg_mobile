import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/data/models/response/verify_otp_response_model.dart';

class EditProfileController extends GetxController {
  //TODO: Implement ContactController
  Rxn<XFile> image = Rxn();
  Rx<UserData> data2 = UserData().obs;
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
