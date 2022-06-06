import 'package:get/get.dart';
import 'package:plug/app/data/http_manager.dart';
import 'package:plug/app/data/models/response/verify_otp_response_model.dart';

class ConnecTwoScreenController extends GetxController {
  //TODO: Implement ConnectionScreenController
  Rx<UserData> profileDetails = UserData().obs;
  RxBool isLoading = false.obs;
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getInfo();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void increment() => count.value++;

  Future getInfo() async {
    isLoading.value = true;
    //APICALLS apicalls = APICALLS();
    profileDetails.value = await HTTPManager().getProfileDetails();
    isLoading.value = false;
    return profileDetails.value;
    // if (profileDetails == null) {
    //   return Get.offAll(() => AuthScreenView());
    // }
    //
    // if (profileDetails["status"] == true) {
    //   User user = await UserState.get();
    //
    //   String? email = profileDetails["data"]["emailAddress"];
    //   String? phone = profileDetails["data"]["phoneNumber"];
    //   if (email != null && email.isNotEmpty) {
    //     user.setEmail(email);
    //   }
    //   if (phone != null && phone.isNotEmpty) {
    //     user.setPhone(phone);
    //   }
    //
    //   await UserState.store(user);
    // } else {
    //   pluhgSnackBar("So sorry", "${profileDetails["message"]}");
    // }
    //
    // isLoading.value = false;
  }
}
