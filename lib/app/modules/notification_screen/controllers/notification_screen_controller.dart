import 'package:get/get.dart';
import 'package:intl/intl.dart';
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

  Future<bool> markAsRead(body) async {
    return await apicalls.markAsRead(body);
  }

  getTimeDifference(String date) {
    DateTime time = new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date);
    if (DateTime.now().difference(time).inMinutes < 1) {
      return "just now";
    } else if (DateTime.now().difference(time).inMinutes < 60) {
      return "${DateTime.now().difference(time).inHours} min";
    } else if (DateTime.now().difference(time).inMinutes < 1440) {
      return "${DateTime.now().difference(time).inHours} hours";
    } else if (DateTime.now().difference(time).inMinutes > 1440) {
      return "${DateTime.now().difference(time).inDays} days";
    }
  }
}
