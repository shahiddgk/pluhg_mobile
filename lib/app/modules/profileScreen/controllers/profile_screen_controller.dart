import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';
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
        userID: prefs.get("userID").toString());
    if (profileDetails["hasError"] == false) {
      isLoading.value = false;
      return profileDetails['data'];
    } else {
      isLoading.value = false;
      pluhgSnackBar("So sorry", "Error occured here, Refresh");
      return null;
    }
  }
}
