import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/modules/home/controllers/home_controller.dart';
import 'package:plug/app/modules/splash_screen/controllers/notification_controller.dart';
import 'package:plug/models/notification_response.dart';

class NotificationScreenController extends GetxController {
  //TODO: Implement NotificationScreenController
  dynamic data = {};
  RxMap<String, bool> read = <String, bool>{}.obs;
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
    var result = await apicalls.getNotifications();

    ///Read All notification
    //
    // readAllNotification(result);

    return result;
  }

  readAllNotification(dynamic result)async {
    NotificationResponse notificationResponse = result;

    var list = notificationResponse.data.map((e) => e.id).toList();

    final body = {
      "notificationId": list
    };

    await apicalls.markAsRead(body);
    Get.find<HomeController>().notificationCount.value = 0;
  }

  Future<bool> markAsRead(NotificationData notification) async {
    final body = {
      "notificationId": [notification.id]
    };
    final isRead = await apicalls.markAsRead(body);
    read[notification.id] = isRead;
    return isRead;
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
