import 'dart:async';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plug/app/data/http_manager.dart';
import 'package:plug/app/data/models/request/notification_request_model.dart';
import 'package:plug/app/data/models/response/notification_response_model.dart';
import 'package:plug/app/modules/splash_screen/controllers/notification_controller.dart';

import '../../../services/UserState.dart';
import '../../../widgets/snack_bar.dart';
import '../../home/controllers/home_controller.dart';

class NotificationScreenController extends GetxController {
  //TODO: Implement NotificationScreenController
  Rx<NotificationListModel> data = NotificationListModel().obs;
  Completer<NotificationListModel> notificationFuture = Completer();
  RxMap<String, bool> read = <String, bool>{}.obs;
  final count = 0.obs;
  Rx<User> user = User.empty().obs;

  final notificationController = Get.put(NotificationController());

  @override
  Future<void> onInit() async {
    super.onInit();
    this.user.value = await UserState.get();
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
  }

  markAsRead(int index, NotificationResponseModel notification) async {
    HTTPManager()
        .readNotifications(
            NotificationRequestModel(notificationId: [notification.sId!]))
        .then((value) {
      // read[notification?.sId ?? ""] = value.status!;
      // data.value.values[index].status = value.status! ? 1 : 0;
      //Get.put(HomeController()).notificationCount.value = value.data;
      data.value = value;
      Get.put(HomeController()).notificationCount.value =
          value.values.where((element) => element.status == 0).length;
    }).catchError((onError) {
      pluhgSnackBar('Sorry', onError.toString());
    });
  }

  deleteNotification(int index, NotificationResponseModel notification) async {
    HTTPManager()
        .deleteNotifications(
            NotificationRequestModel(notificationId: [notification.sId!]))
        .then((value) {
      data.value = value;
      Get.put(HomeController()).notificationCount.value =
          value.values.where((element) => element.status == 0).length;
    }).catchError((onError) {
      pluhgSnackBar('Sorry', onError.toString());
    });
  }

  getTimeDifference(String date) {
    DateTime time = DateTime.parse(date).toLocal();
    if (DateTime.now().difference(time).inMinutes < 1) {
      return "just now";
    } else if (DateTime.now().difference(time).inMinutes < 60) {
      return "${DateTime.now().difference(time).inMinutes} min";
    } else if (DateTime.now().difference(time).inHours > 0) {
      return "${DateTime.now().difference(time).inHours} hours";
    } else if (DateTime.now().difference(time).inDays > 0) {
      return "${DateTime.now().difference(time).inDays} days";
    }
  }

  String dateTimeFormatter(String dateTime, {String? format}) {
    return DateFormat(format ?? 'yyyy/MM/dd, hh:mm a')
        .format(DateTime.parse(dateTime).toLocal())
        .toString();
  }
}
