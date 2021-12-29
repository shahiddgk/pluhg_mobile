import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/modules/auth_screen/views/auth_screen_view.dart';
import 'package:plug/app/values/strings.dart';
import 'package:plug/app/widgets/snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    SharedPreferences pref = await SharedPreferences.getInstance();
    APICALLS apicalls = APICALLS();
    profileDetails = await apicalls.getProfile();
    if (profileDetails == null) {
      return Get.offAll(AuthScreenView());
    }
    else if (profileDetails["status"] == true) {
      pref.setString(prefuseremail, profileDetails["data"]["emailAddress"]);
      pref.setString(prefuserphone, profileDetails["data"]["phoneNumber"]);
      isLoading.value = false;
    } else {
      isLoading.value = false;
      pluhgSnackBar("So sorry", "${profileDetails["message"]}");
    }
  }
}
