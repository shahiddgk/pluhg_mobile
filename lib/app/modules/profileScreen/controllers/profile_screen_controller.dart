import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/modules/AuthScreen/views/auth_screen_view.dart';
import 'package:plug/app/widgets/snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreenController extends GetxController {
  //TODO: Implement ProfileScreenController
  dynamic profileDetails = {}.obs;
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
  Future fetchProfileDetails() async {
    isLoading.value = true;
    APICALLS apicalls = APICALLS();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    profileDetails = await apicalls.getProfile(
      token: prefs.get("token").toString(),
    );
    if (profileDetails == null) {
      return Get.offAll(AuthScreenView());
    }
   else if (profileDetails['status'] == true) {
      isLoading.value = false;
      return profileDetails['data'];
    } else {
      isLoading.value = false;
      pluhgSnackBar("So sorry", "${profileDetails['message']}");
      return null;
    }
  }
}
