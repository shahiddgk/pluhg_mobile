import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/modules/auth_screen/views/auth_screen_view.dart';
import 'package:plug/app/services/UserState.dart';
import 'package:plug/app/widgets/snack_bar.dart';

class ConnecTwoScreenController extends GetxController {
  //TODO: Implement ConnectionScreenController
  dynamic profileDetails = {}.obs;
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
    APICALLS apicalls = APICALLS();
    profileDetails = await apicalls.getProfile();
    if (profileDetails == null) {
      return Get.offAll(() => AuthScreenView());
    }

    if (profileDetails["status"] == true) {
      User user = await UserState.get();

      String? email = profileDetails["data"]["emailAddress"];
      String? phone = profileDetails["data"]["phoneNumber"];
      if (email != null && email.isNotEmpty) {
        user.setEmail(email);
      }
      if (phone != null && phone.isNotEmpty) {
        user.setPhone(phone);
      }

      await UserState.store(user);
    } else {
      pluhgSnackBar("So sorry", "${profileDetails["message"]}");
    }

    isLoading.value = false;
  }
}
