import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsController extends GetxController {
  //TODO: Implement NotificationScreenController
  RxBool email = false.obs;
  RxBool push = false.obs;
  RxBool text = false.obs;
  final size = Get.size;
  RxBool isloading = false.obs;
  dynamic notificationDetails = {}.obs;

  @override
  void onInit() {
    super.onInit();
    getData1();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  getData1() async {
    APICALLS apicalls = APICALLS();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.get(preftoken));
    print(prefs.get(prefuserid));

    // getData();
    var notificationDetails = await apicalls.getNotificationSettings(
      token: prefs.get(preftoken).toString(),
    );
    if (notificationDetails["data"] != null) {
      push.value = notificationDetails["data"]["pushNotification"];
      email.value = notificationDetails["data"]["emailNotification"];
      text.value = notificationDetails["data"]["textNotification"];
    }
  }
}
