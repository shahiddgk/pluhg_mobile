import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';

class NotificationScreenController extends GetxController {
  //TODO: Implement NotificationScreenController
  dynamic data = {};
  RxBool read = false.obs;
  final count = 0.obs;
  APICALLS apicalls = APICALLS();
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
    return await apicalls.getNotifications();
  }
}
