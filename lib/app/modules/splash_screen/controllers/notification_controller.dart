import 'package:get/get.dart';

class NotificationController extends GetxController {
  RxBool receivedNotification = false.obs;

  void fcmNotificationReceived() {
    receivedNotification.value = true;
  }

  void fcmNotificationReset() {
    try {
      receivedNotification.value = false;
    }
    catch(e){
      print(e.toString());
    }
  }
}