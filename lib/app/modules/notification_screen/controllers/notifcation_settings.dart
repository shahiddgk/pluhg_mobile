import 'package:get/get.dart';
import 'package:plug/app/data/http_manager.dart';
import 'package:plug/app/services/UserState.dart';
import 'package:plug/app/widgets/snack_bar.dart';

class NotificationSettingsController extends GetxController {
  //TODO: Implement NotificationScreenController
  RxBool email = false.obs;
  RxBool push = false.obs;
  RxBool text = false.obs;
  final size = Get.size;
  RxBool isloading = false.obs;

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
    //APICALLS apicalls = APICALLS();
    User user = await UserState.get();
    print("[getData1] user token [${user.token}] & user ID [${user.id}]");

    // getData();

    HTTPManager().getNotificationSettings().then((value) {
      push.value = value.pushNotification!;
      email.value = value.emailNotification!;
      text.value = value.textNotification!;
    }).catchError((onError) {
      pluhgSnackBar('Sorry', onError.toString());
    });
    // if (notificationDetails["data"] != null) {
    //   push.value = notificationDetails.pushNotification!;
    //   email.value = notificationDetails.emailNotification!;
    //   text.value = notificationDetails.textNotification;
    // }
  }
}
