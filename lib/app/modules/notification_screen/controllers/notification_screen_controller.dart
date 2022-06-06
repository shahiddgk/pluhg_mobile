import 'dart:async';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plug/app/data/http_manager.dart';
import 'package:plug/app/data/models/request/notification_request_model.dart';
import 'package:plug/app/data/models/response/notification_response_model.dart';
import 'package:plug/app/modules/splash_screen/controllers/notification_controller.dart';

import '../../../widgets/snack_bar.dart';

class NotificationScreenController extends GetxController {
  //TODO: Implement NotificationScreenController
  Rx<NotificationListModel> data = NotificationListModel().obs;
  Completer<NotificationListModel> notificationFuture = Completer();
  RxMap<String, bool> read = <String, bool>{}.obs;
  final count = 0.obs;

  //APICALLS apicalls = APICALLS();
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
    data.value = await HTTPManager().getNotifications();
    return data;
    // HTTPManager().getNotifications().then((value) {
    //   data.value = value;
    //   notificationFuture.complete(data.value);
    // }).catchError((onError) {});
    // var result = await apicalls.getNotifications();
    //
    // ///Read All notification
    // //
    // // readAllNotification(result);
    //
    // return result;
  }

  // readAllNotification(dynamic result) async {
  //   NotificationResponse notificationResponse = result;
  //
  //   var list = notificationResponse.data.map((e) => e.id).toList();
  //
  //   final body = {"notificationId": list};
  //
  //   await apicalls.markAsRead(body);
  //   Get.find<HomeController>().notificationCount.value = 0;
  // }

  markAsRead(int index, NotificationResponseModel notification) async {
    // final body = {
    //   "notificationId": [notification.sId]
    // };
    HTTPManager()
        .readNotifications(
            NotificationRequestModel(notificationId: [notification.sId!]))
        .then((value) {
      read[notification?.sId ?? ""] = value.status!;
      data.value.values[index].status = value.status! ? 1 : 0;
    }).catchError((onError) {
      pluhgSnackBar('Sorry', onError.toString());
    });
    // final isRead = await apicalls.markAsRead(body);
    // read[notification?.sId ?? ""] = isRead;
    // return isRead;
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
