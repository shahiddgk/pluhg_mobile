import 'package:get/get.dart';
import 'package:plug/app/data/http_manager.dart';
import 'package:plug/app/data/models/response/verify_otp_response_model.dart';

class ProfileScreenController extends GetxController {
  //TODO: Implement ProfileScreenController
  Rx<UserData> profileDetails = UserData().obs;
  RxBool isLoading = false.obs;
  final size = Get.size;

  @override
  void onInit() {
    super.onInit();
    fetchProfileDetails();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  Future<UserData> fetchProfileDetails() async {
    isLoading.value = true;
    //APICALLS apicalls = APICALLS();
    profileDetails.value = await HTTPManager().getProfileDetails();
    isLoading.value = false;
    return profileDetails.value;
    // if (profileDetails == null) {
    //   return Get.offAll(() => AuthScreenView());
    // } else if (profileDetails['status'] == true) {
    //   isLoading.value = false;
    //   return profileDetails['data'];
    // } else {
    //   isLoading.value = false;
    //   pluhgSnackBar("So sorry", "${profileDetails['message']}");
    //   return null;
    // }
  }
}
