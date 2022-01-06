import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/modules/splash_screen/controllers/notification_controller.dart';

class NotificationScreenController extends GetxController {
  //TODO: Implement NotificationScreenController
  dynamic data = {};
  RxBool read = false.obs;
  final count = 0.obs;
  APICALLS apicalls = APICALLS();
  final notificationController = Get.put(NotificationController());
  @override
  void onInit() {
    super.onInit();
    getNotificationList();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  getNotificationList() async {
    notificationController.fcmNotificationReset();
    return await apicalls.getNotifications();
  }
}
